;; EduCred - Blockchain Academic Certificate Verifier (Optimized)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-INVALID-INPUT (err u102))
(define-constant ERR-ALREADY-VERIFIED (err u103))

;; Contract owner
(define-constant CONTRACT-OWNER tx-sender)

;; Data maps
(define-map certificates
  { certificate-id: uint }
  {
    student: principal,
    institution: (string-ascii 100),
    degree: (string-ascii 50),
    major: (string-ascii 100),
    grad-date: uint,
    gpa: uint,
    cert-hash: (buff 32),
    verified: bool,
    issued-at: uint
  }
)

(define-map institutions
  { addr: principal }
  { name: (string-ascii 100), active: bool }
)

(define-map student-certs
  { student: principal }
  { cert-ids: (list 50 uint) }
)

;; NFT for diplomas
(define-non-fungible-token diploma uint)

;; Counters
(define-data-var next-id uint u1)

;; Validation helpers
(define-private (valid-principal (p principal))
  (not (is-eq p 'SP000000000000000000002Q6VF78))
)

(define-private (valid-cert-id (id uint))
  (and (> id u0) (< id (var-get next-id)))
)

(define-private (valid-date (date uint))
  (and (> date u20200101) (< date u20301231))
)

;; Admin functions
(define-public (add-institution (addr principal) (name (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (valid-principal addr) ERR-INVALID-INPUT)
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (ok (map-set institutions { addr: addr } { name: name, active: true }))
  )
)

(define-public (verify-certificate (cert-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (valid-cert-id cert-id) ERR-INVALID-INPUT)
    (match (map-get? certificates { certificate-id: cert-id })
      cert (begin
        (asserts! (not (get verified cert)) ERR-ALREADY-VERIFIED)
        (ok (map-set certificates 
          { certificate-id: cert-id }
          (merge cert { verified: true })
        ))
      )
      ERR-NOT-FOUND
    )
  )
)

;; Institution functions
(define-public (issue-certificate
  (student principal)
  (institution (string-ascii 100))
  (degree (string-ascii 50))
  (major (string-ascii 100))
  (grad-date uint)
  (gpa uint)
  (cert-hash (buff 32)))
  (let ((cert-id (var-get next-id)))
    (asserts! (default-to false (get active (map-get? institutions { addr: tx-sender }))) ERR-NOT-AUTHORIZED)
    (asserts! (valid-principal student) ERR-INVALID-INPUT)
    (asserts! (valid-date grad-date) ERR-INVALID-INPUT)
    (asserts! (> (len cert-hash) u0) ERR-INVALID-INPUT)
    (asserts! (<= gpa u400) ERR-INVALID-INPUT)
    
    (map-set certificates
      { certificate-id: cert-id }
      {
        student: student,
        institution: institution,
        degree: degree,
        major: major,
        grad-date: grad-date,
        gpa: gpa,
        cert-hash: cert-hash,
        verified: false,
        issued-at: stacks-block-height
      }
    )
    
    (try! (nft-mint? diploma cert-id student))
    (var-set next-id (+ cert-id u1))
    (ok cert-id)
  )
)

;; Read-only functions
(define-read-only (get-certificate (cert-id uint))
  (if (valid-cert-id cert-id)
    (map-get? certificates { certificate-id: cert-id })
    none
  )
)

(define-read-only (get-student-certificates (student principal))
  (if (valid-principal student)
    (map-get? student-certs { student: student })
    none
  )
)

(define-read-only (is-verified (cert-id uint))
  (if (valid-cert-id cert-id)
    (default-to false (get verified (map-get? certificates { certificate-id: cert-id })))
    false
  )
)
