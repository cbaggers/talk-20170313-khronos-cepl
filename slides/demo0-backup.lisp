(in-package :talk)

(defvar *cube-lisp-data* (dendrite.primitives:cube-data))
(defvar *cube-stream*)

(defun now () (* (get-internal-real-time) 0.001))

(defun make-stream (data)
  (destructuring-bind (verts indices) data
    (let ((gverts (make-gpu-array verts :element-type 'g-pnt))
          (gindex (make-gpu-array indices :element-type :ushort)))
      (make-buffer-stream gverts :index-array gindex :retain-arrays t))))

(defun-g vert ((vert g-pnt) &uniform (model->clip :mat4))
  (let* ((pos (* model->clip (v! (pos vert) 1)))
         (norm (* model->clip (v! (norm vert) 0))))
    (values pos
            (s~ norm :xyz)
            (tex vert))))

(defun-g frag ((norm :vec3) (uv :vec2))
  (let ((light (normalize (v! 0 1 0))))
    (+ (* (saturate (dot norm light)) (v! 1 1 1 0))
       (v! 0.0 0.0 0.0 0))))

(def-g-> draw-thing ()
  (vert g-pnt)
  (frag :vec3 :vec2))

(defun step-test ()
  (let* ((vp (current-viewport))
         (cam->clip (rtg-math.projection:perspective-v2
                     (viewport-resolution vp) 1f0 200f0 120f0))
         (model->clip (m4:* cam->clip
                            (m4:translation (v! 0 0 -3))
                            (m4:rotation-from-euler (v! (sin (now))
                                                        (cos (now))
                                                        3)))))
    (map-g #'draw-thing *cube-stream*
           :model->clip model->clip)))

(defun test ()
  (as-frame
    (step-test)))
