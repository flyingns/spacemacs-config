;; packages.el --- sinkerine-writting layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sinkerine <sinkerine@Sinkerines-MacBook-Pro.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst sinkerine-writing-packages
  '(
    org
    impatient-mode
    org-preview-html
    prodigy
    )
  )

(defun sinkerine-writing/init-impatient-mode ()
  (use-package impatient-mode
    :defer t
    )
  (add-hook 'impatient-mode-hook 'my-impatient-mode-hook)
  )

(defun sinkerine-writing/init-org-preview-html ()
  (use-package org-preview-html
    :defer t
    )
  )

(defun sinkerine-writing/post-init-org ()
  (with-eval-after-load 'org
    (progn
      (define-key org-mode-map (kbd "<drag-n-drop>") 'my-dnd-func)
      (define-key org-mode-map (kbd "<S-drag-n-drop>") 'my-dnd-func)
      (define-key org-mode-map (kbd "<C-drag-n-drop>") 'my-dnd-func)
      (define-key org-mode-map (kbd "<M-drag-n-drop>") 'my-dnd-func)

      (setq org-image-actual-width '(300))
      (setq org-export-show-temporary-export-buffer nil)
      (setq org-indent-mode 1)
      ;; blog post
      (spacemacs/set-leader-keys-for-major-mode 'org-mode ">" 'my-org-post-html)
      (spacemacs/set-leader-keys-for-major-mode 'org-mode "C-p" 'org-preview-html-mode)
      (spacemacs/set-leader-keys-for-major-mode 'org-mode "C-l" 'my-replace-current-mdlink-to-orglink)
      ;; agenda
      (setq org-agenda-inhibit-startup t)   ;; ~50x speedup
      (setq org-agenda-use-tag-inheritance nil) ;; 3-4x speedup
      (load-library "find-lisp")
      (setq org-agenda-files (find-lisp-find-files "~/Geek/Wiki/notes" "\.org$"))

      ;; line wrap
      (setq org-startup-truncated nil)
      ))
  )

(defun sinkerine-writing/post-init-prodigy ()
   (setq hexo-exec "hexo")
   (prodigy-define-service
     :name "Hexo Generate"
     :command hexo-exec
     :args '("generate")
     :cwd blog-path
     :kill-signal 'sigkill
     :kill-process-buffer-on-stop t
     )
   (prodigy-define-service
     :name "Hexo Clean"
     :command hexo-exec
     :args '("clean")
     :cwd blog-path
     :kill-signal 'sigkill
     :kill-process-buffer-on-stop t
     )
   (prodigy-define-service
     :name "Hexo Server"
     :command hexo-exec
     :args '("server" "-o")
     :cwd blog-path
     :kill-signal 'sigkill
     :kill-process-buffer-on-stop t
     )
   (prodigy-define-service
     :name "Hexo Deploy"
     :command hexo-exec
     :args '("deploy" "--generate")
     :cwd blog-path
     :kill-signal 'sigkill
     :kill-process-buffer-on-stop t
     )
   (prodigy-define-service
     :name "Blog Qiniu Upload"
     :command "/usr/local/bin/qshell"
     :args (list "qupload" (concat user-home-directory ".qshell/blog_img.json"))
     :cwd "~/Geek/Wiki/static"
     :kill-process-buffer-on-stop 'sigkill
     :kill-process-buffer-on-stop nil
     )
  )
