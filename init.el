;;; package --- My emaacs init-file
;;; Commentary:
;;; Name: My Emacs config
;;; Autor: Volodymyr Yevtushenko
;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/")t)
;; activate installed packages
(package-initialize)
(setq my-package-list '())
(mapc #'package-install my-package-list)
(add-to-list 'load-path "~/.emacs.d/modules")

(desktop-save-mode 0)

;;; List of required modules
(require 'auto-install-packages)
(require 'ruby-module)
(require 'speedbar-module)
(require 'smartparens-module)
(require 'web-mode-module)
(require 'yasnippet-module)
(require 'helm-module)
(require 'python-module)
(require 'highlight-indentation-mode-module)

;;(require 'ivy-module)
(require 'looks-module)
(require 'themes-module)

;; Achievements mode
(require 'achievements)
(achievements-mode 1)

;; cask
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Emacs server
(require 'server)
(unless (server-running-p)
    (server-start))

;; Delete selection
(delete-selection-mode t)

;; use bash
(setq shell-file-name "/bin/bash")

;; Switch window
(global-set-key (kbd "C-x o") 'switch-window)

;; company mode
(require 'company)
(global-company-mode t)
(company-quickhelp-mode t)
(global-set-key (kbd "C-<tab>") 'company-complete)
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-tern)
(add-to-list 'company-backends 'company-robe)
(add-to-list 'company-backends 'company-go)
(add-to-list 'company-backends 'company-jedy)

;;copy without selection
(defadvice kill-ring-save (before slick-copy activate compile)
    "When called interactively with no active region, copy a single line instead."
    (interactive (if mark-active (list (region-beginning) (region-end))
                     (message "Copied line")
                     (list (line-beginning-position) (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
    "When called interactively with no active region, kill a single line instead."
    (interactive
     (if mark-active (list (region-beginning) (region-end))
         (list (line-beginning-position)
               (line-beginning-position 2)))))

;;paren mode
(show-smartparens-global-mode 1)
;;(setq show-sma 0)
;;(setq show-paren-style 'parenthesis)

;;multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-|") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

;;global line mode
(global-hl-line-mode)

;;projectile
(projectile-global-mode)
(projectile-rails-global-mode)

;; Add haml and yaml modes extension
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.haml\\'" . haml-mode))

;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

;; slime
;; (setq inferior-lisp-program "/usr/local/bin/sbcl")
;; (setq slime-contribs '(slime-fancy))

;; flycheck
;;(package-install 'flycheck)
(global-flycheck-mode)

;; Markdown
(autoload 'markdown-mode "markdown-mode"
    "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(setq markdown-command "grip --export")

;; line number
(require 'nlinum)
(global-set-key "\C-cl" 'nlinum-mode)
(add-hook 'ruby-mode-hook 'nlinum-mode)
(add-hook 'python-mode-hook 'nlinum-mode)
(add-hook 'lisp-mode-hook 'nlinum-mode)
(add-hook 'c-mode-hook 'nlinum-mode)
(add-hook 'js2-mode-hook 'nlinum-mode)
(add-hook 'js2-jsx-mode-hook 'nlinum-mode)
(add-hook 'rust-mode-hook 'nlinum-mode)
(add-hook 'java-mode-hook 'nlinum-mode)
(add-hook 'web-mode-hook 'nlinum-mode)
(add-hook 'emacs-lisp-mode-hook 'nlinum-mode)
(add-hook 'elixir-mode-hook 'nlinum-mode)

;; gutter
(require 'git-gutter-fringe)
(global-git-gutter-mode +1)

;; map of tagtables
(global-set-key (kbd "<f8>") 'visit-tags-table)
" | Combo | Function         | Description                |"
" |-------+------------------+----------------------------|"
" | <f3>  | visit-tags-table | Loads tags                 |"
" | M-.   | find-tag         | Jumps to the specified tag |"
" | C-M-. | pop-tag-mark     | Jumps back                 |"

;; Bookmark settings
(require 'bookmark)
(setq bookmark-save-flag t) ;; автоматически сохранять закладки в файл
(when (file-exists-p (concat user-emacs-directory "bookmarks"))
    (bookmark-load bookmark-default-file t))
(global-set-key (kbd "C-M-b") 'bookmark-set)
(global-set-key (kbd "M-C-b") 'bookmark-jump)
(global-set-key (kbd "<f4>") 'bookmark-bmenu-list)
(setq bookmark-default-file (concat user-emacs-directory "bookmarks"))

;; whichkey
(package-install 'which-key)
(require 'which-key)
(which-key-mode t)

;; rust
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;; racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
(add-hook 'racer-mode-hook #'company-mode)

(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

;; org-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-agenda-files (list "~/Mega/TODO/become_programer.org"
                             "~/Mega/must_notes.org"))
(add-hook 'org-mode-hook 'toggle-truncate-lines)
(setq org-src-fontify-natively nil)
(defface org-block
    '((t (:background "#000000")))
    "Face used for the source block background.")

;;whitespace
(global-set-key (kbd "<f5>") 'whitespace-mode)
(global-set-key (kbd "C-c <f5>") 'whitespace-cleanup)

;; evil modes
(global-set-key (kbd "<f6>") 'evil-mode)

;; emmet mode
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)

;; calendar app
(require 'calfw)
(require 'calfw-org)

;;(put 'upcase-region 'disabled nil)

;; work mouse in terminal
(xterm-mouse-mode t)

;; imenu anywhere
(global-set-key (kbd "C-c i") #'imenu-anywhere)

;; vimish folds
(require 'vimish-fold)
(global-set-key (kbd "C-c v f") #'vimish-fold)
(global-set-key (kbd "C-c v v") #'vimish-fold-delete)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)
;;(magit-auto-revert-mode )
(global-auto-revert-mode 1)
;; persp-mode
(persp-mode)

;; undo tree
(global-undo-tree-mode t)

;; avto revert files after
;; change git branch
;;(setq auto-revert-check-vc-info t)

;; Highlights *.elixir2 as well
(add-to-list 'auto-mode-alist '("\\.elixir2\\'" . elixir-mode))

;; resize windows
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; c-mode settings
(setq c-default-style "linux")

;; expand region mode
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; simple  httpd
(require 'simple-httpd)
(setq httpd-root "/home/nuncostans/workspace/js/")
;;(httpd-start)

(unless (display-graphic-p)
    (add-to-list 'default-frame-alist '(background-color . "#000000")))

;; email wanderlust
(autoload 'wl "wl" "Wanderlust" t)

;; neotree
(require 'neotree)
(global-set-key [f12] 'neotree-projectile-action)
(global-set-key (kbd "M-<f12>") 'neotree-hide)
(setq neo-theme  'arrow)

;;slim-mode
(require 'slim-mode)
(add-to-list 'auto-mode-alist '("\\.slim\\'" . slim-mode))

;;lein exec path
(add-to-list 'exec-path "/home/nuncostans/Programs/leiningen")

;;quickrun
(require 'quickrun)

;;golden ratio
(require 'golden-ratio)
(global-set-key(kbd "C-c C-g") 'golden-ratio-mode)

;; nyan-mode
(nyan-mode 1)

;; css and sccs indent level
(setq css-indent-offset 2)
(setq scss-indent-offset 2)

;;paradox token
(defvar paradox-token
    (getenv "PARADOX"))
(setq paradox-github-token 'paradox-token)

;;disable sound
(setq visible-bell 1)

;;ibuffer settings
(add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-projectile-set-filter-groups)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
          (ibuffer-do-sort-by-alphabetic))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#000000" "light gray" "dark gray" "light slate gray"])
 '(ansi-term-color-vector
   [unspecified "#000000" "#d54e53" "#afd75f" "#e7c547" "#5f87d7" "#af87d7" "#5f87d7" "#dadada"] t)
 '(coffee-tab-width 2)
 '(custom-enabled-themes (quote (smart-mode-line-light sexy-monochrome)))
 '(custom-safe-themes
   (quote
    ("fbcb48518376e6fb67ab0e7b26c012db608b8fa2e548a421fd9b5c7a081a096a" "1d777e10e0e838b4feccc87ff47b4cb25959c44a07c35592afe82444a7b787d5" "3c52aad4c656099631f43e50b5512c3c60256224dddde6f11ae0d8d067a6cb32" "f49dd1ce4a05bb2c171257decf163b4c8a728dfaa65bfbe1de78529d1e2b743f" "fb4c83e076f1745b6b2c5dfdc57288aa6257fa497e4b93354ecbc52c12d6da40" "3f3c476a8ed7019de5bf7220f5f965c9cc41c0631ee14aab881a4bfbe7cbcebf" "84ed2decf8f06fdc5f33f86d2951bf402b11caf3dedabb8942dd1080fe08b7b4" "85a63a721f791797b347fb893a9e7ceabf2bb58cd4662b7f85d1390e24e2fea4" "cc0dbb53a10215b696d391a90de635ba1699072745bf653b53774706999208e3" "7f5837a7dbf54c2b7c41d94f5eb1373cf63274847d1971037faa24d7f2231eea" "ca8e634fa3e088ef5e19a6e609f9e79fd407a6188fcb5bc3de17801ed38f8afa" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "b32487a336b756ef2353018ccc58c27356727ddf2b72f28f922306fb9f95d01b" "4aafea32abe07a9658d20aadcae066e9c7a53f8e3dfbd18d8fa0b26c24f9082c" "2a18e54e84857de0f8703671661609ad9d287c25175594a282f91444841e92e5" default)))
 '(menu-bar-mode nil)
 '(neo-theme (quote arrow))
 '(package-selected-packages
   (quote
    (gitconfig gitignore-mode zenburn-theme yari yaml-mode which-key weechat web-mode wanderlust vimish-fold toml-mode toml thrift systemd stylus-mode ssh sqlup-mode sqlplus sqlite sql-indent smarty-mode smartparens smart-mode-line sly-company slime-company slim-mode skewer-mode scss-mode sass-mode rvm ruby-tools ruby-hash-syntax ruby-dev ruby-block ruby-additional rubocop rspec-mode rsense robe rjsx-mode rinari realgud-rdb2 realgud-byebug react-snippets rbenv ranger rainbow-mode racket-mode racer quickrun pyenv-mode-auto pydoc projectile-variable projectile-speedbar projectile-rails projectile-codesearch phoenix-dark-mono-theme password-store paradox pallet org-page nyan-mode nvm nlinum nim-mode neotree nav migemo markdown-mode magit jsx-mode json-mode js3-mode js2-refactor js2-highlight-vars js2-closure jira jenkins jekyll-modes jedi jdee indium imenu-list imenu-anywhere ibuffer-vc ibuffer-tramp ibuffer-rcirc ibuffer-projectile ibuffer-git highlight-indentation helm-swoop helm-projectile helm-git-grep helm-ag haskell-mode google-c-style golint golden-ratio gitconfig-mode git-gutter-fringe gist ggtags flymd flycheck-ycmd flycheck-rust flycheck-nim flycheck-elixir fill-column-indicator expand-region evil emmet-mode elscreen elixir-yasnippets ein dired+ d-mode ctags-update csv-mode counsel-projectile company-ycmd company-web company-tern company-restclient company-quickhelp company-php company-lua company-jedi company-inf-ruby company-go company-erlang common-lisp-snippets commander clojure-mode cask-mode cargo calfw brainfuck-mode avy arch-packer angular-mode)))
 '(paradox-github-token t t)
 '(sml/no-confirm-load-theme 1)
 '(sml/theme (quote light))
 '(speedbar-show-unknown-files t)
 '(tool-bar-mode nil))
;;; init.el ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
