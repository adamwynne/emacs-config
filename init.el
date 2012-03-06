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

;; durendal
;;(add-hook 'clojure-mode-hook 'durendal-enable-auto-compile)
(add-hook 'slime-repl-mode-hook 'durendal-slime-repl-paredit)
(add-hook 'sldb-mode-hook 'durendal-dim-sldb-font-lock)
;;(add-hook 'slime-compilation-finished-hook 'durendal-hide-successful-compile)

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

;; Yasnippet
(add-to-list 'load-path
              "/Users/Adam/.emacs.d/elpa/yasnippet-0.6.1")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elpa/yasnippet-0.6.1/snippets")

;; Auto complete
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
(require 'auto-complete)
(add-hook 'clojure-mode-hook 'auto-complete-mode)

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
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;; Zencoding
(add-to-list 'load-path "/Users/Adam/.emacs.d/zencoding")
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)

;; HTML tab mode
(add-hook 'sgml-mode-hook
          (lambda()
            (setq sgml-basic-offset 2)
            (setq indent-tabs-mode t)))

;; js2 mode
(add-to-list 'load-path "/Users/Adam/.emacs.d/elpa/js2")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; eldoc mode
(add-hook 'clojure-mode-hook 'eldoc-mode)
