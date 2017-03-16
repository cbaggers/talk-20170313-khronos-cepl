;;;; talk.asd

(asdf:defsystem #:talk
  :description "Weeee"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "GPL v3"
  :serial t
  :depends-on (#:cepl.sdl2 #:cepl.skitter.sdl2 #:cepl.sdl2-ttf #:cl-fad
                           #:dendrite #:swank.live #:dirt #:nineveh)
  :components ((:file "package")
               (:file "fonts")
               (:file "base")
               (:file "demos/0")
               (:file "demos/1")
               (:file "slides")))
