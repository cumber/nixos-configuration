;; -*- lexical-binding: t; flycheck-disabled-checkers: (emacs-lisp-checkdoc); byte-compile-warnings: (not make-local); -*-

;; No menu or tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq inhibit-startup-screen t)

;; Middle click paste at cursor, not at click position
(setq mouse-yank-at-point t)

;; Don't indent with tabs
(setq-default indent-tabs-mode nil)

;; 2-space indents in javascript
(setq-default js-indent-level 2)

;; 2-space indents in css/scss
(setq-default css-indent-offset 2)

(setq-default cursor-type 'bar)

(global-visual-line-mode)

(delete-selection-mode t)

(setq safe-local-variable-values
      '((flycheck-disabled-checkers '(emacs-lisp-checkdoc))))

;; Provide a new MAJORMODE-local-vars-hook
(add-hook 'hack-local-variables-hook 'run-local-vars-mode-hook)
(defun run-local-vars-mode-hook ()
  "Run a hook for the major-mode after the local variables have been processed."
  (run-hooks (intern (concat (symbol-name major-mode) "-local-vars-hook"))))

;; Set theme
(add-hook 'after-init-hook (lambda () (load-theme 'leuven)))

;; Configure how backups and autosave files are made
(make-directory "~/.cache/emacs/backups/" t)
(make-directory "~/.cache/emacs/autosave/" t)
(setq backup-directory-alist '(("." . "~/.cache/emacs/backups/")))
(setq auto-save-file-name-transforms '((".*" "~/.cache/emacs/autosave/" t)))
(setq backup-by-copying-when-linked t)


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(eval-when-compile
  (require 'use-package))

;; Relative line numbers enabled globally
(use-package linum-relative
  :defines global-linum-relative-mode
  :functions global-linum-relative-mode global-linum-relative-mode-enable-in-buffers
  :config
  (define-globalized-minor-mode global-linum-relative-mode linum-relative-mode
    (lambda () (linum-relative-mode t)))
  (global-linum-relative-mode))

;; Match parentheses
(use-package rainbow-delimiters
  :defines global-rainbow-delimiters-mode
  :functions global-rainbow-delimiters-mode global-rainbow-delimiters-mode-enable-in-buffers
  :config
  (define-globalized-minor-mode global-rainbow-delimiters-mode rainbow-delimiters-mode
    (lambda () (rainbow-delimiters-mode t)))
  (global-rainbow-delimiters-mode))
(use-package paren
  :config
  (show-paren-mode)
  (setq show-paren-style 'expression))

(use-package rainbow-identifiers
  :commands rainbow-identifiers-mode
  :init
  (add-hook 'prog-mode-hook 'rainbow-identifiers-mode))

;; Visisble tabs and trailing whitespace
(use-package whitespace
  :config
  (setq whitespace-style '(face tabs tab-mark trailing))
  (global-whitespace-mode))

;; Ruler at fill column, fill column 80
(use-package fill-column-indicator
  :defines global-fci-mode
  :functions global-fci-mode global-fci-mode-enable-in-buffers
  :config
  (define-globalized-minor-mode global-fci-mode fci-mode
    (lambda () (fci-mode t)))
  (setq fill-column 80)
  (global-fci-mode))

(defun listify (v)
  "Return V if V is a list, else wrap it in a singleton list."
  (if (listp v)
      v
    (list v)))

(use-package nix-sandbox)

(use-package flycheck
  :commands flycheck-mode
  :init
  (add-hook 'prog-mode-hook 'flycheck-mode)
  :config
  (setq flycheck-command-wrapper-function
        (lambda (cmd) (apply 'nix-shell-command (nix-current-sandbox) cmd))

        flycheck-executable-find
        (lambda (cmd) (nix-executable-find (nix-current-sandbox) cmd))))

(use-package dante
  :after haskell-mode
  :commands 'dante-mode
  :init
  ;; Want Dante to start after local variables have been applied (e.g. from .dir-locals.el),
  ;; otherwise it starts GHCI without applying settings (e.g. target), which is confusing
  (put 'dante-target 'safe-local-variable 'stringp)
  (add-hook 'haskell-mode-local-vars-hook 'dante-mode)
  (add-hook 'dante-mode-hook
    '(lambda () (flycheck-add-next-checker 'haskell-dante
                 '(warning . haskell-hlint)))))

(use-package which-func
  :config
  '(add-to-list 'which-func-modes 'haskell-mode))

;; Set up company for in buffer completions
(use-package company
  :commands company-mode
  :init
  (add-hook 'prog-mode-hook 'company-mode))

;; Uses flx to provide fuzzy matching for completion-at-point
(use-package company-flx
  :after company
  :config
  (company-flx-mode +1))

;; Ivy provides better menus with search
(use-package ivy
  :config
  (setq ivy-re-builders-alist
        '( (t . ivy--regex-fuzzy) ))
  (ivy-mode))

;; Better search with swiper
(use-package swiper
  :bind ("\C-s" . swiper))

;; Highlight diffs with indicators
(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)
  (diff-hl-dired-mode))

;; Explicitly using magit makes it activate for git commit messages
(use-package magit)

;; Web templates with embedded code fragments
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2))

(use-package tern
  :hook (js-mode . tern-mode)
  )
(use-package company-tern
  :after company
  :config
  (add-to-list 'company-backends 'company-tern))

(use-package robe
  :after company
  :config
  (setq ruby-deep-indent-paren nil)
  (add-hook 'ruby-mode-hook 'robe-mode)
  (push 'company-robe company-backends))

(use-package docker-compose-mode)
