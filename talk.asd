;;;; talk.asd

(asdf:defsystem #:talk
  :description "Weeee"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "GPL v3"
  :serial t
  :depends-on (#:cepl.sdl2 #:cepl.camera #:cepl.skitter.sdl2
                           #:cepl.sdl2-ttf
                           #:classimp #:fn #:named-readtables #:cl-fad
                           #:temporal-functions #:dendrite #:easing
                           #:swank.live #:pile #:pathology ;; #:completable-types
                           #:filmic-tone-mapping-operators #:dirt
                           #:nineveh)
  :components ((:file "package")
               (:file "fonts")
               (:file "base")
               (:file "demos/0")
               (:file "demos/1")
               (:file "wip")))
