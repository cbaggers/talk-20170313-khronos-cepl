;;;; talk.asd

(asdf:defsystem #:talk
  :description "Weeee"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "GPL v3"
  :serial t
  :depends-on (#:cepl.sdl2 #:cepl.camera #:cepl.skitter.sdl2
                           #:classimp #:fn #:named-readtables #:cl-fad
                           #:temporal-functions #:dendrite #:easing
                           #:swank.live #:pile #:pathology #:completable-types
                           #:filmic-tone-mapping-operators #:dirt
                           #:nineveh)
  :components ((:file "package")
               (:file "base")))
