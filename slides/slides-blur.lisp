;;(in-package :talk)

(slide 0 "DSL for Blur Kernels")

(slide 1 "The kernel in the Literature"
  ("Whenever I saw the literature it showed stuff like this:"
   (:image "kern0.png" :pos (0.1 0.5) :size 0.5)))

(slide 2 "The kernel in code"
  ("It's not complicated but also not"
   (:image "kern1.png" :pos (0.1 0.5) :size 0.5)))

(slide 3 "Throw a macro into the mix")

(defmacro defkernel (name &body weights)
  )

(defkernel simple
  0 0 0
  0 1 0
  0 0 0)
