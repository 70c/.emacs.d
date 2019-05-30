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

;; enable theme
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config
  (load-theme 'sanityinc-tomorrow-night t))

;; set default font
(set-face-attribute 'default nil
		    :font "Fira Code Retina"
		    :height 100)

;; disable some minor-modes in mode-line
(use-package delight
  :ensure t
  :config
  :delight
  (eldoc-mode)
  (org-indent-mode)
  (auto-revert-mode))

;; indicate empty lines at the end of a file
(setq-default indicate-empty-lines t)

;; enable line numbers in programming buffers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; enable hl-line in programming buffers
(add-hook 'prog-mode-hook 'hl-line-mode)

;; show column and buffer size in mode-line
(size-indication-mode)
(column-number-mode)


;; haskell
(use-package haskell-mode
  :ensure t
  :config
  (setq haskell-program-name "ghci"))


;; org-mode
(use-package org
  :ensure t
  :config
  ;; additional todo keywords
  (setq org-todo-keywords
	'((sequence "TODO" "ON-GOING" "|" "DONE")
	  (sequence "|" "CANCELLED")))
  ;; darkburn-red, darkburn-orange, darkburn-green, darkburn-grey
  ;; faces for these keywords
  (setq org-todo-keyword-faces
  	'(("TODO"	.	(:foreground "OrangeRed3"	:weight bold))
  	  ("ON-GOING"	.	(:foreground "gold3"		:weight bold))
  	  ("DONE"	.	(:foreground "SpringGreen3"	:weight bold))
  	  ("CANCELLED"	.	(:foreground "dim gray"		:weight bold))))
  ;; edit src blocks in same window
  (setq org-src-window-setup 'current-window)
  ;; set org levels to bold
  (set-face-bold 'org-level-1 t)
  (set-face-bold 'org-level-2 t)
  (set-face-bold 'org-level-3 t)
  (set-face-bold 'org-level-4 t)
  (set-face-bold 'org-level-5 t)
  (set-face-bold 'org-level-6 t)
  (set-face-bold 'org-level-7 t)
  (set-face-bold 'org-level-8 t)
  ;; org-habits
  (add-to-list 'org-modules 'habits)
  :hook (org-mode . org-indent-mode))


;; swiper
(use-package swiper
  :ensure t
  :bind ("C-s" . swiper))


;; avy
(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-word-1))

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
    (progn
      (ibuffer-list-buffers)
      (switch-to-buffer-other-window "*Ibuffer*"))))
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

;; dired
(global-set-key (kbd "C-c d") 'dired-jump)

;; disable ring bell
(setq ring-bell-function 'ignore)

;; insert newlines
(setq next-line-add-newlines t)


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


;; ansi-term
(defun open-or-switch-to-ansi-term ()
  "Open `ansi-term'. If buffer already exists, switch to it."
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash")))
(global-set-key (kbd "C-c t") 'open-or-switch-to-ansi-term)


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


;; scroll doc-view document while in other window
(defun scroll-other-window-up-doc-view ()
  "Like `scroll-other-window', but works with `doc-view-mode'.
Scroll the `doc-view-mode' document up."
  (interactive)
  (save-window-excursion
    (other-window 1)
    (when (equal major-mode 'doc-view-mode)
      (doc-view-scroll-up-or-next-page))))
(global-set-key (kbd "C-c v") 'scroll-other-window-up-doc-view)

(defun scroll-other-window-down-doc-view ()
  "Like `scroll-other-window', but works with `doc-view-mode'.
Scrolls the `doc-view-mode' document down."
  (interactive)
  (save-window-excursion
    (other-window 1)
    (when (equal major-mode 'doc-view-mode)
      (doc-view-scroll-down-or-previous-page))))
(global-set-key (kbd "C-c DEL") 'scroll-other-window-down-doc-view)


;; sudo find-file
(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "F(sudo) Find file: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))
(global-set-key (kbd "C-c s") 'sudo-find-file)


;; indent-relative
(global-set-key (kbd "M-i") 'indent-relative)

;; put custom-set-variables into seperate file
(setq custom-file (concat user-emacs-directory "custom.el"))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load-file custom-file)
(put 'upcase-region 'disabled nil)
