;; Copyright 2006-2018 Michalis Kamburelis.
;;
;; This file is part of "Castle Game Engine".
;;
;; "Castle Game Engine" is free softwaresee the file COPYING.txt,
;; included in this distribution, for details about the copyright.
;;
;; "Castle Game Engine" is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTYwithout even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;;
;; ----------------------------------------------------------------------------

;; Replacing utilities ---------------------------------------------------------

(defun kam-simple-replace (from-string to-string from-pos
  &optional end-pos fixedcase)
  (save-excursion
    (goto-char from-pos)
    (while (search-forward from-string end-pos t)
      (replace-match to-string fixedcase t)
    ))
)

(defun kam-simple-re-replace (from-string to-string from-pos
  &optional end-pos fixedcase)
  "Replace text in current buffer from FROM-STRING to TO-STRING,
starting from position FROM-POS to END-POS (END-POS = nil means
to the end of buffer).

Current position of cursor is not changed by this function.
Uses regexps. FIXEDCASE has the same meaning as in `replace-match'."
  (save-excursion
    (goto-char from-pos)
    (while (re-search-forward from-string end-pos t)
      (replace-match to-string fixedcase nil)))
)

(defun kam-simple-replace-buffer (from-string to-string)
  "Simple replace in whole buffer. Without asking user."
  (interactive)
  (kam-simple-replace from-string to-string (point-min))
)

(defun kam-simple-re-replace-buffer (from-string to-string)
  "Simple regexp replace in whole buffer. Without asking user."
  (interactive)
  (kam-simple-re-replace from-string to-string (point-min))
)

;; kam-update-copyright-year -------------------------------------------------

(defun kam-update-copyright-year ()
  (interactive)
  ;; append year to our copyrights
  (kam-simple-re-replace-buffer
    "Copyright \\([0-9][0-9][0-9][0-9]\\)\\([,-][-0-9,]+\\)?"
    "Copyright \\1-2018")
  (save-buffer)
)
