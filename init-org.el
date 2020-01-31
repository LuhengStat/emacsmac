
(require 'org)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "DeepPink1" :weight bold)
              ("NEXT" :foreground "SlateBlue1" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

;;(require 'org-ac)
;;(org-ac/config-default)

(defun my-org-mode-hook ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
(add-hook 'org-mode-hook #'my-org-mode-hook)

;; auto indent in the org-mode
(setq org-startup-indented t)

;; continue with the clock
(setq org-clock-continuously nil)
(setq org-html-validation-link nil)
(setq org-clock-mode-line-total 'current)

(eval-after-load 'org
  (progn
    (define-key org-mode-map (kbd "S-C-<left>") nil)
    (define-key org-mode-map (kbd "S-C-<right>") nil)
    (define-key org-mode-map (kbd "S-C-<down>") nil)
    (define-key org-mode-map (kbd "S-C-<up>") nil)
    (define-key org-mode-map (kbd "M-<left>") nil)
    (define-key org-mode-map (kbd "M-<right>") nil)
    (define-key org-mode-map (kbd "C-'") nil)))


;; agenda views
(setq org-agenda-files '("/Users/wlh/Documents/Personal/Org/"))
(custom-set-faces
 '(error ((t (:foreground "Red" :weight normal))))
 '(org-agenda-clocking ((t (:background "SkyBlue1")))))

(setq org-agenda-span 'day)
(setq org-agenda-include-diary t)

(setq org-agenda-custom-commands
      '(("d" "Simple agenda view"
	 ((agenda "")	
	  ;;(alltodo "" ((org-agenda-overriding-header "Global Tasks:")))
	  ))))

(defun mydef-org-agenda-view ()
  "set a org-agenda-view i choose most"
  (interactive)
  (if (get-buffer-window "*Org Agenda*")
      (progn
	(switch-to-buffer "*Org Agenda*")
	(org-agenda-quit))
    (org-agenda nil "d")))

;; org-agenda
(global-set-key (kbd "C-c t") 'org-agenda)
(global-set-key [?\s-t] 'mydef-org-agenda-view)

;; use org-agenda-view
;; (setq inhibit-splash-screen t)
;; (setq org-agenda-inhibit-startup t)
;; (org-agenda nil "d")
;; (delete-other-windows)


(defun my/org-clock-query-out ()
  "Ask the user before clocking out.
This is a useful function for adding to `kill-emacs-query-functions'."
  (if (and
       (featurep 'org-clock)
       (funcall 'org-clocking-p)
       (y-or-n-p "You are currently clocking time, clock out? "))
      (progn
	(org-clock-out)
	(save-buffers-kill-terminal))       
    t)) ;; only fails on keyboard quit or error

;; timeclock.el puts this on the wrong hook!
(add-hook 'kill-emacs-query-functions 'my/org-clock-query-out)

;; set for the calendar
(push "*Calendar*" popwin:special-display-config)
(defun mydef-org-agenda-show-calendar ()
  "define the window of calendar"
  (interactive)
  (if (get-buffer-window "*Calendar*")
      (progn   (if (or (< (window-width) 125) (> (window-height) 25))
		   (calendar-exit)
		 (popwin:close-popup-window)))
    (org-agenda-goto-calendar)))

(global-set-key (kbd "s-c") 'calendar)
(add-hook 'org-agenda-mode-hook
          (lambda ()
	    (define-key org-agenda-mode-map (kbd "s-c") 'mydef-org-agenda-show-calendar)
	    (define-key org-agenda-mode-map (kbd "c") 'mydef-org-agenda-show-calendar)))
(define-key calendar-mode-map (kbd "s-c") 'mydef-org-agenda-show-calendar)
(define-key calendar-mode-map (kbd "c") 'mydef-org-agenda-show-calendar)
(define-key calendar-mode-map (kbd "f") 'calendar-forward-day)
(define-key calendar-mode-map (kbd "b") 'calendar-backward-day)
(define-key calendar-mode-map (kbd "n") 'calendar-forward-week)
(define-key calendar-mode-map (kbd "p") 'calendar-backward-week)
(define-key calendar-mode-map (kbd "n") 'calendar-forward-week)
(define-key calendar-mode-map (kbd "M-]") 'calendar-forward-month)
(define-key calendar-mode-map (kbd "M-[") 'calendar-backward-month)

(defun mydef-org-agenda-show-holiday ()
  "define the window of holiday"
  (interactive)
  (if (get-buffer "*Holidays*")
      (kill-buffer "*Holidays*")
    (org-agenda-holidays)))
(add-hook 'org-agenda-mode-hook
          (lambda ()
	    (define-key org-agenda-mode-map (kbd "H") 'mydef-org-agenda-show-holiday)
	    (define-key org-agenda-mode-map (kbd "h") 'mydef-org-agenda-show-holiday)))


(provide 'init-org)
