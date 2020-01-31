
(defun mydef-open-folder (filename)
  "Open folder of the current file"
  (interactive
   (find-file-read-args "Open Finder: "
                        (confirm-nonexistent-file-or-buffer)))
  (shell-command (format "open -R \"%s\"" filename)))

(defun mydef-dired-open-folder ()
  "let the dired mode can open file correctly"
  (interactive)
  (let ((find-file-run-dired t))
    (mydef-open-folder (dired-get-file-for-visit))))

(add-hook 'dired-mode-hook
	  (lambda ()
	    (define-key dired-mode-map (kbd "<C-return>") 'mydef-dired-open-folder)
	    (define-key dired-mode-map (kbd "<DEL>") 'dired-up-directory)))

(defun mydef-counsel-projectile-open-folder-action (file)
  "Find FILE and run `projectile-find-file-hook'."
  (interactive)
  (mydef-open-folder (projectile-expand-root file))
  (run-hooks 'projectile-find-file-hook))

(defun mydef-counsel-projectile-find-file (&optional arg)
  "Jump to a file in the current project.

With a prefix ARG, invalidate the cache first."
  (interactive "P")
  (projectile-maybe-invalidate-cache arg)
  (ivy-read (projectile-prepend-project-name "Find file: ")
            (projectile-current-project-files)
            :matcher #'counsel--find-file-matcher
            :require-match t
            :action '(1
		      ("o" counsel-projectile-find-file-action "open file")
		      ("f" mydef-counsel-projectile-open-folder-action "open finder"))
            :caller 'mydef-counsel-projectile-find-file))

(defun counsel-files-search-jump (&optional initial-input initial-directory)
  "Jump to a file below the current directory.
List all files within the current directory or any of its subdirectories.
INITIAL-INPUT can be given as the initial minibuffer input.
INITIAL-DIRECTORY, if non-nil, is used as the root directory for search."
  (interactive
   (list nil
         (when current-prefix-arg
           (read-directory-name "From directory: "))))
  (counsel-require-program "find")
  (let* ((default-directory (or initial-directory default-directory)))
    (ivy-read "Find file: "
              (split-string
               (shell-command-to-string "rg --files")
               "\n" t)
              :matcher #'counsel--find-file-matcher
              :initial-input initial-input
              :action '(1
			("o" find-file "open file")
			("f" mydef-open-folder "open finder"))
              :preselect (counsel--preselect-file)
              :require-match 'confirm-after-completion
              :history 'file-name-history
              :keymap counsel-find-file-map
              :caller 'counsel-files-search-jump)))


;; open folder part
(defun mydef-counsel-projectile-open-folder (&optional arg)
  "Jump to a file in the current project.

with a prefix ARG, invalidate the cache first."
  (interactive "P")
  (projectile-maybe-invalidate-cache arg)
  (ivy-read (projectile-prepend-project-name "Open Finder: ")
            (projectile-current-project-files)
            :matcher #'counsel--find-file-matcher
            :require-match t
            :action (lambda (x)
		      (with-ivy-window
			(mydef-counsel-projectile-open-folder-action x)))
            :caller 'mydef-counsel-projectile-open-folder))

(defun counsel-files-search-jump-to-folder (&optional initial-input initial-directory)
  "Jump to a file below the current directory.
List all files within the current directory or any of its subdirectories.
INITIAL-INPUT can be given as the initial minibuffer input.
INITIAL-DIRECTORY, if non-nil, is used as the root directory for search."
  (interactive
   (list nil
         (when current-prefix-arg
           (read-directory-name "From directory: "))))
  (counsel-require-program "find")
  (let* ((default-directory (or initial-directory default-directory)))
    (ivy-read "Open Finder: "
              (split-string
               (shell-command-to-string "rg --files")
               "\n" t)
              :matcher #'counsel--find-file-matcher
              :initial-input initial-input
              :action (lambda (x)
                        (with-ivy-window
                          (mydef-open-folder (expand-file-name x ivy--directory))))
              :preselect (counsel--preselect-file)
              :require-match 'confirm-after-completion
              :history 'file-name-history
              :keymap counsel-find-file-map
              :caller 'counsel-files-search-jump-to-folder)))



(provide 'init-user-funs)
