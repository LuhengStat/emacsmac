
(ess-toggle-underscore nil) ; leave underscore key alone!

;; auto-change the directionary to the position of the current file
;;(add-hook 'ess-mode-hook 'ess-use-this-dir)

;; set the default style, same with RStudio
(setq ess-default-style 'RStudio)


;;(require 'ess-view)
;;(setq ess-view--spreadsheet-program "/Applications/Microsoft Excel.app/Contents/MacOS/Microsoft Excel")
;;(setq ess-view--spreadsheet-program "/Applications/Table Tool.app/Contents/MacOS/Table Tool")

;;(setq ess-use-company 'script-only)

;; don't auto-insert ess backends
(add-to-list 'company-dabbrev-code-modes 'ess-mode)
(setq ess-use-company nil)
(defun my-ess-config ()
  (make-variable-buffer-local 'company-backends)
  (add-to-list 'company-backends
               '(company-R-args company-R-objects company-yasnippet company-dabbrev-code :separate)))
(add-hook 'ess-mode-hook #'my-ess-config)

;;(require 'ess-R-object-popup)
;;(define-key ess-mode-map "\C-c\C-g" 'ess-R-object-popup)

;; ess quit R
(defun ess-abort ()
  (interactive)
  (kill-process (ess-get-process)))
(define-key ess-mode-map (kbd "C-c C-a") 'ess-abort)
(define-key inferior-ess-mode-map (kbd "C-c C-a") 'ess-abort)
;;(define-key ess-mode-map (kbd "C-x C-w") 'ess-view-inspect-df)
;;(define-key inferior-ess-mode-map (kbd "C-x C-w") 'ess-view-inspect-df)
(define-key ess-mode-map (kbd "s-r") 'ess-eval-region-or-function-or-paragraph-and-step)
(define-key inferior-ess-mode-map (kbd "RET") 'mydef-RET)

(defun mydef-ess-eval-region-or-line-and-step ()
  "eval line and step"
  (interactive)
  (setq current-line (what-line))
  (ess-eval-region-or-line-and-step)
  (if (string=  current-line (what-line))
      (progn
	(end-of-line)
	(newline))))
(define-key ess-mode-map (kbd "<C-return>")
  'ess-eval-region-or-line-and-step)


(add-hook 'inferior-ess-mode-hook 'visual-line-mode)

(provide 'init-ess)
