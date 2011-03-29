
;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))

(add-to-list 'load-path dotfiles-dir)

;; ido-mode is like magic pixie dust!
(require 'ido)
(when (> emacs-major-version 21)
  (ido-mode t)
  (setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-max-prospects 10))

;; transparency
(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 2%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 2) (+ oldalpha 2))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))
(modify-frame-parameters nil `((alpha . 96)))

;; set up the color theme
(add-to-list 'load-path "~/.emacs.d/color-theme/")
(load-file "~/.emacs.d/color-theme/themes/blackboard.el")
(require 'color-theme)
(color-theme-initialize)
(color-theme-blackboard)

;; resize the window based on screen size
;; colin's improved variety
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    
    (cond ((> (x-display-pixel-width) 1600)
	   (add-to-list 'default-frame-alist (cons 'width 200)))
	  ((> (x-display-pixel-width) 1200)
	   (add-to-list 'default-frame-alist (cons 'width 150)))
	  (t
	   (add-to-list 'default-frame-alist (cons 'width 100))))
    (add-to-list 'default-frame-alist
		 (cons 'height (/ (- (x-display-pixel-height) 50) (frame-char-height)))))))

(set-frame-size-according-to-resolution)

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;; java: don't do crazy indent stuff
(defun my-java-mode-hook ()
  (c-set-offset 'substatement-open 0)
  (setq-default indent-tabs-mode nil)
  (setq-default c-basic-offset 4))
(add-hook 'java-mode-hook 'my-java-mode-hook)

;; Prevent emacs splash screen from showing up
(setq inhibit-splash-screen t)

;; Full file path in the titlebar
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (mouse-wheel-mode t)
  (blink-cursor-mode -1))

;; Unicode, bitches
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

;; make emacs use the clipboard
(setq x-select-enable-clipboard t)

;; textmate awesomeness
(textmate-mode)

;; Don't clutter up directories with files~
(setq backup-directory-alist `(("." . ,(expand-file-name
                                        (concat dotfiles-dir "backups")))))


;; rake tasks are ruby code, too
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))