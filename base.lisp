(in-package #:talk)

(defvar *slides* (make-hash-table))
(defvar *can-switch* t)
(defvar *slide-num* 0)
(defvar *group-num* 0)
(defvar *text-blending-params* (make-blending-params))
(defvar *slide-viewport* (make-viewport))
(defvar *frame-bg-color* (v! 0.082 0.082 0.082 0.0))

(defun add-slide (number slide)
  (let ((current (gethash number *slides*)))
    (when current
      (free current)))
  (setf (gethash number *slides*) slide))

(defun render-slide ()
  (cepl-utils:with-setf (clear-color *cepl-context*) *frame-bg-color*
    (with-viewport *slide-viewport*
      (as-frame
        (let ((slide (gethash *slide-num* *slides*)))
          (when slide
            (render slide)))))))

(defmethod render ((obj t))
  (format t "~%<STUB RENDER ~a>" obj))

(defun next ()
  (let ((slide (gethash *slide-num* *slides*)))
    (when slide
      (let ((group-count (length (slot-value slide 'element-groups))))
        (incf *group-num*)
        (if (>= *group-num* group-count)
            (next-slide)
            (render-slide))))))

(defun prev ()
  (decf *group-num*)
  (if (< *group-num* 0)
      (prev-slide)
      (render-slide)))

(defun next-slide ()
  (incf *slide-num*)
  (setf *group-num* 0)
  (render-slide))

(defun prev-slide ()
  (when (> *slide-num* 0)
    (decf *slide-num*))
  (let ((slide (gethash *slide-num* *slides*)))
    (setf *group-num*
          (if slide
              (1- (length (slot-value slide 'element-groups)))
              0))
    (render-slide)))

;;------------------------------------------------------------

(defclass slide ()
  ((element-groups :initarg :element-groups :initform nil)))

(defun make-slide (&rest element-groups)
  (make-instance 'slide :element-groups element-groups))

(defmethod free ((obj slide))
  (with-slots (element-groups) obj
    (loop :for group :in element-groups :do
       (map 'nil #'free group))))

(defmethod render ((obj slide))
  (with-slots (element-groups) obj
    (loop :for group :in element-groups :for i :below (1+ *group-num*) :do
       (loop :for element :in group :do
          (initialize element)
          (render element)))))

;;------------------------------------------------------------

(defclass frame ()
  ((func :initarg :func :initform nil)
   (viewport :initarg :viewport :initform nil)))

(defun make-frame (func &optional pos size)
  (make-instance 'frame :viewport (make-viewport (or size '(200 200))
                                                 (or pos '(0 0)))
                 :func func))

(defmethod initialize ((obj frame))
  nil)

(defmethod free ((obj frame))
  nil)

(defmethod render ((obj frame))
  (with-slots (func viewport) obj
    (with-viewport viewport
      (cepl-utils:with-setf (clear-color *cepl-context*) *frame-bg-color*
        (funcall func)))))

;;------------------------------------------------------------

(defclass image ()
  ((path :initarg :path :initform nil)
   (pos :initarg :pos :initform (v! 0 0))
   (texture :initarg :texture :initform nil)))

(defun make-image (path &optional pos)
  (make-instance 'image :path path :pos (or pos (v! 0 0))))

(defmethod initialize ((obj image))
  (with-slots (path texture) obj
    (unless texture
      (assert path)
      (setf texture (sample
                     (dirt:load-image-to-texture
                      (asdf:system-relative-pathname :talk path)))))))

(defmethod free ((obj image))
  (with-slots (text texture) obj
    (when texture
      (free (sampler-texture texture)))))

(defmethod render ((obj image))
  (with-slots (texture pos) obj
    (with-blending *text-blending-params*
      (nineveh::draw-tex-at texture pos))))

;;------------------------------------------------------------

(defclass big-text ()
  ((text :initarg :text :initform nil)
   (pos :initarg :pos :initform (v! 0 0))
   (texture :initarg :texture :initform nil)))

(defun make-big-text (text &optional pos)
  (make-instance 'big-text :text text :pos (or pos (v! 0 0))))

(defmethod initialize ((obj big-text))
  (with-slots (text texture) obj
    (unless texture
      (assert text)
      (setf texture (sample
                     (cepl.sdl2-ttf:text-to-tex
                      text (get-font "DroidSans-Bold.ttf" 110)
                      (v! 250 250 250 0)))))))

(defmethod free ((obj big-text))
  (with-slots (text texture) obj
    (when texture
      (free (sampler-texture texture)))))

(defmethod render ((obj big-text))
  (with-slots (texture pos) obj
    (with-blending *text-blending-params*
      (nineveh::draw-tex-at texture pos))))

;;------------------------------------------------------------

(defclass text ()
  ((text :initarg :text :initform nil)
   (point-size :initarg :point-size :initform 75)
   (font-name :initarg :font-name :initform "DroidSans.ttf")
   (pos :initarg :pos :initform (v! 0 0))
   (texture :initarg :texture :initform nil)))

(defun make-text (text
                  &optional pos (point-size 75) (font-name "DroidSans.ttf"))
  (make-instance 'text
                 :text text
                 :font-name font-name
                 :pos (or pos (v! 0 0))
                 :point-size point-size))

(defmethod initialize ((obj text))
  (with-slots (text texture font-name point-size) obj
    (unless texture
      (assert text)
      (setf texture (sample
                     (cepl.sdl2-ttf:text-to-tex
                      text (get-font font-name point-size)
                      (v! 230 230 230 0))
                     :wrap :clamp-to-edge)))))

(defmethod free ((obj text))
  (with-slots (text texture) obj
    (when texture

      (free (sampler-texture texture)))))

(defmethod render ((obj text))
  (with-slots (texture pos) obj
    (with-blending *text-blending-params*
      (nineveh::draw-tex-at texture pos nil))))

;;------------------------------------------------------------

(defmethod parse-element ((element string) pos)
  `(make-text ,element ,pos 75))

(defmethod parse-element ((element list) pos)
  (ecase (first element)
    (:image (destructuring-bind (path &key pos) (rest element)
              `(make-image ,path (v! ,@(or pos '(0 0))))))
    (:frame (destructuring-bind (func &key pos size) (rest element)
              (assert (eq (first func) 'function) ()
                      "frame arg ~a is not a function literal" func)
              `(make-frame ,(if func
                                `(lambda () (,(second func)))
                                #'identity)
                           ',(or pos '(0 0))
                           ',(or size '(200 200)))))))

(defmethod regular-slide ((number integer) (name string) (element-groups list))
  (assert (every #'listp element-groups))
  (let* ((y 0.85)
         (foo (loop :for group :in element-groups :collect
                 (append `(list (make-text ,name (v! -0.9 0.9) 100
                                           "DroidSans-Bold.ttf"))
                         (loop :for element :in group :when element :collect
                            (parse-element element (v! -0.9 (decf y 0.15))))))))
    `(add-slide ,number (make-slide ,@foo))))

(defmethod chapter-slide ((number integer) (name string))
  `(add-slide ,number (make-slide (list (make-big-text ,name)))))

;;------------------------------------------------------------

(defmacro slide (number name &body element-groups)
  (if element-groups
      (regular-slide number name element-groups)
      (chapter-slide number name)))

;;------------------------------------------------------------

(nineveh:def-simple-main-loop talk
  (setf (viewport-dimensions *slide-viewport*)
        (cepl::window-dimensions))
  (render-slide)
  (cond
    ((skitter:key-down-p skitter.sdl2.keys:key.n)
     (when *can-switch*
       (setf *can-switch* nil)
       (next)))
    ((skitter:key-down-p skitter.sdl2.keys:key.p)
     (when *can-switch*
       (setf *can-switch* nil)
       (prev)))
    (t (setf *can-switch* t))))
