;; This configuration file needs the corresponding 
;; .emacs.d directory to work properly.


;; TIPS, TRICKS, AND HINTS (OH MY!)

;; You can turn on line-wrapping without the stupid arrows 
;; by turning on visual line mode.


;; PERSONAL CUSTOMIZATION

;; The first command sets the default directory to <directory> if no
;; initial file is specified. The second sets the directory if a file
;; IS specified at startup.

;; (setq command-line-default-directory "~/Dropbox/Out of the Box/")

;; Set window size for 1440x900 (Macbook Air '13 2011)
(if window-system (set-frame-size (selected-frame) 200 54))


;; Default setup.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-visual-line-mode t)
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil)
 '(make-backup-files nil)
 '(org-startup-indented t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Pick up my private mods.
(add-to-list 'load-path "~/.emacs.d/")

;; Activate Org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Key-bindings for Org mode.
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Activate Pretty Control ^L
(require 'pp-c-l)
;; Set the control line to 70 spaces.
(setq pp^L-^L-string "                                                                      ");
(pretty-control-l-mode 1)

;; Configure gnus for email

;; Add Marmalade to package manager
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Activate tramp so we cah do sudo all the time.

(require 'tramp)
(setq tramp-default-method "scp")
