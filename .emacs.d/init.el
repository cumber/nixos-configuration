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

(delete-selection-mode t)

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

(require 'flycheck)
(add-hook 'prog-mode-hook 'flycheck-mode)
(setq flycheck-command-wrapper-function
      (nix-wrap-if-sandbox 'nix-shell-command)

      flycheck-executable-find
      (nix-wrap-if-sandbox 'nix-executable-find))

(require 'intero)
(setq intero-stack-executable "intero-nix-shim-exe")
(add-hook 'haskell-mode-hook 'intero-mode)


(require 'which-func)
(eval-after-load 'which-func
  '(add-to-list 'which-func-modes 'haskell-mode))

;; Set up company for in buffer completions
(add-hook 'prog-mode-hook 'company-mode)

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

;; Highlight diffs with indicators
(require 'diff-hl)
(global-diff-hl-mode)
(diff-hl-flydiff-mode)
(diff-hl-dired-mode)

;;; init.el ends here
