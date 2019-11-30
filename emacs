(require 'package)

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; General settings
(setq confirm-kill-emacs 'y-or-n-p)
(custom-set-variables '(initial-frame-alist (quote ((fullscreen . maximized)))))

;; Org mode
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-switchb)
(global-set-key "\C-cc" 'org-capture)
(setq org-catch-invisible-edits 'smart)
(setq org-directory "~/org")
(setq org-agenda-files (list org-directory))
(setq org-clock-mode-line-total 'current)
;(setq org-log-done t)

;; TODO states
(setq org-todo-keywords
      '((sequence "TODO" "VERIFY" "DONE")))

;; Capture templates
(setq org-capture-templates
      (quote (("t" "task" entry (file+headline "~/org/my.org" "tasks")
               "* %?" :clock-in t :clock-resume t)
              ("a" "5min am" entry (file+datetree "~/org/fiveminute.org")
               "* I am grateful for...\n* What would make today great?\n* Daily affirmations, I am...\n")
              ("p" "5min pm" entry (file+datetree "~/org/fiveminute.org")
               "* 3 Amazing things that happened today...\n* How could I have made today better?\n"))))

;; Agenda view
(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((agenda "")
          (alltodo "")))))

;; Clock
(setq org-clock-into-drawer t)  ;; this is necessary or :clock-resume will break
(setq org-clock-in-switch-to-state "TODO")
(setq org-clock-out-switch-to-state "VERIFY")
(setq org-clock-report-include-clocking-task t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-out-when-done t)
(setq org-clock-idle-time 15)
(setq org-duration-format (quote h:mm))
