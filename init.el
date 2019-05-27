;; package management
(setq load-prefer-newer t)

(require 'package)
(setq pacakge-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; UI
(tooltip-mode -1) ; disable ugly tooltips
;; disable ui elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; enable theme, make sure it's installed
(use-package kaolin-themes
  :ensure t
  :config
  (load-theme 'kaolin-dark t))

;; set default font
(set-face-attribute 'default nil
		    :font "Fira Code Medium"
		    :height 105)

;; disable some minor-modes in mode-line
(use-package delight
  :ensure t
  :config
  :delight
  (eldoc-mode)
  (org-indent-mode))

;; indicate empty lines at the end of a file
(setq-default indicate-empty-lines t)

;; enable line numbers in programming buffers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; enable hl-line in programming buffers
(add-hook 'prog-mode-hook 'hl-line-mode)

;; show column and buffer size in mode-line
(size-indication-mode)
(column-number-mode)


;; org-mode
(use-package org
  :ensure t
  :hook (org-mode . org-indent-mode))


;; swiper
(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))


;; IDO
(use-package ido-vertical-mode
  :ensure t
  :config
  ;; enable ido and use it everywhere
  (ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  ;; enable ido-vertical
  (ido-vertical-mode 1)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only)
  (setq ido-vertical-show-count t))

;; use ibuffer instead of list-buffers
(defun open-or-jump-to-ibuffer ()
  "Open `ibuffer' in other window. Switch to it if already
opened."
  (interactive)
  (if (get-buffer "*Ibuffer*")
      (unless (equal (buffer-name) "*Ibuffer*")
	(switch-to-buffer-other-window "*Ibuffer*"))
    (ibuffer-list-buffers)
    (switch-to-buffers-other-window "*Ibuffer*")))
(global-set-key (kbd "C-x C-b") 'open-or-jump-to-ibuffer)

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1)
  :delight)

;; smex
(use-package smex
  :ensure t
  :bind
  ("M-x" . smex)
  ("M-X" . smex-major-mode-commands)
  :config
  (smex-initialize))


;; magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))


;; use apropos instead apropos-command for C-h a
(global-set-key (kbd "C-h a") 'apropos)
;; bookmarks
(global-set-key (kbd "C-c b") 'bookmark-jump)
(global-set-key (kbd "C-c C-b") 'list-bookmarks)

;; disable ring bell
(setq ring-bell-function 'ignore)


;; disable startup screen
(setq inhibit-startup-screen t)


;; make all promts y-or-no
(fset 'yes-or-no-p 'y-or-n-p)


;; dired
(setq dired-listing-switches "-al --group-directories-first --dired")


;; scrolling
(setq scroll-conservatively 101)


;; doc-view resolution
(setq doc-view-resolution 144)


;; disable backups, auto saves, lock files
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;; support for russian leyout
(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(reverse-input-method 'russian-computer)


;; put custom-set-variables into seperate file
(setq custom-file (concat user-emacs-directory "custom.el"))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load-file custom-file)