(require 'package)

; Evil mode
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
(define-key org-mode-map (kbd "C-c C-x C-a") nil)  ; this key combination archives the current subtree and is not undo-able therefore disabling it explicitly
(setq org-catch-invisible-edits 'smart)
(setq org-directory "~/org")
(setq org-agenda-files (list org-directory))
(setq org-clock-mode-line-total 'current)
;(setq org-log-done t)

;; TODO states
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "|" "VERIFY" "DONE")))

;; Capture templates
(setq org-capture-templates
      (quote (("t" "task" entry (file+headline "~/org/my.org" "tasks")
               "* %?" :clock-in t :clock-resume t))))

;; Agenda view
(setq org-agenda-files '("~/org/my.org"))
;(setq org-agenda-archives-mode 'trees)
(setq org-agenda-skip-archived-trees nil)
(setq org-agenda-start-with-clockreport-mode t)
(setq org-agenda-window-setup 'current-window)
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-clockreport-parameter-plist (quote (:link t :maxlevel 5)))
(setq org-agenda-span 'day)
;(setq org-agenda-custom-commands '(("c" "Simple agenda view" ((agenda "") (alltodo "")))))

;; Clock
(setq org-clock-into-drawer t)  ;; this is necessary or :clock-resume will break
(setq org-clock-in-switch-to-state "IN-PROGRESS")
(setq org-clock-out-switch-to-state "VERIFY")
(setq org-clock-report-include-clocking-task t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-out-when-done t)
(setq org-clock-idle-time 15)
(setq org-duration-format (quote h:mm))
