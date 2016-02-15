(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/")
 t)
(package-initialize)

(defun init--install-packages ()
    (packages-install
     '(magit
       projectile
       ruby-tools
       sr-speedbar
       yasnippet
       flycheck
       git-gutter
       company
       markdown-mode
       popup
       racer
       rinari-cap
       multiple-cursors
       )))

;; Emacs server
(require 'server)
(unless (server-running-p)
    (server-start))

;;toolbar and menu
(tool-bar-mode -1)
(menu-bar-mode 1)

;; Inhibit startup/splash screen
(setq inhibit-splash-screen   t)
(setq ingibit-startup-message t)

;; Delete selection
(delete-selection-mode t)

;;disable scrollbar
(scroll-bar-mode   -1)

;; Smart M-x is smart
(require 'smex)
(smex-initialize)

;;copy without selection
(defadvice kill-ring-save (before slick-copy activate compile) "When called
  interactively with no active region, copy a single line instead."
           (interactive (if mark-active (list (region-beginning) (region-end)) (message
                                                                                "Copied line") (list (line-beginning-position) (line-beginning-position
                                                                                                                                2)))))
(defadvice kill-region (before slick-cut activate compile)
    "When called interactively with no active region, kill a single line instead."
    (interactive
     (if mark-active (list (region-beginning) (region-end))
         (list (line-beginning-position)
               (line-beginning-position 2)))))

;;paren mode
(setq show-paren-style 'expression)
(show-paren-mode 1)
(defadvice show-paren-function
    (after show-matching-paren-offscreen activate)
    "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
    (interactive)
    (let* ((cb (char-before (point)))
           (matching-text (and cb
                               (char-equal (char-syntax cb) ?\) )
                               (blink-matching-open))))
        (when matching-text (message matching-text))))

;;sexy mode line
(setq sml/no-confirm-load-theme 1)
(sml/setup t)
(setq sml/theme 'dark)
(nyan-mode t)

;; show buffers
(require 'bs)
(setq bs-configurations
      '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last)))
(global-set-key (kbd "<f2>") 'bs-show)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

;;global line mode
(global-hl-line-mode)

;;projectile
(projectile-global-mode)

;;scrolling
(setq scroll-step 1)
(windmove-default-keybindings 'meta)

;;short answer
(fset 'yes-or-no-p 'y-or-n-p)

;;ruby
(require 'ruby-tools)

;; Indent settings
(setq-default indent-tabs-mode nil)
(setq-default tab-width          4)
(setq-default c-basic-offset     4)
(setq-default standart-indent    4)
(setq-default lisp-body-indent   4)
(global-set-key (kbd "RET") 'newline-and-indent)
(setq lisp-indent-function  'common-lisp-indent-function)

;; Clipboard settings
(setq x-select-enable-clipboard t)

;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

;; Delete trailing whitespaces, format buffer and untabify when save buffer
(defun format-current-buffer()
    (indent-region (point-min) (point-max)))
(defun untabify-current-buffer()
    (if (not indent-tabs-mode)
        (untabify (point-min) (point-max)))
    nil)
(add-to-list 'write-file-functions 'format-current-buffer)
(add-to-list 'write-file-functions 'untabify-current-buffer)
(add-to-list 'write-file-functions 'delete-trailing-whitespace)

;;slime
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq slime-contribs '(slime-fancy))

;;sr-speedbar
(require 'sr-speedbar)
(global-set-key (kbd "<f12>") 'sr-speedbar-toggle)
(add-hook 'speedbar-mode-hook
          (lambda()
              (speedbar-add-supported-extension "\\.rb")
              (speedbar-add-supported-extension "\\.ru")
              (speedbar-add-supported-extension "\\.erb")
              (speedbar-add-supported-extension "\\.rjs")
              (speedbar-add-supported-extension "\\.rhtml")
              (speedbar-add-supported-extension "\\.rake")
              (speedbar-add-supported-extension "\\.md")
              (speedbar-add-supported-extension "\\.py")
              (speedbar-add-supported-extension "\\.html")
              (speedbar-add-supported-extension "\\.css")
              (speedbar-add-supported-extension  ".[ch]\\(\\+\\+\\|pp\\|c\\|h\\|xx\\)?")
              (speedbar-add-supported-extension  ".tex\\(i\\(nfo\\)?\\)?")
              (speedbar-add-supported-extension  "\\.todo")
              (speedbar-add-supported-extension  "\\.done")
              (speedbar-add-supported-extension  "\\.el")
              (speedbar-add-supported-extension  ".emacs")
              (speedbar-add-supported-extension  "\\.l")
              (speedbar-add-supported-extension  "\\.lsp")
              (speedbar-add-supported-extension  "\\.p")
              (speedbar-add-supported-extension  "\\.java")
              (speedbar-add-supported-extension  "\\.js")
              (speedbar-add-supported-extension  ".f\\(90\\|77\\|or\\)?")
              (speedbar-add-supported-extension  ".ad[abs]")
              (speedbar-add-supported-extension  ".p[lm]")
              (speedbar-add-supported-extension  "\\.tcl")
              (speedbar-add-supported-extension  ".m")
              (speedbar-add-supported-extension  "\\.scm")
              (speedbar-add-supported-extension  ".pm")
              (speedbar-add-supported-extension  "\\.g")
              (speedbar-add-supported-extension  "\\.\\(inc\\|php[s345]?\\|phtml\\)")
              (speedbar-add-supported-extension  ".s?html")
              (speedbar-add-supported-extension  ".ma?k")
              (speedbar-add-supported-extension  "[Mm]akefile\\(\\.in\\)?")
              (speedbar-add-supported-extension  "\\.rs")))

;;yanisppet
(require 'yasnippet)
(yas-global-mode 1)
(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet")
;;(yas/load-directory "~/.emacs.d/yasnippet/snippets")

;;flycheck
(package-install 'flycheck)
(global-flycheck-mode)

;; Highlight search resaults
(setq search-highlight        t)
(setq query-replace-highlight t)

;;themes
(load-theme 'quasi-monochrome t)

;;Markdown
(autoload 'markdown-mode "markdown-mode"
    "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;Display the name of the current buffer in the title bar
(setq frame-title-format "GNU Emacs: %b")

;;autopair
(require 'autopair)
(autopair-global-mode)

;;gutter
(global-git-gutter-mode +1)
(git-gutter:linum-setup)
(add-hook 'ruby-mode-hook 'git-gutter-mode)
(add-hook 'python-mode-hook 'git-gutter-mode)

;;web-mode
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(setq web-mode-enable-auto-pairing t)

;;настройка отступов
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

;;сниппеты и автозакрытие парных скобок
(setq web-mode-extra-nippets '(("erb" . (("name" . ("beg" . "end"))))))
(setq web-mode-extra-auto-pairs '(("erb" . (("open" "close")))))

;;company mode
(global-company-mode t)
(add-hook 'after-init-hook 'global-company-mode)

;;map
(global-set-key (kbd "<f8>") 'visit-tags-table)

;; | Combo | Function         | Description                |
;; |-------+------------------+----------------------------|
;; | <f3>  | visit-tags-table | Loads tags                 |
;; | M-.   | find-tag         | Jumps to the specified tag |
;; | C-M-. | pop-tag-mark     | Jumps back                 |

(global-set-key (kbd "C-M-b") 'bookmark-set)
(global-set-key (kbd "M-C-b") 'bookmark-jump)
(global-set-key (kbd "<f4>") 'bookmark-bmenu-list)

;;fonts
(set-face-attribute 'default nil :font "Terminus Re33 12" )
(set-frame-font "Terminus Re33 12" nil t)

;;line nunber
;;(add-hook 'prog-mode-hook 'linum-mode)
(global-linum-mode 1)
(setq linum-format "%d ")

;;autopair
(require 'autopair)
(autopair-global-mode t)

;;whichkey
(package-install 'which-key)
(require 'which-key)
(which-key-mode t)

;;ido
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

;;racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

;;wanderlust
(autoload 'wl "wl" "Wanderlust" t)

;;org-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(custom-set-variables
 '(org-agenda-files (quote ("~/Mega/git/note/main.org")))
 '(org-default-notes-file "~/Mega/git/note")
 '(org-directory "~/Mega/git/note")
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))))
