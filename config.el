;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "First Last"
      user-mail-address "first.last@example.com")

(add-load-path! "~/.config/doom/settings")

(require 'setup-company)
(require 'setup-treemacs)

(require 'setup-julia-ts-mode)
(require 'setup-treesit-auto)

(setq treesit-language-source-alist
      '((julia "https://github.com/tree-sitter/tree-sitter-julia")))
(setq treesit-auto-install 'prompt)

(require 'setup-vterm)

(remove-hook 'text-mode-hook #'spell-fu-mode)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "TheSansMono" :size 14 :weight 'medium)
      doom-symbol-font (font-spec :family "JuliaMono" :size 16 :weight 'medium))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'tango)
;; themes to try
;; tsdh-light, tango, doom-plain
;; doom-nord-light
;; doom-tomorrow-night, doom-wilmersdorf, *doom-tokyo-night*, doom-plain (light, black on grey)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq-default indent-tabs-mode nil)
(setq evil-escape-key-sequence "fj")

;; Clock settings in modeline
(setq display-time-default-load-average nil)
;; (format-time-string "%a %e %B --")
(setq display-time-format "%l:%M %p %e %b %a %_5j   ")
(display-time)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")
(setq org-directory "/Users/foo/Documents/org/")
(setq org-agenda-files "/Users/foo/Documents/org/agenda.org")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

 
;; Julia lang
;;
;; Julia LSP
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
    '(julia-ts-mode . "julia")))

(setq lsp-julia-package-dir nil)
(after! lsp-julia
  (setq lsp-julia-default-environment "~/.julia/environments/v1.10")
  (setq-hook! 'julia-ts-mode-hook +format-with-lsp nil))

(after! julia-ts-mode
  (add-hook! 'julia-ts-mode-hook
    (setq-local lsp-enable-folding t
                lsp-folding-range-limit 100)))
;;
;;
;; Julia REPL
(defun open-popup-new-frame (buffer &optional alist) (+popup-display-buffer-fullframe-fn buffer alist))
(use-package! julia-repl
  :hook (julia-ts-mode . julia-repl-mode)
  :config
  (setq julia-repl-executable-records '((default "julia" :basedir "/Users/foo/applications/julia10/usr/share/julia/base/")
                                        (dev "julia11" :basedir    "/Users/foo/applications/julia11/usr/share/julia/base/")))
  (setq julia-repl-executable-key 'default)
  (setq julia-repl-switches "-q -t 4,1")
  (set-popup-rule! "^\\*julia\\:.*\\*$" :actions '(display-buffer-pop-up-frame . inhibit-switch-frame)))


;; If using the dev julia-repl-executable-key (lines 136-137),
;; change line 122 to
;;   (setq lsp-julia-default-environment "~/.julia/environments/v1.11")
