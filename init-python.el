
(elpy-enable)

(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

(add-hook 'inferior-python-mode-hook 'visual-line-mode)
;; (setq ispell-program-name "/usr/local/Cellar/aspell/0.60.8/bin/aspell")
(add-hook 'elpy-mode-hook 'flycheck-mode)

(defun mydef-RET ()
  "define RET behavior in python"
  (interactive)
  (setq current-line (what-line))
  (end-of-buffer)
  (if (string=  current-line (what-line))
      (comint-send-input)))
(define-key inferior-python-mode-map (kbd "RET") 'mydef-RET)

(define-key elpy-mode-map (kbd "C-c C-c") 'elpy-shell-send-group-and-step)
(define-key elpy-mode-map (kbd "C-c C-l") 'elpy-shell-send-region-or-buffer)

(defun mydef-eval-line ()
  "eval line and step"
  (interactive)
  (setq current-line (what-line))
  (elpy-shell-send-statement-and-step)
  (if (string=  current-line (what-line))
      (progn
	(end-of-line)
	(newline))))
(define-key elpy-mode-map (kbd "<C-return>") 'mydef-eval-line)

(define-key elpy-mode-map (kbd "s-r") 'elpy-shell-send-region-or-buffer)

(setq python-shell-prompt-detect-failure-warning nil)
(setq python-shell-completion-native-enable nil)

;; interactive python
;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i")
;; (setq python-shell-interpreter "python3"
;;       elpy-rpc-python-command "python3"
;;       python-shell-interpreter-args "-i")

(defun elpy-shell-send-file (file-name &optional process temp-file-name
				       delete msg)
  "Like `python-shell-send-file' but evaluates last expression separately.

See `python-shell-send-file' for a description of the
arguments. This function differs in that it breaks up the
Python code in FILE-NAME into statements. If the last statement
is a Python expression, it is evaluated separately in 'eval'
mode. This way, the interactive python shell can capture (and
print) the output of the last expression."
  (interactive
   (list
    (read-file-name "File to send: ")   ; file-name
    nil                                 ; process
    nil                                 ; temp-file-name
    nil                                 ; delete
    t))                                 ; msg
  (let* ((process (or process (python-shell-get-process-or-error msg)))
         (encoding (with-temp-buffer
                     (insert-file-contents
                      (or temp-file-name file-name))
                     (python-info-encoding)))
         (file-name (expand-file-name
                     (or (file-remote-p file-name 'localname)
                         file-name)))
         (temp-file-name (when temp-file-name
                           (expand-file-name
                            (or (file-remote-p temp-file-name 'localname)
                                temp-file-name)))))
    (python-shell-send-string
     (format
      (concat
       "import sys, codecs, os, ast;"
       "__pyfile = codecs.open('''%s''', encoding='''%s''');"
       "__code = __pyfile.read().encode('''%s''');"
       "__pyfile.close();"
       (when (and delete temp-file-name)
         (format "os.remove('''%s''');" temp-file-name))
       "__block = ast.parse(__code, '''%s''', mode='exec');"
       "__last = __block.body[-1];" ;; the last statement
       "__isexpr = isinstance(__last,ast.Expr);" ;; is it an expression?
       "_ = __block.body.pop() if __isexpr else None;" ;; if so, remove it
       "exec(compile(__block, '''%s''', mode='exec'));" ;; execute everything else
       "eval(compile(ast.Expression(__last.value), '''%s''', mode='eval')) if __isexpr else None" ;; if it was an expression, it has been removed; now evaluate it
       )
      (or temp-file-name file-name) encoding encoding file-name file-name file-name)
     process)))

;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
;; (add-to-list 'python-shell-completion-native-disabled-interpreters
;;              "jupyter")

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(setq elpy-rpc-timeout 10)

(provide 'init-python)





