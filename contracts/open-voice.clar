(define-data-var complaint-counter uint u0)

(define-map complaints
  { id: uint }
  {
    department: (string-ascii 30),
    message: (string-ascii 250),
    status: (string-ascii 12)
  }
)

(define-map admins
  { user: principal }
  { is-admin: bool }
)

(define-constant initial-admin tx-sender)

;; Initialize the contract deployer as an admin
(begin
  (map-set admins { user: initial-admin } { is-admin: true })
)

;; Check if caller is admin
(define-read-only (is-admin (user principal))
  (match (map-get? admins { user: user }) result
    (ok (get is-admin result))
    (ok false)
  )
)

;; Add a new admin (only existing admin can do this)
(define-public (add-admin (new-admin principal))
  (begin
    (asserts! (unwrap-panic (is-admin tx-sender)) (err "Not authorized"))
    (let ((admin-principal new-admin))
      (map-set admins { user: (unwrap-panic (ok admin-principal)) } { is-admin: (unwrap-panic (ok true)) })
    )
    (ok "Admin added")
  )
)

;; Remove admin
(define-public (remove-admin (target principal))
  (begin
    (asserts! (unwrap-panic (is-admin tx-sender)) (err "Not authorized"))
    (asserts! (unwrap-panic (is-admin target)) (err "Admin not found"))
    (let ((admin-principal target))
      (map-delete admins { user: (unwrap-panic (ok admin-principal)) })
    )
    (ok "Admin removed")
  )
)

;; Submit a complaint
(define-public (submit-complaint (department (string-ascii 30)) (message (string-ascii 250)))
  (let ((id (+ (var-get complaint-counter) u1)))
    (begin
      (let (
        (complaint-department department)
        (complaint-message message)
      )
        (map-set complaints { id: (unwrap-panic (ok id)) }
          {
            department: (unwrap-panic (ok complaint-department)),
            message: (unwrap-panic (ok complaint-message)),
            status: (unwrap-panic (ok "pending"))
          }
        )
      )
      (var-set complaint-counter id)
      (ok id)
    )
  )
)

;; View a complaint by ID
(define-read-only (get-complaint (id uint))
  (map-get? complaints { id: id })
)

;; Update complaint status (only admin)
(define-public (update-status (id uint) (new-status (string-ascii 12)))
  (begin
    (asserts! (unwrap-panic (is-admin tx-sender)) (err "Not authorized"))
    (match (map-get? complaints { id: id }) cdata
      (let (
        (complaint-department (get department cdata))
        (complaint-message (get message cdata))
        (complaint-status new-status)
      )
        (map-set complaints { id: (unwrap-panic (ok id)) }
          {
            department: (unwrap-panic (ok complaint-department)),
            message: (unwrap-panic (ok complaint-message)),
            status: (unwrap-panic (ok complaint-status))
          }
        )
        (ok (unwrap-panic (ok complaint-status)))
      )
      (err "Complaint not found")
    )
  )
)

;; Get total number of complaints
(define-read-only (get-total-complaints)
  (ok (var-get complaint-counter))
)
