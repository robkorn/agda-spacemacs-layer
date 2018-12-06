;;; packages.el --- Agda2 Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Oliver Charles <ollie@ocharles.org.uk>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq personalAgda-packages
      '((agda :location local)
        company
        golden-ratio))

(defun personalAgda/post-init-company ()
  (spacemacs|add-company-hook agda2-mode)
  (push 'company-capf company-backends-agda2-mode))

(defun personalAgda/init-agda ()
  (if (and (eq 'use-helper agda-mode-path)
           (not (executable-find "agda-mode")))
      (spacemacs-buffer/warning
       (concat "Couldn't find `agda-mode', make sure it is "
               "available in your PATH or check the installation "
               "instructions in the README file."))

    (when (eq 'use-helper agda-mode-path)
      (setq agda-mode-path (let ((coding-system-for-read 'utf-8))
                             (shell-command-to-string "agda-mode locate"))))

    (use-package agda2-mode
      :defer t
      :init (when agda-mode-path (load-file agda-mode-path))
      (progn
        (mapc
         (lambda (x) (add-to-list 'face-remapping-alist x))
         '((agda2-highlight-datatype-face              . font-lock-type-face)
           (agda2-highlight-function-face              . font-lock-type-face)
           (agda2-highlight-inductive-constructor-face . font-lock-function-name-face)
           (agda2-highlight-keyword-face               . font-lock-keyword-face)
           (agda2-highlight-module-face                . font-lock-constant-face)
           (agda2-highlight-number-face                . nil)
           (agda2-highlight-postulate-face             . font-lock-type-face)
           (agda2-highlight-primitive-type-face        . font-lock-type-face)
           (agda2-highlight-record-face                . font-lock-type-face))))
      :config
      (progn

        (spacemacs/declare-prefix-for-mode 'agda2-mode "mb" "agda/build")
        (spacemacs/declare-prefix-for-mode 'agda2-mode "mi" "agda/editing")
        (spacemacs/declare-prefix-for-mode 'agda2-mode "mh" "agda/helper")
        (spacemacs/declare-prefix-for-mode 'agda2-mode "ms" "agda/repl")

        (spacemacs|define-transient-state goal-navigation
          :title "Goal Navigation Transient State"
          :doc "\n(_]_) next (_[_) previous (_q_) quit"
          :bindings
          ("]" agda2-next-goal)
          ("[" agda2-previous-goal)
          ("q" nil :exit t))
        (spacemacs/set-leader-keys-for-major-mode 'agda2-mode
          "]" 'spacemacs/goal-navigation-transient-state/agda2-next-goal
          "[" 'spacemacs/goal-navigation-transient-state/agda2-previous-goal)

        (spacemacs/set-leader-keys-for-major-mode 'agda2-mode
          "?"   'agda2-show-goals
          "."   'agda2-goal-and-context-and-inferred
          ","   'agda2-goal-and-context
          "="   'agda2-show-constraints

          "iSPC" 'agda2-give
          "ia"   'agda2-auto
          "ic"   'agda2-make-case
          "ir"   'agda2-refine
          "is"   'agda2-solveAll
          "in"   'agda2-compute-normalised-maybe-toplevel

          "hh"   'agda2-helper-function-type
          "hd"   'agda2-infer-type-maybe-toplevel
          "he"   'agda2-show-context
          "hp"   'agda2-module-contents-maybe-toplevel
          "hi"  'agda2-display-implicit-arguments
          "ht"   'agda2-goal-type
          "hw"   'agda2-why-in-scope-maybe-toplevel

          "gG"  'agda2-go-back

          "l"   'agda2-load
          "sb"   'agda2-load
          "sr"  'agda2-restart
          "sq"  'agda2-quit

          "bc"  'agda2-compile
          "bd"  'agda2-remove-annotations
          )))))

(defun personalAgda/pre-init-golden-ratio ()
  (spacemacs|use-package-add-hook golden-ratio
    :post-config
    (add-to-list 'golden-ratio-exclude-buffer-names
                 "*Agda information*")))
