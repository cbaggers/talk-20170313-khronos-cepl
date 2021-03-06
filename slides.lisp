(in-package :talk)

(slide 0 "Lisping on the GPU")

(slide 1 "What I'll be yakking about tonight"
  ("CEPL & Varjo - Lispy GL"
   "• What was the original plan?"
   "• What is it now?"
   "    • Quick lisp intro"
   "    • Demos"
   "• Where can it go?"))

(slide 2 "Obligatory 'me' slide"
  ("• github.com/cbaggers"
   "• techsnuffle.com"
   "• Lisping for ~5 years"
   "• Programmer at Fuse (We are hiring!)"
   (:image "fuse0.png" :pos (0 -0.4))))

(slide 3 "How did this get started?"
  ("- Frustration from hittings walls in environments")
  ("- XNA promising but disolved")
  ("- The two approaches to GL in many libraries"))

(slide 4 "Lisp? Lisp."
  ()
  ("History is all well and good, but not for this talk.")
  ("Common Lisp:"
   "• Eager"
   "• Dynamically Typed"
   "• Incrementally Compiled")
  ("• Compiled or Interpreted (But we only care about compiled for this)"
   "• Declare things to the compiler")
  ("• Excellent package-manager, ffi, editor integration, etc etc"
   (:image "emacs0.png" :pos (0.8 -0.55)))
  ("• Not an academic curiosity")
  ("• MACROS :)"))

(slide 5 "What to make?"
  ((:image "lego0.png" :pos (0 -0.5)))
  ("• Not an Engine"
   "• Don't hide GL"
   "    • I want all of it")
  ("• Has to feel like lisp")
  ("• Got to be possible to make 'real' stuff")
  ("• something something livecodingg")) ;;---11mins going fast

(slide 6 "Lisp Intermission")

(slide 7 "Speedy Lisp Introduction"
  ("After the reader has done it's thing..")
  ("Evaluation Basics:")
  ((:text "1 -> 1" :font "DroidSansMono.ttf")
   (:text "\"foo\" -> \"foo\"" :font "DroidSansMono.ttf"))
  ((:text "foo -> <value bound to foo>" :font "DroidSansMono.ttf"))
  ((:text "(bar 1 2)  ~  bar(1, 2);" :font "DroidSansMono.ttf"))
  ((:text "(bar 1 foo (+ 4 5))  ~  bar(1, foo, (4+5));" :font "DroidSansMono.ttf")))

(slide 8 "Speedy Lisp Introduction"
  ("Evaluation Basics (quote):"
   (:text "(+ 10 20) -> 30" :font "DroidSansMono.ttf"))
  ((:text "'(+ 10 20) -> (+ 10 20)" :font "DroidSansMono.ttf"))
  ((:text "(first '(+ 10 20)) -> +" :font "DroidSansMono.ttf")
   (:text "(type-of (first '(+ 10 20))) -> SYMBOL" :font "DroidSansMono.ttf")
   (:text "(second '(+ 10 20)) -> 10" :font "DroidSansMono.ttf")))

(slide 9 "Speedy Lisp Introduction"
  ("Evaluation Basics (quasi-quote):")
  ((:text "'((+ 1 2) (+ 1 2)) -> ((+ 1 2) (+ 1 2))" :font "DroidSansMono.ttf")
   (:text "`((+ 1 2) ,(+ 1 2)) -> ((+ 1 2) 3)" :font "DroidSansMono.ttf")
   (:image "parens0.png" :pos (0 -0.3))))

(slide 10 "And that's how it works!"
  ()
  ("..except for when it isn't  :|")
  ("Evaluation Basics (special-forms):")
  ((:text "(if (the-reds-are-coming)" :font "DroidSansMono.ttf")
   (:text "    (fire-ze-missiles)" :font "DroidSansMono.ttf" :spacing 2)
   (:text "    (have-a-nap))" :font "DroidSansMono.ttf" :spacing 2)
   (:text "" :size 25)
   (:text "(let ((foo 10))" :font "DroidSansMono.ttf")
   (:text "  (* foo 10)) -> 100" :font "DroidSansMono.ttf" :spacing 2)))

(slide 11 "Macros"
  ("'The worst thing about macros is the name'"
   (:text " - some smartass -" :size 20))
  ("Macros are functions. What is interesting about them is not 'what' they do,"
   "but 'when'.")
  ("")
  ("Can be easier to think of them as hooks into the compiler"))

(slide 12 "Kinds of macro"
  ("Regular Macro (AST Transform):"
   (:text "(or x y)" :font "DroidSansMono.ttf"))
  ((:text "(let ((tmp0 x))" :font "DroidSansMono.ttf")
   (:text "  (if tmp0" :font "DroidSansMono.ttf" :spacing 2)
   (:text "      tmp0" :font "DroidSansMono.ttf" :spacing 2)
   (:text "      (let ((tmp1 y))" :font "DroidSansMono.ttf" :spacing 2)
   (:text "        (if tmp1" :font "DroidSansMono.ttf" :spacing 2)
   (:text "            tmp1" :font "DroidSansMono.ttf" :spacing 2)
   (:text "            nil))))" :font "DroidSansMono.ttf" :spacing 2)))

(slide 13 "Kinds of macro"
  ("Reader Macro (Hook into the parser):"
   (:text "(length [1 2 3 4]) -> 4" :font "DroidSansMono.ttf")
   (:text "{:a 1 :b 2} -> #<HASHTABLE>" :font "DroidSansMono.ttf")
   ""
   "Compiler Macro (Optimize function call site)"
   ""
   "Symbol Macros"))

(slide 14 "Intermission Over (well done to those who remain)") ;;---21mins going fast

(slide 15 "Bringing GL to Lisp"
  ("GL is kind of beautiful")
  ("• Places to store data (buffers/textures)"
   "• Views on the data (samplers/vaos/ubos)"
   "• Ways to define & compose functionality (shaders/programs)"
   "• Things to write data into (FBOs/Render-Buffers)")
  (""
   "The API isn't any kind of beautiful"
   "• Dead horse"))

(slide 16 "Bringing GL to Lisp"
  ("Patterns start to appear:")
  ("• Buffers are raw, but data has structure")
  ("• Textures are structures of images, and images are 1D->3D arrays")
  ("• VAOs: GLWiki describes them using the phrase 'stream of vertices'")
  ("• No reason not to use Sampler Objects")
  ("• FBOs are already great :)")
  ("Only the question of shaders.."))

(slide 17 "Shaders & Pipelines - Bringing Lisp to GL"
  ("• Strings are weak encryption & compose poorly")
  ("• All projects seem to grow some way of handling this")
  ("• Really we are dealing with blocks of functionality")
  ("• We already have an analogy for that")
  ("Let's see how we far we can get with functions"))

(slide 18 "Shaders & Pipelines - Functions"
  ("• What are the differences between regular functions and the main function?")
  ("• How does the function metaphor work for pipelines?")
  ("• Are there any advantages to making the pipeline a function?")
  ("• How do we use the pipeline?")
  ("That only leaves the syntax issue."))

(slide 19 "Shaders & Pipelines - The language"
  ("The mental context switching of the language was bigger than I expected"
   "so it became a higher priority.")
  (""
   (:text "    (texture tex coords)" :font "DroidSansMono.ttf")
   (:text "    texture(tex, coords);" :font "DroidSansMono.ttf")
   "")
  ("can't be that hard.."))

(slide 20 "Varjo"
  ()
  ("• Standalone project"
   "• Takes lists, returns GLSL (and a bunch of other data)"
   "• Doesn't try to be too clever")
  ("Supports:"
   "• Type inference (and checking across stages)"
   "• Macros (all the kinds :])"
   "• Inline GLSL expressions"
   "• Separately defined functions & structs"
   "• Declarations (compile time metadata)"
   "• First-class functions (now with caveats!)"))

(slide 21 "Too much talking! Demo time") ;; --- 32min

(slide 22 "Demo 0"
  ("Let's mess with some primitives"
   (:frame #'step-demo0 :size (1 1))))

(slide 23 "Demo 1: DSL for Blur Kernels")

(slide 24 "Demo 1: The kernel in the Literature"
  ("Whenever I saw the literature it showed stuff like this:"
   (:image "kern0.png" :pos (0.0 -.2))))

(slide 25 "The kernel in code"
  ("It's not complicated but not "
   "as clear as the grid"
   (:image "kern1.png" :pos (0.3 0.0))))

(slide 26 "Let's throw a macro at this"
  ("If the transformation is trivial and tedious, automate it."
   "Let's compile the kernel instead"
   ""
   (:text "(def-kernel k-edge ()" :font "DroidSansMono.ttf")
   (:text "  -1 -1 -1" :font "DroidSansMono.ttf")
   (:text "  -1  8 -1" :font "DroidSansMono.ttf")
   (:text "  -1 -1 -1)" :font "DroidSansMono.ttf")
   ""
   (:text "(defun-g <SOME-NAME> ((tex :sampler-2d)" :font "DroidSansMono.ttf")
   (:text "                      (uv :vec2)" :font "DroidSansMono.ttf")
   (:text "                      (step :vec2))" :font "DroidSansMono.ttf")
   (:text "  <THE-BODY>)" :font "DroidSansMono.ttf")))

(slide 27 "The Body"
  (""
   (:text "(+ (* <A-CALL-TO-TEXTURE> <SOME-WEIGHT>)" :font "DroidSansMono.ttf")
   (:text "   (* <A-CALL-TO-TEXTURE> <SOME-WEIGHT>)" :font "DroidSansMono.ttf")
   (:text "   ..)" :font "DroidSansMono.ttf")
   ""
   "• or -"
   ""
   (:text "(/ (+ (* <A-CALL-TO-TEXTURE> <SOME-WEIGHT>)" :font "DroidSansMono.ttf")
   (:text "      (* <A-CALL-TO-TEXTURE> <SOME-WEIGHT>)" :font "DroidSansMono.ttf")
   (:text "      ..)" :font "DroidSansMono.ttf")
   (:text "   <SUM-OF-ALL-THE-WEIGHTS>)" :font "DroidSansMono.ttf")))

(slide 28 "Demo 1"
  ("Let's make/uncomment it:"
   (:frame #'step-demo1 :size (1 1))))

(slide 29 "Demo 2"
  ("This was the PBR slide but I've remove it as the dependency is a bit crazy"))

(slide 30 "Issues, Mistakes & Failures"
  ()
  ("• Still not a graphics programmer :)")
  ("• The inevitable engine")
  ("• Livecoding is an approach, not a technology")
  ("    • Many things fall under the name")
  ("    • Performance -v- Creativity -v- Improvisation")
  ("    • Content is still hard"
   "        • MATLAB")
  ("    • API consequences of livecoding"
   "        • Recreating the recompile loop")
  ("• Dynamically typed code has it's issues"))

(slide 31 "Is it over yet?")

(slide 32 "..I mean..What next!?")

(slide 33 "Future"
  ("• Keep fleshing out CEPL & Varjo (GL & Lisp sides)"
   "• More surrounding libraries"
   "• Alternate type systems"
   "• Make stuff and explore live-coding some more"))

(slide 34 "Thankyou!")

(slide 35 "Questions?")
