
;;(require 'auto-complete-auctex)
(require 'company-auctex)
(company-auctex-init)
(load "~/.emacs.d/myini/cdlatex.el")
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode

;; ACUTeX replaces latex-mode-hook with LaTeX-mode-hook
(add-hook 'LaTeX-mode-hook
(lambda ()
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(reftex-mode t)
(TeX-fold-mode t)))

;; do not promot for the reference <2018-01-23 Tue> 
;;(setq reftex-ref-macro-prompt nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)

(setq-default TeX-parse-self t) ;; Enable parsing of the file itself on load
(setq-default TeX-auto-save t) ;; Enable save on command executation (e.g., LaTeX)
(setq-default TeX-save-query nil) ;; Don't even ask about it
(setq-default TeX-source-correlate-mode t) ;; Enable synctex
(setq-default TeX-source-correlate-start-server t)

;; Turn on RefTeX in AUCTeX
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; Activate nice interface between RefTeX and AUCTeX
(setq reftex-plug-into-AUCTeX t)

;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background  
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
      '(("PDF Viewer"
	 "/Applications/Skim.app/Contents/SharedSupport/displayline -b %n %o %b")))

;; set the face of the toc 
(defface mydef-reftex-section-heading-face
  '((t :inherit font-lock-function-name-face :height 125))
  "My RefTeX section heading face.")
(setq reftex-section-heading-face 'mydef-reftex-section-heading-face)

;; description of the toc buffer
(defface mydef-reftex-toc-header-face
  '((t :inherit font-lock-doc-face :height 115))
  "My RefTeX section heading face.")
(setq reftex-toc-header-face 'mydef-reftex-toc-header-face)

;; 2016 Statistica Sinica 26, 69--95
(defface mydef-reftex-bib-extra-face
  '((t :inherit font-lock-comment-face :height 136))
  "My RefTeX section heading face.")
(setq reftex-bib-extra-face 'mydef-reftex-bib-extra-face)
(setq reftex-bib-year-face 'mydef-reftex-bib-extra-face)

(defface mydef-reftex-bib-extra-face
  '((t :inherit font-lock-comment-face :height 136))
  "My RefTeX section heading face.")
(setq reftex-index-header-face 'mydef-reftex-bib-extra-face)
(setq reftex-index-section-face 'mydef-reftex-bib-extra-face)
(setq reftex-index-tag-face 'mydef-reftex-bib-extra-face)
(setq reftex-index-face 'mydef-reftex-bib-extra-face)


;; redefine some keyblindings for the Latex mode
(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (define-key LaTeX-mode-map (kbd "C-c C-c") 'TeX-command-run-all)
	    (define-key LaTeX-mode-map (kbd "s-r") 'TeX-command-run-all)
	    (define-key LaTeX-mode-map (kbd "C-c C-a") 'TeX-command-master)
	    (define-key LaTeX-mode-map (kbd "C-c )") 'LaTeX-close-environment)
	    (define-key LaTeX-mode-map (kbd "C-c 0") 'LaTeX-close-environment)
	    (define-key LaTeX-mode-map (kbd "C-c 9") 'reftex-label)
	    (define-key LaTeX-mode-map (kbd "C-c ]") 'reftex-reference)
	    (turn-on-auto-fill)
	    ))
(add-hook 'reftex-mode-hook
	  (lambda ()
	    (define-key reftex-mode-map (kbd "C-c )") 'LaTeX-close-environment)
	    (define-key reftex-mode-map (kbd "C-c 7") 'reftex-view-crossref)))


(defun mydef-choose-horizon-toc ()
  "autotically choose whether to set the reftex-toc-split-window 
true or not"
  (if (< (window-width) 125)
      (progn
	(setq reftex-toc-split-windows-fraction 0.36)
	(setq reftex-toc-split-windows-horizontally nil))
    (setq reftex-toc-split-windows-fraction 0.25)
    (setq reftex-toc-split-windows-horizontally t)))

(defun mydef-reftex-toc ()
  "let reftex-toc being more reasonable"
  (interactive)
  (mydef-choose-horizon-toc)
  (reftex-toc))

(defun mydef-reftex-toc-recenter ()
  "let the reftex-toc-recenter more reasonable"
  (interactive)
  (mydef-choose-horizon-toc)
  (reftex-toc-recenter))

(add-hook 'reftex-toc-mode-hook 'visual-line-mode)
(add-hook 'reftex-mode-hook
	  (lambda ()
	    (define-key reftex-mode-map (kbd "C-c =") 'mydef-reftex-toc)
	    (define-key reftex-mode-map (kbd "C-c -") 'mydef-reftex-toc-recenter)
	    ))

(provide 'init-latex)

