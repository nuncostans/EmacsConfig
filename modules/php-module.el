;;; package --- Summary
;;; Commentary:
;;; php module
;;; Code:

(add-hook 'php-mode-hook 'my-php-mode-hook)
(defun my-php-mode-hook ()
    "My PHP mode configuration."
    c-basic-offset 2)

;; php mode hook :)
(add-hook 'php-mode-hook 'php-enable-symfony2-coding-style)

(provide 'php-module)
;;; php-module.el ends here
