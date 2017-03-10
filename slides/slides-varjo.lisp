;; (in-package :talk)


(slide 0 "Meanwhile"
  ("- The context switching from lisp to glsl kinda sucked"
   "- Strings don't compose well")
  ("(texture tex coords)"
   "texture(tex, coords);")
  ("can't be that hard.."))

(slide 1 "Varjo"
  ()
  ("- Standalone project"
   "- Takes lists, returns glsl (and a bunch of other data)"
   "- loca"))

(slide ?? "First Class Functions (sorta)"
  "- Try to avoid #define"
  "- ")

#||

If we want to compiler different versions of a gpu function let's pass in what
we want to use.

Lisp already have an abstraction for passing functionality around in first
class functions

Don't get too clever, people have to reason about this.

Resolve the exact function for all call sites.

No closures (yet)

||#
