(in-package :talk)

(slide 0 "DSL for Blur Kernels")

(slide 1 "The kernel in the Literature"
  ("Whenever I saw the literature it showed stuff like this:"
   (:image "kern0.png" :pos (0.0 0.0))))

(slide 2 "The kernel in code"
  ("It's not complicated but not a clear as the grid"
   (:image "kern1.png" :pos (0.0 0.0))))

;; (slide 3 "Throw a macro into the mix")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun calc-edge-len (weights)
    (multiple-value-bind (edge-len remainder) (floor (sqrt (length weights)))
      (assert (zerop remainder)) ;; is square
      (assert (oddp edge-len))
      edge-len)))

(defmacro def-kernel (name (&key normalize) &body weights)
  (let* (;; helpers values
         (edge-len (calc-edge-len weights))
         (offset (/ (- edge-len 1) 2))
         (weight-sum (reduce #'+ weights))
         ;;
         ;; sampling code
         (weight-index 0)
         (samples (loop :for y :from (- offset) :to offset
                     :append
                     (loop :for x :from (- offset) :to offset
                        :collect (let ((weight (elt weights weight-index)))
                                   `(* (texture tex (+ (* (v! ,x ,y) step) uv))
                                       ,weight))
                        :do (incf weight-index))))
         (body (if normalize
                   `(/ (+ ,@samples) ,weight-sum)
                   `(+ ,@samples))))
    ;;
    `(defun-g ,name ((tex :sampler-2d) (uv :vec2) (step :vec2))
       ,body)))

(def-kernel simplest ()
  1)

(def-kernel simple ()
  0 0 0
  0 1 0
  0 0 0)

(def-kernel edge ()
  -1 -1 -1
  -1  8 -1
  -1 -1 -1)

(def-kernel sharpen ()
  0  -1  0
  -1  5 -1
  0  -1  0)

(def-kernel gaussian-0 (:normalize t)
  1  4  6  4 1
  4 16 24 16 4
  6 24 36 24 6
  4 16 24 16 4
  1  4  6  4 1)

(defun-g quad-vert ((vert :vec2))
  (values (v! vert 0 1)
          (+ (* vert 0.5) (v2! 0.5))))

(defun-g apply-kernel-frag ((uv :vec2) &uniform (tex :sampler-2d) (step :vec2))
  (simple tex uv step)
  ;;(gaussian-0 tex uv step)
  ;;(edge tex uv step)
  ;;(sharpen tex uv step)
  )

(def-g-> apply-kernel ()
  (quad-vert :vec2)
  (apply-kernel-frag :vec2))

(defun play (sampler)
  (let ((vp (make-viewport
             (texture-base-dimensions (sampler-texture sampler)))))
    (as-frame
      (with-viewport vp
        (map-g #'apply-kernel (get-quad-stream-v2)
               :tex sampler
               :step (v2:/ (v! 1 1) (viewport-resolution vp)))))))
