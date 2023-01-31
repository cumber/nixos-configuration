;; -*- lexical-binding: t; flycheck-disabled-checkers: (emacs-lisp-checkdoc); byte-compile-warnings: (not make-local); -*-

;; No menu or tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)

(setq inhibit-startup-screen t)

(set-face-attribute 'default nil :height 120)

;; Middle click paste at cursor, not at click position
(setq mouse-yank-at-point t)

;; Don't indent with tabs; if there are tabs make them width 4
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; 2-space indents in javascript, including cases in switch statements
(setq-default js-indent-level 2)
(setq-default js-switch-indent-offset 2);

;; 2-space indents in css/scss
(setq-default css-indent-offset 2)

(setq-default cursor-type 'bar)

(global-visual-line-mode)

(delete-selection-mode t)

;; Taken from https://stackoverflow.com/a/24373916/450128
(defun add-to-list-multi (list items)
  "Adds multiple items to LIST.
Allows for adding a sequence of items to the same list, rather
than having to call `add-to-list' multiple times."
  (interactive)
  (dolist (item items)
    (add-to-list list item)))

(add-to-list-multi 'safe-local-variable-values
                   '((flycheck-disabled-checkers . emacs-lisp-checkdoc)))
(add-to-list-multi 'safe-local-eval-forms
                   '((web-mode-use-tabs)
                     (web-mode-set-engine "php")))

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
(require 'bind-key)

;; Autodetect indent settings for many language modes
(use-package dtrt-indent-mode
  :hook prog-mode)

;; Relative line numbers enabled in all prog and text modes
(use-package linum-relative
  :hook ((prog-mode . linum-relative-mode)
         (text-mode . linum-relative-mode)))

;; Match parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package paren
  :config
  (setq show-paren-style 'expression)
  :hook (prog-mode . show-paren-mode))

;; Visisble tabs and trailing whitespace
(use-package whitespace
  :config
  (setq whitespace-style '(face tabs tab-mark trailing))
  (global-whitespace-mode))

;; Ruler at fill column, fill column 80
(use-package fill-column-indicator
  :config
  (setq fill-column 80)
  :hook ((prog-mode . fci-mode)
         (text-mode . fci-mode)))

;; show completion for key bindings
(use-package which-key
  :config
  (which-key-setup-side-window-right-bottom)
  (which-key-mode))

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

;; LSP configuration
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq-default lsp-haskell-server-path "haskell-language-server")
  (setq-default lsp-haskell-formatting-provider "fourmolu")
  :hook ((haskell-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)
(use-package lsp-ui
  :config
  (setq lsp-ui-imenu-window-width 40)
  (setq lsp-ui-imenu-auto-refresh t)
  (setq lsp-ui-peek-enable t)
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))
(use-package lsp-ivy)
(use-package lsp-treemacs)
(use-package yasnippet)

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

;; Use company-box front end for displaying company results
(use-package company-box
  :hook (company-mode . company-box-mode))

;; Ivy provides better menus with search
(use-package ivy
  :config
  (setq ivy-re-builders-alist
        '( (t . ivy--regex-fuzzy) ))
  (ivy-mode))

;; Better search with swiper
(use-package swiper
  :bind ("C-s" . swiper-isearch))
  ;:config
  ;(global-set-key (kbd "C-s") 'swiper-isearch))

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
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-enable-engine-detection t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2))

(use-package robe
  :after company
  :config
  (setq ruby-deep-indent-paren nil)
  (add-hook 'ruby-mode-hook 'robe-mode)
  (push 'company-robe company-backends))

(use-package js2-mode
  :mode "\\.js\\'"
  :interpreter "node")

(use-package tide
  :after ((:any typescript-mode js2-mode) company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (js2-mode . tide-setup)
         (js2-mode . tide-hl-identifier-mode))
  :config
  (setq tide-node-executable "@nodejs@/bin/node"))

(use-package docker-compose-mode)

(use-package graphviz-dot-mode)
(use-package company-graphviz-dot)
