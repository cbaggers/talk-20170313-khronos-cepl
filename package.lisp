;;;; package.lisp

(uiop:define-package #:talk
    (:use #:cl #:temporal-functions #:cepl #:named-readtables
          #:varjo-lang #:rtg-math :rtg-math.base-maths :rtg-math.types
          #:skitter.sdl2.keys #:skitter.sdl2.mouse-buttons
          #:filmic-tone-mapping-operators #:structy-defclass #:nineveh
          ;;#:completable-types
          ))
