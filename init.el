;;; emacs setting file
;;; from gnupack
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ site-lisp                                                     ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
(let ((default-directory
	(file-name-as-directory (concat user-emacs-directory "site-lisp"))))
  (add-to-list 'load-path default-directory)
  (normal-top-level-add-subdirs-to-load-path))
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ package manager                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
(require 'package)
;;(add-to-list 'package-archives
;;             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;(add-to-list 'package-archives
;;             '("marmalade" . "http://marmalade-repo.org/packages/"))
(setq package-archives
      '(;;("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ language - coding system                                      ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;; デフォルトの文字コード
(set-default-coding-systems 'utf-8-unix)
;; テキストファイル／新規バッファの文字コード
(prefer-coding-system 'utf-8-unix)
;; ファイル名の文字コード
(set-file-name-coding-system 'utf-8-unix)
;; キーボード入力の文字コード
(set-keyboard-coding-system 'utf-8-unix)
;; サブプロセスのデフォルト文字コード
(setq default-process-coding-system '(undecided-dos . utf-8-unix))
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ screen - mode line                                            ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;; 行番号の表示
(line-number-mode t)
;; 列番号の表示
(column-number-mode t)
;; 改行コードの表記追加
(setq eol-mnemonic-dos       ":Dos ")
(setq eol-mnemonic-mac       ":Mac ")
(setq eol-mnemonic-unix      ":Unx ")
(setq eol-mnemonic-undecided ":??? ")
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ screen - cursor                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;; カーソルの点滅
(blink-cursor-mode 0)
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ screen - linum                                                ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
(require 'linum)
;; 行移動を契機に描画
(defvar linum-line-number 0)
(declare-function linum-update-current "linum" ())
(defadvice linum-update-current
    (around linum-update-current-around activate compile)
  (unless (= linum-line-number (line-number-at-pos))
    (setq linum-line-number (line-number-at-pos))
    ad-do-it
    ))
;; バッファ中の行番号表示の遅延設定
(defvar linum-delay nil)
(setq linum-delay t)
(defadvice linum-schedule (around linum-schedule-around () activate)
  (run-with-idle-timer 1.0 nil #'linum-update-current))
;; 行番号の書式
(defvar linum-format nil)
(setq linum-format "%5d")
;; バッファ中の行番号表示
(global-linum-mode t)
;; 文字サイズ
(set-face-attribute 'linum nil :height 0.75)
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ screen - hiwin                                                ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;(require 'hiwin)
;; hiwin-modeを有効化
;;(hiwin-activate)
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ search - isearch                                              ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;; 大文字・小文字を区別しないでサーチ
(setq-default case-fold-search nil)
;; インクリメント検索時に縦スクロールを有効化
(setq isearch-allow-scroll nil)
;; C-dで検索文字列を一文字削除
(define-key isearch-mode-map (kbd "C-d") 'isearch-delete-char)
;; C-yで検索文字列にヤンク貼り付け
(define-key isearch-mode-map (kbd "C-y") 'isearch-yank-kill)
;; C-eで検索文字列を編集
(define-key isearch-mode-map (kbd "C-e") 'isearch-edit-string)
;; Tabで検索文字列を補完
(define-key isearch-mode-map (kbd "TAB") 'isearch-yank-word)
;; C-gで検索を終了
(define-key isearch-mode-map (kbd "C-g")
  '(lambda() (interactive) (isearch-done)))
;; 日本語の検索文字列をミニバッファに表示
(define-key isearch-mode-map (kbd "<compend>")
  '(lambda() (interactive) (isearch-update)))
(define-key isearch-mode-map (kbd "<kanji>")
  'isearch-toggle-input-method)
(add-hook
 'isearch-mode-hook
 '(lambda() (setq w32-ime-composition-window (minibuffer-window)))
 )
(add-hook
 'isearch-mode-end-hook
 '(lambda() (setq w32-ime-composition-window nil))
 )

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ file - backup                                                 ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;; ファイルオープン時のバックアップ（~）
(setq make-backup-files   t)  ;; 自動バックアップの実行有無
(setq version-control     t)  ;; バックアップファイルへの番号付与
(setq kept-new-versions   3)  ;; 最新バックアップファイルの保持数
(setq kept-old-versions   0)  ;; 最古バックアップファイルの保持数
(setq delete-old-versions t)  ;; バックアップファイル削除の実行有無
;; ファイルオープン時のバックアップ（~）の格納ディレクトリ
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "/tmp/emacsbk"))
            backup-directory-alist))
;; 編集中ファイルの自動バックアップ
(setq backup-inhibited nil)
;; 終了時に自動バックアップファイルを削除
(setq delete-auto-save-files nil)
;; 編集中ファイルのバックアップ
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)
;; 編集中ファイルのバックアップ間隔（秒）
(setq auto-save-timeout 3)
;; 編集中ファイルのバックアップ間隔（打鍵）
(setq auto-save-interval 100)
;; 編集中ファイル（##）の格納ディレクトリ
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "/tmp/emacsbk") t)))
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ file - lockfile                                               ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;; ロックファイルの生成を抑止
(setq create-lockfiles nil)
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ scroll                                                        ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;; スクロール時のカーソル位置を維持
(setq scroll-preserve-screen-position t)
;; スクロール開始の残り行数
(setq scroll-margin 0)
;; スクロール時の行数
(setq scroll-conservatively 10000)
;; スクロール時の行数（scroll-marginに影響せず）
(setq scroll-step 0)
;; 画面スクロール時の重複表示する行数
(setq next-screen-context-lines 1)
;; キー入力中の画面更新を抑止
(setq redisplay-dont-pause t)
;; recenter-top-bottomのポジション
(setq recenter-positions '(top bottom))
;; 横スクロール開始の残り列数
(setq hscroll-margin 1)
;; 横スクロール時の列数
(setq hscroll-step 1)
;; スクロールダウン
(global-set-key (kbd "C-z") 'scroll-down)
;; バッファの最後までスクロールダウン
(defadvice scroll-down (around scroll-down activate compile)
  (interactive)
  (let (
        (bgn-num (+ 1 (count-lines (point-min) (point))))
        )
    (if (< bgn-num (window-height))
        (goto-char (point-min))
      ad-do-it) ))
;; バッファの先頭までスクロールアップ
(defadvice scroll-up (around scroll-up activate compile)
  (interactive)
  (let (
        (bgn-num (+ 1 (count-lines (point-min) (point))))
        (end-num nil)
        )
    (save-excursion
      (goto-char (point-max))
      (setq end-num (+ 1 (count-lines (point-min) (point))))
      )
    (if (< (- (- end-num bgn-num) (window-height)) 0)
        (goto-char (point-max))
      ad-do-it) ))
;;;;;;;;;;;;;;;;;;;;;;;;
;;; gnupackここまで ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;
;;; ここから ;;;
;;;;;;;;;;;;;;;;
;; disable startup message
(setq inhibit-startup-message t)
;; disable beep
(setq ring-bell-function 'ignore)
;;Altキーをmetaキーとして使う
(setq w32-alt-is-meta t)
;; カッコの対応をわかりやすく表示する
(show-paren-mode t)
;; theme setting
(load-theme 'wombat t)
;; auto-save-buffers
(require 'auto-save-buffers)
(run-with-idle-timer 0.5 t 'auto-save-buffers)
;; auto complete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'fundamental-mode)
(add-to-list 'ac-modes 'nxml-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)
(setq ac-use-fuzzy t)
;; pairence
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)
;; auto reload
(global-auto-revert-mode t)
;; タブにスペースを使用する
(setq-default tab-width 4 indent-tabs-mode nil)
;; ウィンドウを透明にする
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.90 0.85)))

;; ホイールでスクロールする行数を設定
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))

;; バッファ切り替え
(global-set-key (kbd "<C-tab>") '(lambda() (interactive) (bury-buffer)))
(global-set-key (kbd "<C-iso-lefttab>") '(lambda() (interactive) (unbury-buffer)))

;;emacsの画面内容をhtml化するhtmlizeでcssをインラインにする設定
(setq htmlize-output-type 'inline-css)

;; C-;でカーソルの行をコメントアウト or コメントイン
(defun one-line-comment ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (set-mark (point))
    (end-of-line)
    (comment-or-uncomment-region (region-beginning) (region-end))))
(global-set-key (kbd "C-;") 'one-line-comment)

;; xmlの設定
(add-to-list 'auto-mode-alist '("\\.launch$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.urdf$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xacro$" . nxml-mode))
(add-hook 'nxml-mode-hook
          (lambda ()
            (setq nxml-slash-auto-complete-flag t)))

;; ros
(add-to-list 'load-path "/opt/ros/DISTRO/share/emacs/site-lisp")

;;; シンボルをハイライト
;;; 1秒後自動ハイライトされるようになる
(setq highlight-symbol-idle-delay 1.0)
;;; 自動ハイライト
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
;;; ソースコードにおいてM-p/M-nでシンボル間を移動
(add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)

;;;;;;;;;;;;;;;;;;;;;;
;;; ubuntu専用設定 ;;;
;;;;;;;;;;;;;;;;;;;;;;
;; japanese inline input
;;(add-to-list 'load-path "/usr/share/emacs24/site-lisp/emacs-mozc")
(require 'mozc)
;;(set-language-environment "Japanese") ;; これがあると強制的にEUCになる
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'overlay)
(global-set-key [zenkaku-hankaku] 'toggle-input-method)
(global-set-key [henkan] 'mozc-mode) ;; 変換キーでmozcオン
;;(global-set-key [muhenkan] 'inactivate-input-method) ;; 無変換キーでオフ
(global-set-key [muhenkan] 'ignore)

;; フォント設定
(set-fontset-font t 'japanese-jisx0208 "Migu 1M")

;; フォントサイズ調整
(global-set-key (kbd "C-<mouse-6>")   '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-=")            '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-<mouse-7>") '(lambda() (interactive) (text-scale-decrease 1)))
(global-set-key (kbd "C--")            '(lambda() (interactive) (text-scale-decrease 1)))
;; フォントサイズ リセット
(global-set-key (kbd "M-0") '(lambda() (interactive) (text-scale-set 0)))

;; スクロール入力を無視
(global-set-key (kbd "<mouse-6>") 'ignore)
(global-set-key (kbd "<mouse-7>") 'ignore)
(global-set-key (kbd "S-<mouse-6>") 'ignore)
(global-set-key (kbd "S-<mouse-7>") 'ignore)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(highlight-symbol yaml-mode auto-complete-nxml launch-mode ros python-mode go-mode popup htmlize auto-complete))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Migu 1M" :foundry "Mig " :slant normal :weight normal :height 105 :width normal)))))
