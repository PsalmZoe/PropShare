;; PropShare - Fractional Real Estate Investment Platform
;; This contract enables users to create and invest in fractional real estate properties

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-insufficient-funds (err u102))
(define-constant err-already-exists (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-property-inactive (err u105))
(define-constant err-unauthorized (err u106))
(define-constant err-no-shares (err u107))
(define-constant err-already-distributed (err u108))

;; Data Variables
(define-data-var next-property-id uint u1)
(define-data-var platform-fee-percentage uint u250) ;; 2.5%
(define-data-var next-distribution-id uint u1)

;; Data Maps
(define-map properties
    { property-id: uint }
    {
        owner: principal,
        name: (string-ascii 64),
        total-value: uint,
        total-shares: uint,
        available-shares: uint,
        price-per-share: uint,
        is-active: bool,
        created-at: uint
    }
)

(define-map user-shares
    { property-id: uint, user: principal }
    { shares: uint }
)

(define-map property-metadata
    { property-id: uint }
    {
        location: (string-ascii 128),
        property-type: (string-ascii 32),
        description: (string-ascii 256)
    }
)

(define-map rental-distributions
    { property-id: uint, distribution-id: uint }
    {
        total-amount: uint,
        amount-per-share: uint,
        distributed-at: uint,
        created-by: principal
    }
)

(define-map user-claimed-distributions
    { property-id: uint, distribution-id: uint, user: principal }
    { claimed: bool }
)

;; Private Functions
(define-private (is-contract-owner)
    (is-eq tx-sender contract-owner)
)

;; Public Functions

;; Create a new property listing
(define-public (create-property 
    (name (string-ascii 64))
    (total-value uint)
    (total-shares uint)
    (location (string-ascii 128))
    (property-type (string-ascii 32))
    (description (string-ascii 256))
)
    (let (
        (property-id (var-get next-property-id))
        (price-per-share (/ total-value total-shares))
    )
        (asserts! (> total-value u0) err-invalid-amount)
        (asserts! (> total-shares u0) err-invalid-amount)
        (asserts! (> (len name) u0) err-invalid-amount)
        (asserts! (> (len location) u0) err-invalid-amount)
        (asserts! (> (len property-type) u0) err-invalid-amount)
        (asserts! (> (len description) u0) err-invalid-amount)
        
        (map-set properties
            { property-id: property-id }
            {
                owner: tx-sender,
                name: name,
                total-value: total-value,
                total-shares: total-shares,
                available-shares: total-shares,
                price-per-share: price-per-share,
                is-active: true,
                created-at: stacks-block-height
            }
        )
        
        (map-set property-metadata
            { property-id: property-id }
            {
                location: location,
                property-type: property-type,
                description: description
            }
        )
        
        (var-set next-property-id (+ property-id u1))
        (ok property-id)
    )
)

;; Purchase property shares
(define-public (buy-shares (property-id uint) (shares-to-buy uint))
    (let (
        (property-data (unwrap! (map-get? properties { property-id: property-id }) err-not-found))
        (current-user-shares (default-to u0 (get shares (map-get? user-shares { property-id: property-id, user: tx-sender }))))
        (total-cost (* shares-to-buy (get price-per-share property-data)))
        (platform-fee (/ (* total-cost (var-get platform-fee-percentage)) u10000))
        (seller-amount (- total-cost platform-fee))
    )
        (asserts! (> property-id u0) err-invalid-amount)
        (asserts! (get is-active property-data) err-property-inactive)
        (asserts! (>= (get available-shares property-data) shares-to-buy) err-insufficient-funds)
        (asserts! (> shares-to-buy u0) err-invalid-amount)
        
        ;; Transfer STX from buyer to seller
        (try! (stx-transfer? seller-amount tx-sender (get owner property-data)))
        
        ;; Transfer platform fee to contract owner
        (try! (stx-transfer? platform-fee tx-sender contract-owner))
        
        ;; Update property data
        (map-set properties
            { property-id: property-id }
            (merge property-data { 
                available-shares: (- (get available-shares property-data) shares-to-buy)
            })
        )
        
        ;; Update user shares
        (map-set user-shares
            { property-id: property-id, user: tx-sender }
            { shares: (+ current-user-shares shares-to-buy) }
        )
        
        (ok shares-to-buy)
    )
)

;; Get property information
(define-read-only (get-property (property-id uint))
    (if (> property-id u0)
        (map-get? properties { property-id: property-id })
        none
    )
)

;; Get property metadata
(define-read-only (get-property-metadata (property-id uint))
    (if (> property-id u0)
        (map-get? property-metadata { property-id: property-id })
        none
    )
)

;; Get user shares for a property
(define-read-only (get-user-shares (property-id uint) (user principal))
    (if (> property-id u0)
        (some (default-to u0 (get shares (map-get? user-shares { property-id: property-id, user: user }))))
        none
    )
)

;; Get next property ID
(define-read-only (get-next-property-id)
    (var-get next-property-id)
)

;; Get platform fee percentage
(define-read-only (get-platform-fee-percentage)
    (var-get platform-fee-percentage)
)

;; Get next distribution ID
(define-read-only (get-next-distribution-id)
    (var-get next-distribution-id)
)

;; Get rental distribution information
(define-read-only (get-rental-distribution (property-id uint) (distribution-id uint))
    (if (and (> property-id u0) (> distribution-id u0))
        (map-get? rental-distributions { property-id: property-id, distribution-id: distribution-id })
        none
    )
)

;; Check if user has claimed a distribution
(define-read-only (has-claimed-distribution (property-id uint) (distribution-id uint) (user principal))
    (if (and (> property-id u0) (> distribution-id u0))
        (some (default-to false (get claimed (map-get? user-claimed-distributions { property-id: property-id, distribution-id: distribution-id, user: user }))))
        none
    )
)

;; Calculate claimable amount for a user
(define-read-only (get-claimable-amount (property-id uint) (distribution-id uint) (user principal))
    (let (
        (user-shares-opt (map-get? user-shares { property-id: property-id, user: user }))
        (distribution-opt (map-get? rental-distributions { property-id: property-id, distribution-id: distribution-id }))
        (already-claimed (default-to false (get claimed (map-get? user-claimed-distributions { property-id: property-id, distribution-id: distribution-id, user: user }))))
    )
        (if (and (> property-id u0) (> distribution-id u0) (is-some user-shares-opt) (is-some distribution-opt) (not already-claimed))
            (let (
                (user-shares-val (get shares (unwrap-panic user-shares-opt)))
                (amount-per-share (get amount-per-share (unwrap-panic distribution-opt)))
            )
                (some (* user-shares-val amount-per-share))
            )
            (some u0)
        )
    )
)
;; Update platform fee percentage (contract owner only)
(define-public (set-platform-fee-percentage (new-fee uint))
    (begin
        (asserts! (is-contract-owner) err-owner-only)
        (asserts! (<= new-fee u1000) err-invalid-amount) ;; Max 10%
        (var-set platform-fee-percentage new-fee)
        (ok true)
    )
)

;; Distribute rental income to shareholders
(define-public (distribute-rental-income (property-id uint) (total-amount uint))
    (let (
        (property-data (unwrap! (map-get? properties { property-id: property-id }) err-not-found))
        (distribution-id (var-get next-distribution-id))
        (sold-shares (- (get total-shares property-data) (get available-shares property-data)))
        (amount-per-share (if (> sold-shares u0) (/ total-amount sold-shares) u0))
    )
        (asserts! (> property-id u0) err-invalid-amount)
        (asserts! (is-eq tx-sender (get owner property-data)) err-unauthorized)
        (asserts! (> total-amount u0) err-invalid-amount)
        (asserts! (> sold-shares u0) err-no-shares)
        
        ;; Record the distribution
        (map-set rental-distributions
            { property-id: property-id, distribution-id: distribution-id }
            {
                total-amount: total-amount,
                amount-per-share: amount-per-share,
                distributed-at: stacks-block-height,
                created-by: tx-sender
            }
        )
        
        (var-set next-distribution-id (+ distribution-id u1))
        (ok distribution-id)
    )
)

;; Claim rental income distribution
(define-public (claim-rental-income (property-id uint) (distribution-id uint))
    (let (
        (user-shares-amt (get shares (unwrap! (map-get? user-shares { property-id: property-id, user: tx-sender }) err-no-shares)))
        (distribution-data (unwrap! (map-get? rental-distributions { property-id: property-id, distribution-id: distribution-id }) err-not-found))
        (already-claimed (default-to false (get claimed (map-get? user-claimed-distributions { property-id: property-id, distribution-id: distribution-id, user: tx-sender }))))
        (payout-amount (* user-shares-amt (get amount-per-share distribution-data)))
    )
        (asserts! (> property-id u0) err-invalid-amount)
        (asserts! (> distribution-id u0) err-invalid-amount)
        (asserts! (> user-shares-amt u0) err-no-shares)
        (asserts! (not already-claimed) err-already-distributed)
        (asserts! (> payout-amount u0) err-invalid-amount)
        
        ;; Transfer rental income to user
        (try! (stx-transfer? payout-amount (get created-by distribution-data) tx-sender))
        
        ;; Mark as claimed
        (map-set user-claimed-distributions
            { property-id: property-id, distribution-id: distribution-id, user: tx-sender }
            { claimed: true }
        )
        
        (ok payout-amount)
    )
)

;; Toggle property active status (property owner only)
(define-public (toggle-property-status (property-id uint))
    (let (
        (property-data (unwrap! (map-get? properties { property-id: property-id }) err-not-found))
    )
        (asserts! (> property-id u0) err-invalid-amount)
        (asserts! (is-eq tx-sender (get owner property-data)) err-unauthorized)
        
        (map-set properties
            { property-id: property-id }
            (merge property-data { 
                is-active: (not (get is-active property-data))
            })
        )
        
        (ok true)
    )
)