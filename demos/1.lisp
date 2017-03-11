(in-package :talk)

(defun calc-edge-len (weights)
  (multiple-value-bind (edge-len remainder) (floor (sqrt (length weights)))
    (assert (zerop remainder)) ;; is square
    (assert (oddp edge-len))
    edge-len))

;; (def-kernel k-edge ()
;;   -1 -1 -1
;;   -1  8 -1
;;   -1 -1 -1)

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

;;------------------------------------------------------------

(defun step-demo1 ()
  )

;; (defun-g k-vert ((vert :vec2))
;;   (values (v! vert 0 1)
;;           (+ (* vert 0.5) (v2! 0.5))))

;; (defun-g k-frag ((uv :vec2) &uniform (tex :sampler-2d) (step :vec2))
;;   (k-edge tex uv step))

;; (def-g-> apply-kernel ()
;;   (k-vert :vec2)
;;   (k-frag :vec2))

;; (map-g #'apply-kernel (nineveh:get-quad-stream-v2)
;;        :tex *cube-sampler*
;;        :step (v2:/ (v! 1 1) (viewport-resolution (current-viewport))))

;; (def-kernel k-id ()
;;   0 0 0
;;   0 1 0
;;   0 0 0)

;; (def-kernel k-edge ()
;;   -1 -1 -1
;;   -1  8 -1
;;   -1 -1 -1)

;; (def-kernel k-sharpen ()
;;   0  -1  0
;;   -1  5 -1
;;   0  -1  0)

;; (def-kernel k-gaussian (:normalize t)
;;   1  4  6  4 1
;;   4 16 24 16 4
;;   6 24 36 24 6
;;   4 16 24 16 4
;;   1  4  6  4 1)

;;(make-fbo '(0 :dimensions (1366 768)) '(:d :dimensions (1366 768)))
