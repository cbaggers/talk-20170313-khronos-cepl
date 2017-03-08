(in-package #:talk)

(defvar *slides* (make-hash-table))

(defvar *slide-num* 0)
(defvar *group-num* 1)
(defvar *text-blending-params* (make-blending-params))
(defvar *slide-viewport* (make-viewport))

(defun add-slide (number slide)
  (let ((current (gethash number *slides*)))
    (when current
      (free current)))
  (setf (gethash number *slides*) slide)
  (setf *slide-num* number)
  (setf *group-num* 1)
  (when *gl-context*
    (render-slide)))

(defun render-slide ()
  (step-host)
  (setf (viewport-dimensions *slide-viewport*)
        (cepl::window-dimensions)
        ;;'(1378 768)
        )
  (cepl-utils:with-setf (clear-color *cepl-context*)
      (v! 0.082 0.082 0.082 0.0)
    (with-viewport *slide-viewport*
      (as-frame
        (let ((slide (gethash *slide-num* *slides*)))
          (when slide
            (render slide)))))))

(defmethod render ((obj t))
  (format t "~%<STUB RENDER ~a>" obj))

(defun next-slide ()
  (incf *slide-num*)
  (setf *group-num* 1)
  (render-slide))

(defun prev-slide ()
  (decf *slide-num*)
  (setf *group-num* 1)
  (render-slide))

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
    (loop :for group :in element-groups :for i :below *group-num* :do
       (loop :for element :in group :do
          (initialize element)
          (render element)))))

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
    (:image nil)))

(defmethod regular-slide ((number integer) (name string) (element-groups list))
  (assert (every #'listp element-groups))
  (let* ((y 0.85)
         (foo (loop :for group :in element-groups :collect
                 (append `(list (make-text ,name (v! -0.9 0.9) 100
                                           "DroidSans-Bold.ttf"))
                         (loop :for element :in group :when element :collect
                            (parse-element element (v! -0.9 (decf y 0.07))))))))
    `(add-slide ,number (make-slide ,@foo))))

(defmethod chapter-slide ((number integer) (name string))
  `(add-slide ,number (make-slide (list (make-big-text ,name)))))

;;------------------------------------------------------------

(defmacro slide (number name &body element-groups)
  (if element-groups
      (regular-slide number name element-groups)
      (chapter-slide number name)))

(slide 0 "Hooo?")

(slide 1 "Lisping on the GPU")

(slide 2 "WAT"
  ("- Why do this ?"
   "- What we have now"
   "- Where we can go"))

;;------------------------------------------------------------

;; - take size and scale plain to size
;; - crash because of threads
;; - -1 texture id?
