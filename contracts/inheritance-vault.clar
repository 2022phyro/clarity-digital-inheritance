;; Digital Inheritance System Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-beneficiary (err u101))
(define-constant err-already-claimed (err u102))
(define-constant err-owner-alive (err u103))
(define-constant err-invalid-proof (err u104))

;; Data vars
(define-map inheritances
    principal
    {
        beneficiary: principal,
        amount: uint,
        claimed: bool,
        deadline: uint
    }
)

(define-map proofs-of-life 
    principal 
    {last-proof: uint}
)

;; Public functions
(define-public (create-inheritance (beneficiary principal) (amount uint) (deadline uint))
    (if (is-eq tx-sender contract-owner)
        (begin
            (map-set inheritances tx-sender {
                beneficiary: beneficiary,
                amount: amount,
                claimed: false,
                deadline: deadline
            })
            (map-set proofs-of-life tx-sender {last-proof: block-height})
            (ok true))
        err-owner-only)
)

(define-public (prove-life)
    (begin
        (map-set proofs-of-life tx-sender {last-proof: block-height})
        (ok true))
)

(define-public (claim-inheritance (owner principal))
    (let (
        (inheritance (unwrap! (map-get? inheritances owner) (err u404)))
        (proof (unwrap! (map-get? proofs-of-life owner) (err u404)))
    )
    (if (and
        (is-eq (get beneficiary inheritance) tx-sender)
        (not (get claimed inheritance))
        (> block-height (+ (get last-proof proof) (get deadline inheritance))))
        (begin
            (map-set inheritances owner 
                (merge inheritance {claimed: true}))
            (stx-transfer? (get amount inheritance) owner tx-sender))
        err-not-beneficiary))
)

(define-public (update-beneficiary (new-beneficiary principal))
    (let ((inheritance (unwrap! (map-get? inheritances tx-sender) (err u404))))
        (if (is-eq tx-sender contract-owner)
            (begin
                (map-set inheritances tx-sender 
                    (merge inheritance {beneficiary: new-beneficiary}))
                (ok true))
            err-owner-only))
)

;; Read only functions
(define-read-only (get-inheritance (owner principal))
    (map-get? inheritances owner)
)

(define-read-only (get-last-proof (owner principal))
    (map-get? proofs-of-life owner)
)
