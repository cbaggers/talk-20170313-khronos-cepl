(in-package :talk)

(defun lambda-reader (stream char)
  (declare (ignore char))
  (let* ((body (read stream t nil t)))
    (fn*-internals body nil)))


(named-readtables:defreadtable hashtable-reader
  (:merge :standard)
  (:macro-char #\GREEK_SMALL_LETTER_LAMDA #'lambda-reader t))
