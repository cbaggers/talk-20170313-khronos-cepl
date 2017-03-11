(in-package :talk)

(defun play (sampler)
  (let ((vp (make-viewport
             (texture-base-dimensions (sampler-texture sampler)))))
    (as-frame
      (with-viewport vp
        (map-g #'apply-kernel (get-quad-stream-v2)
               :tex sampler
               :step (v2:/ (v! 1 1) (viewport-resolution vp)))))))
