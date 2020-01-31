
;;(server-start)
(setq ring-bell-function 'ignore)
;; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)
;; save the window layout
(winner-mode 1)
;;(desktop-save-mode 1)
;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)

(setq default-directory "/Users/wlh/Documents")

;; automatically focus on the new window
(add-to-list 'display-buffer-alist
             '("*Apropos*" display-buffer-same-window))
(add-to-list 'display-buffer-alist
             '("*Help*" display-buffer-same-window))
(add-to-list 'display-buffer-alist
             '("*toc*" display-buffer-same-window))
;; occur auto jump to the occur buffer
(add-hook 'occur-hook
          '(lambda ()
             (switch-to-buffer-other-window "*Occur*")))
;; auto go to the faces buffer
(defun mydef-list-faces-display ()
  "auto switch to the faces buffer"
  (interactive)
  (list-faces-display)
  (switch-to-buffer-other-window "*Faces*"))


;; restore recent file 
(require 'recentf)
(recentf-mode 1)
(setq recentf-auto-cleanup 'never) ;; in case if use Tramp
(setq recentf-max-saved-items 50)
;; open recent files when satart up
;;(recentf-open-files)
(add-to-list 'recentf-exclude "~/.emacs.d/bookmarks")
(add-to-list 'recentf-exclude "\\.rip\\'")
(add-to-list 'recentf-exclude "\\.gz\\'")
(add-to-list 'recentf-exclude "/Users/wlh/Documents/GitHub/emacsfile")
(add-to-list 'recentf-exclude "/Users/wlh/Documents/Personal/phd/毕业论文/bak")
(add-to-list 'recentf-exclude "\\.lof\\'")
(add-to-list 'recentf-exclude "\\.log\\'")
(add-to-list 'recentf-exclude "\\.sty\\'")
(add-to-list 'recentf-exclude "\\.toc\\'")
(add-to-list 'recentf-exclude "\\.pdf\\'")


;; make backup to a designated dir, mirroring the full path
(defun mydef-backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* (
	 (backupRootDir "~/Documents/.emacs-backup/")
	 (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path, for example, “C:”
	 (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") ))
	 )
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath
    )
  )
(setq make-backup-file-name-function 'mydef-backup-file-name)

;; Save all tempfiles in $TMPDIR/emacs$UID/                                                        
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) "~/Documents/.emacs-backup/emacssaves"))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)


(setq-default abbrev-mode t)
(define-abbrev-table 'global-abbrev-table '(
					    ;; name
					    ("wlh" "Luheng Wang")
					    ;; my address
					    ("myadd" "10 Vairo Village, State College.")
					    ;; work address
					    ("workadd" "Methodology Center, PSU, State College.")
					    ;; try to transfrom a data into a frame
					    ("asf" "as.data.frame")
					    ;; my email address
					    ("mygmail" "wlh0426@gmail.com")
					    ))



;; set better mouse scroll type
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(custom-set-variables
 '(scroll-conservatively 1000)
 '(scroll-margin 3)
 '(scroll-bar-mode nil)
 )


;; Save whatever’s in the current (system) clipboard before
;; replacing it with the Emacs’ text.
;; https://github.com/dakrone/eos/blob/master/eos.org
(setq save-interprogram-paste-before-kill t)


;; auto mark ring
(when (require 'auto-mark nil t)
  (setq auto-mark-command-class-alist
        '((anything . anything)
          (goto-line . jump)
          (indent-for-tab-command . ignore)
          (undo . ignore)))
  (setq auto-mark-command-classifiers
        (list (lambda (command)
                (if (and (eq command 'self-insert-command)
                         (eq last-command-char ? ))
                    'ignore))))
  (global-auto-mark-mode 1))


;; disable mouse in emacs
(define-minor-mode disable-mouse-mode
  "A minor-mode that disables all mouse keybinds."
  :global t
  :lighter "mouse"
  :keymap (make-sparse-keymap))

(dolist (type '(mouse down-mouse drag-mouse
                      double-mouse triple-mouse))
  (dolist (prefix '("" C- M- S- M-S- C-M- C-S- C-M-S-))
    ;; Yes, I actually HAD to go up to 7 here.
    (dotimes (n 7)
      (let ((k (format "%s%s-%s" prefix type n)))
        (define-key disable-mouse-mode-map
          (vector (intern k)) #'ignore)))))

(disable-mouse-mode 1)

(remove-hook 'text-mode-hook #'turn-on-auto-fill)
(add-hook 'text-mode-hook #'visual-line-mode)

;; let find-file create path without asking
(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
        (make-directory dir)))))

(provide 'init-better-defaults)
