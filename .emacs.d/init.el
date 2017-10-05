;; -*- lexical-binding: t -*-
;;; init.el --- Summary
;;; Commentary:
;;; Code:

;; No menu or tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq inhibit-startup-screen t)

;; Middle click paste at cursor, not at click position
(setq mouse-yank-at-point t)

;; Don't indent with tabs
(setq-default indent-tabs-mode nil)

(setq-default cursor-type 'bar)

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

;; Match parentheses
(require 'rainbow-delimiters)
(define-globalized-minor-mode global-rainbow-delimiters-mode rainbow-delimiters-mode
  (lambda () (rainbow-delimiters-mode t)))
(global-rainbow-delimiters-mode)
(show-paren-mode)

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


(defun listify (v)
  "Return V if V is a list, else wrap it in a singleton list."
  (if (listp v)
      v
    (list v)))

(require 'nix-sandbox)
(defun nix-wrap-if-sandbox (sandbox-function)
  "Generate a wrapper function using the current nix sandbox, if any.
The wrapper will either call SANDBOX-FUNCTION with the current sandbox
and its other argument, or else is the identify function."
  (lambda (args)
    (if (nix-current-sandbox)
        (apply sandbox-function (nix-current-sandbox) (listify args))
      args)))

(add-hook 'prog-mode-hook 'flycheck-mode)
(setq flycheck-command-wrapper-function
      (nix-wrap-if-sandbox 'nix-shell-command)

      flycheck-executable-find
      (nix-wrap-if-sandbox 'nix-executable-find))
(eval-after-load 'flycheck
  '(require 'flycheck-hdevtools))

;; Allow haskell-mode to find ghc in a nix-shell
(setq haskell-process-wrapper-function
      (nix-wrap-if-sandbox 'nix-shell-command))
(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup)

(eval-after-load 'which-func
  '(add-to-list 'which-func-modes 'haskell-mode))

(add-hook 'haskell-mode-hook 'haskell-decl-scan-mode)
(eval-after-load 'speedbar '(speedbar-add-supported-extension ".hs"))
(setq haskell-tags-on-save t)

;; Set up company for in buffer completions
(add-hook 'prog-mode-hook 'company-mode)
(setq company-backends
  '( (company-files company-dabbrev-code company-gtags company-etags company-keywords company-capf)
     company-dabbrev
   )
  )

;; Uses flx to provide fuzzy matching for completion-at-point
(require 'company-flx)
(with-eval-after-load 'company
  (company-flx-mode +1))

;; Ivy provides better menus with search
(require 'ivy)
(setq ivy-re-builders-alist
  '( (t . ivy--regex-fuzzy) )
)
(ivy-mode)

;; Better search with swiper
(require 'swiper)
(global-set-key "\C-s" 'swiper)



;;; init.el ends here
