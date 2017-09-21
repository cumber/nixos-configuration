;; No menu or tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq inhibit-startup-screen t)

;; Middle click paste at cursor, not at click position
(setq mouse-yank-at-point t)

;; Don't indent with tabs
(setq-default indent-tabs-mode nil)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-hook 'after-init-hook (lambda () (load-theme 'leuven)))

;; Relative line numbers enabled globally
(require 'linum-relative)
(define-globalized-minor-mode global-linum-relative-mode linum-relative-mode
  (lambda () (linum-relative-mode t)))
(global-linum-relative-mode)

;; Rainbow delimiters
(require 'rainbow-delimiters)
(define-globalized-minor-mode global-rainbow-delimiters-mode rainbow-delimiters-mode
  (lambda () (rainbow-delimiters-mode t)))
(global-rainbow-delimiters-mode)

;; Visisble tabs and trailing whitespace
(require 'whitespace)
(setq whitespace-style '(face tabs tab-mark trailing))
(global-whitespace-mode)

;; Ruler at fill column, fill column 80
(setq fill-column 80)
(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode
  (lambda () (fci-mode t)))
(global-fci-mode)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))
(add-hook 'prog-mode-hook 'flycheck-mode)

;; Set up company for in buffer completions
(require 'company)
(add-hook 'prog-mode-hook 'company-mode)
(setq company-backends
  '( (company-files company-dabbrev-code company-gtags company-etags company-keywords)
     company-dabbrev
   )
  )

;; Uses flx to provide fuzzy matching for completion-at-point
(require 'company-flx)
(with-eval-after-load 'company
  (company-flx-mode +1))

;; Ivy provides
(require 'ivy)
(setq ivy-re-builders-alist
  '( (t . ivy--regex-fuzzy) )
)
(ivy-mode)

;; Better search with swiper
(require 'swiper)
(global-set-key "\C-s" 'swiper)
