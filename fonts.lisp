(in-package :talk)

(defvar *fonts* (make-hash-table :test 'equal))

(defmethod get-font ((name string) (point-size integer))
  (cepl.sdl2-ttf:init)
  (let ((key (list name point-size)))
    (or (gethash key *fonts*)
        (setf (gethash key *fonts*)
              (let ((path (asdf:system-relative-pathname :talk name)))
                (sdl2-ttf:open-font path point-size))))))
