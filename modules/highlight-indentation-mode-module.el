;;; package --- Summary:
;;; Code:
;;; Commentary:
;; highlight indentation
(use-package highlight-indentation-mode
    :ensure t
    :bind
    ("<f9>" . highlight-indentation-mode)
    :config
    (set-face-background 'highlight-indentation-face "grey20"))
(provide 'highlight-indentation-mode-module)
;;; highlight-indentation-mode-module ends here
