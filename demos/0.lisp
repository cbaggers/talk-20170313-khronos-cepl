(in-package :talk)

(defvar *cube-lisp-data* (dendrite.primitives:cube-data))

(defun now () (get-internal-real-time))

(defun step-demo0 ())

;;------------------------------------------------------------

;; (defstruct-g vert-pnt
;;   (position :vec3 :accessor pos)
;;   (normal :vec3 :accessor norm)
;;   (texture :vec2 :accessor tex))

;; (defvar *cube-stream*)

;; (defun make-stream (data)
;;   (destructuring-bind (verts indices) data
;;     (let ((gverts (make-gpu-array verts :element-type 'vert-pnt))
;;           (gindex (make-gpu-array indices :element-type :ushort)))
;;       (make-buffer-stream gverts :index-array gindex :retain-arrays t))))

;; (defun-g vert ((vert vert-pnt) &uniform (model->clip :mat4))
;;   (values (v! (pos vert) 1)
;;           (norm vert)
;;           (tex vert)))

;; (defun-g frag ((norm :vec3) (uv :vec2))
;;   (v! 1 0 0 0))

;; (def-g-> draw-thing ()
;;   :vertex (vert vert-pnt)
;;   :fragment (frag :vec3 :vec2))

;; (map-g #'draw-thing *cube-stream*
;;          :model->clip model->clip
;;          :sam *cube-sampler*)

;;(defvar *rot* (v! 0f0 0f0 0f0))

;; (setf *rot* (v! (cos (now))
;;                 (sin (now))
;;                 0))
;; (let* ((vp (current-viewport))
;;        (model->clip (m4:* (rtg-math.projection:perspective-v2
;;                            (viewport-resolution vp) 1f0 200f0 120f0)
;;                           (m4:translation (v! 0 0 -3))
;;                           (m4:rotation-from-euler *rot*)))))
