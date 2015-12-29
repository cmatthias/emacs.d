(setq cem-packages
      '(
        better-defaults
        go-mode
        haml-mode
        yaml-mode
       ))

(package-initialize)
(add-to-list 'package-archives
  '("marmalade" . "https://marmalade-repo.org/packages/"))

(when (not package-archive-contents)
  (package-refresh-contents))

(dolist (pkg cem-packages)
  (when (and (not (package-installed-p pkg))
             (assoc pkg package-archive-contents))
    (package-install pkg)))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

