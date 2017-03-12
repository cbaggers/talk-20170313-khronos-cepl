(in-package :talk)

;; in case of pile fucking up

(defun rescue-talk ()
  (setf *cube-stream* (make-stream *cube-lisp-data*))
  (setf *cube-tex* (dirt:load-image-to-texture "/home/baggers/Code/lisp/talk/wat0.png"))
  (setf *cube-sampler* (sample *cube-tex*))
  (setf *slide-num* 23)
  "let's try that again..")
