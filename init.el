;; Marmalade repo
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Customisations
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-save t)
 '(scroll-bar-mode (quote right))
 '(shift-select-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil
                         :stipple nil
                         :background "#2e3434"
                         :foreground "#eeeeec"
                         :inverse-video nil
                         :box nil
                         :strike-through nil
                         :overline nil
                         :underline nil
                         :slant normal
                         :weight normal
                         :height 140
                         :width normal
                         :foundry "apple"
                         :family "Inconsolata")))))

;; Theme
(require 'color-theme-tangotango)
;;(require 'color-theme-sanityinc-solarized)

;; lein path
(setenv "PATH" (concat (getenv "PATH") ":" "/Users/Adam/bin"))

;; Save the desktop when the files are autosaved
(desktop-save-mode t)
(defun my-desktop-save ()
  (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))
(add-hook 'auto-save-hook 'my-desktop-save)

;; Set the mac key bindings
(global-set-key "\C-x\C-b" 'buffer-menu)
(global-set-key (kbd "<M-kp-delete>") 'kill-word)
(require 'mac-key-mode)
(mac-key-mode 1)

;; ... we want to be able to insert a '#' using Alt-3 in emacs as we would in other programs
(fset 'insertPound "#")
(define-key global-map "\M-3" 'insertPound)

;; Enable backup files in a designated directory
(setq make-backup-files t)
(setq version-control t)
(setq delete-old-versions t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; Change the colour of the hi-line
(eval-after-load "hi-lock"
  '(set-face-background 'hl-line "#3c3c3c"))

(eval-after-load "color-theme-tangotango"
  '(set-face-background 'show-paren-match-face "#999999"))

;; Enable to delete a region that is selected
(delete-selection-mode 1)
(put 'paredit-backward-delete 'delete-selection 'supersede)
(put 'paredit-forward-delete 'delete-selection 'supersede)

;; Octave mode
(autoload 'octave-mode "octave-mod" nil t)
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

;; Zencoding
(add-to-list 'load-path "/Users/Adam/.emacs.d/zencoding")
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)
(define-key global-map "\C-\M-h" 'zencoding-expand-line)

;; HTML tab mode
;; (add-hook 'sgml-mode-hook
;;           (lambda()
;;             (setq sgml-basic-offset 2)
;;             (setq indent-tabs-mode t)))

;; nXHTML mode
(load "/Users/Adam/.emacs.d/nxhtml/autostart")
(add-to-list 'auto-mode-alist '("\\.php$" . nxhtml-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . nxhtml-mode))

;; js2 mode
(add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'js2-mode))

;; eldoc mode
(add-hook 'clojure-mode-hook 'eldoc-mode)

;; Show the column number
(column-number-mode 1)

;; Adjust the divider bar
(defun xor (b1 b2)
  "Exclusive or of its two arguments."
  (or (and b1 b2)
      (and (not b1) (not b2))))

(defun move-border-left-or-right (arg dir)
  "General function covering move-border-left and move-border-right. If DIR is
     t, then move left, otherwise move right."
  (interactive)
  (if (null arg) (setq arg 5))
  (let ((left-edge (nth 0 (window-edges))))
    (if (xor (= left-edge 0) dir)
        (shrink-window arg t)
      (enlarge-window arg t))))

(defun move-border-left (arg)
  "If this is a window with its right edge being the edge of the screen, enlarge
     the window horizontally. If this is a window with its left edge being the edge
     of the screen, shrink the window horizontally. Otherwise, default to enlarging
     horizontally.
     
     Enlarge/Shrink by ARG columns, or 5 if arg is nil."
  (interactive "P")
  (move-border-left-or-right arg t))

(defun move-border-right (arg)
  "If this is a window with its right edge being the edge of the screen, shrink
     the window horizontally. If this is a window with its left edge being the edge
     of the screen, enlarge the window horizontally. Otherwise, default to shrinking
     horizontally.
     
     Enlarge/Shrink by ARG columns, or 5 if arg is nil."
  (interactive "P")
  (move-border-left-or-right arg nil))

(global-set-key (kbd "M-[") 'move-border-left)
(global-set-key (kbd "M-]") 'move-border-right)

;; Load from OS into the same frame
(setq ns-pop-up-frames nil)

(add-hook 'nrepl-mode-hook 'paredit-mode)
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
