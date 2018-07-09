(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/org/work.org")))
 '(package-selected-packages (quote (evil-visual-mark-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'evil)
(evil-mode t)

(setq confirm-kill-emacs 'y-or-n-p)

;; Org mode
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-cc" 'org-capture)
(setq org-catch-invisible-edits 'smart)
(setq org-log-done t)
(setq org-agenda-files '("~/org"))
(setq org-directory "~/org")
(setq org-default-notes-file "~/org/inbox.org")
(setq org-clock-mode-line-total 'current)

;; Five-min journal capture templates
(setq org-capture-templates
      (quote (("a" "5min am" entry (file+datetree "~/org/fiveminute.org")
               "* I am grateful for...\n* What would make today great?\n* Daily affirmations, I am...\n")
	      ("p" "5min pm" entry (file+datetree "~/org/fiveminute.org")
               "* 3 Amazing things that happened today...\n* How could I have made today better?\n"))))

