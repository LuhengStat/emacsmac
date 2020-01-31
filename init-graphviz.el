
;;;###autoload
(defun mydef-graphviz-dot-preview ()
  (interactive)
  (save-buffer)
  (let ((windows (window-list))
        (f-name (graphviz-output-file-name (buffer-file-name)))
        (warn-msg (string-trim (shell-command-to-string compile-command))))
    (if (string-match-p "^Warning: .+ line \\([0-9]+\\)" warn-msg)
        (message warn-msg)
      (progn
        (sleep-for 0 graphviz-dot-revert-delay)
        (when (= (length windows) 1)
          ())
        (with-selected-window (selected-window)
          (find-file f-name))))))

;;;###autoload
(defun mydef-compile (command &optional comint)
  "Compile the program including the current buffer.  Default: run `make'.
Runs COMMAND, a shell command, in a separate process asynchronously
with output going to the buffer `*compilation*'.

You can then use the command \\[next-error] to find the next error message
and move to the source code that caused it.

If optional second arg COMINT is t the buffer will be in Comint mode with
`compilation-shell-minor-mode'.

Interactively, prompts for the command if the variable
`compilation-read-command' is non-nil; otherwise uses `compile-command'.
With prefix arg, always prompts.
Additionally, with universal prefix arg, compilation buffer will be in
comint mode, i.e. interactive.

To run more than one compilation at once, start one then rename
the `*compilation*' buffer to some other name with
\\[rename-buffer].  Then _switch buffers_ and start the new compilation.
It will create a new `*compilation*' buffer.

On most systems, termination of the main compilation process
kills its subprocesses.

The name used for the buffer is actually whatever is returned by
the function in `compilation-buffer-name-function', so you can set that
to a function that generates a unique name."
  (interactive
   (list
    (let ((command (eval compile-command)))
      (if (or compilation-read-command current-prefix-arg)
	  (compilation-read-command command)
	command))
    (consp current-prefix-arg)))
  (unless (equal command (eval compile-command))
    (setq compile-command command))
  (save-some-buffers (not compilation-ask-about-save)
                     compilation-save-buffers-predicate)
  (setq-default compilation-directory default-directory)
  (compilation-start command comint)
  (if (get-buffer-window "*compilation*")
      (progn   (if (not (popwin:close-popup-window))
		   (previous-buffer))))
  (mydef-graphviz-dot-preview))

(add-hook 'graphviz-dot-mode-hook
	  (lambda ()
	    (define-key graphviz-dot-mode-map (kbd "C-c C-c") 'mydef-compile)
	    (define-key graphviz-dot-mode-map (kbd "C-c C-o") 'mydef-graphviz-dot-preview)
	    ))

(provide 'init-graphviz)
