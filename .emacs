;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/myini/")
(setq custom-file (expand-file-name "myini/custom.el" user-emacs-directory))

(require 'init-redefine-sys-fun)
(require 'init-packages)
(load-file custom-file)
(require 'init-better-defaults)
(require 'init-ui)

(require 'init-org)
(require 'init-ess)
(require 'init-latex)
(require 'init-python)
;;(require 'init-graphviz)

(require 'init-keybindings)
