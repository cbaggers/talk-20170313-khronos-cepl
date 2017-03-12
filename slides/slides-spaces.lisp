;; (in-package :talk)

(slide 0 "Beyond the Spec")

(slide 1 "So you can write weird GLSL.."
  ("- Provide tools beyond the spec"
   "- Looked for things I mixed up a lot"
   "- Working with spaces really stood out")
  ())

(slide 2 "Spaces"
  "- Matrices represent a transform between 2 spaces"
  "- Felt more like a verb"
  "- Seemed odd to have no representation for the spaces"
  (:image "space0.png"))

(slide 3 "Plan"
  "- Make a type for space"
  "- Make a type for spatial vectors"
  "- Make some syntax for a scope"
  "- Make sure spatial vectors in the scope are in the space")

(slide 4 "CPU Side (Space Graph)"
  "- We make a type for spaces. They can be realted hierarchically or not"
  "- We have a function called get-transform that takes two spaces and
     the matrix from one to another")

(slide 5 "The 'In' Macro"
  ("- 'in' is going to define our scope"
   (:image "space1.png")))

(slide 6 "space-boundary-convert"
  ("- Is going to be function with a compiler-macro"
   "- If the argument type is a space it will:"
   " - Look at the type of the surrounding space"
   " - Look at the type of the argument's space"
   " - Add an implicit uniform which will call get-transform with the two
       uniforms on the CPU side"))

(slide 7 "Any use?"
  ("Pros:"
   "- Its works!"
   "- No changes to the compiler"
   "- Seperate library")
  ("Cons:"
   "- Inefficient in some places"
   "- Doesnt cover all cases"))
