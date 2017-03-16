;;;; package.lisp

(uiop:define-package #:talk
    (:use #:cl #:cepl #:named-readtables #:varjo-lang #:rtg-math
          :rtg-math.base-maths :rtg-math.types
          #:skitter.sdl2.keys #:skitter.sdl2.mouse-buttons
          #:nineveh))
