(in-package :talk)

(slide 0 "Lisping on the GPU")

(slide 1 "Obligatory 'me' slide"
  ("- github.com/cbaggers"
   "- techsnuffle.com"
   "- Lisping for ~5 years"
   "- Programmer at Fuse (We are hiring!)"
   (:image "fuse0.png" :pos (0 -0.4))))

(slide 2 "What I'll be yaking about tonight"
  ("CEPL & Varjo"
   "- What were the original ideas?"
   "- What are they now?"
   "    - Quick lisp intro"
   "    - Demos"
   "- Where can it go?"))

(slide 3 "Past noodlings"
  ()
  ("- BASIC"
   "    - Small Game Engines")
  ("- C#"
   "    - XNA")
  ("- Python"
   "    - Weee!")) ;; the problem with engines

(slide 4 "Lisp? Lisp." ;; talk about joe and then lisp itself
  ()
  ("History is all well and good, but not for this talk:")
  ("- Eager"
   "- Dynamically Typed"
   "- Incrementally Compiled")
  ("- Compiled or Interpreted")
  ("- Declare things to the compiler")
  ("- MACROS   :-)"))  ;; standardization - for industry

(slide 5 "What to make?"
  ()
  ("- Not an Engine"
   "- Don't hide GL"
   "    - I want all of it")
  ("- Has to feel like lisp")
  ("- Got to be possible to make 'real' stuff")
  ("- something something livecoding"))

(slide 6 "Surprise Lisp Intermission!")

(slide 7 "Speedy Lisp Introduction"
  ()
  ("After the reader has done it's thing..")
  ("Evaluation Basics:")
  ((:text "1 -> 1" :font "DroidSansMono.ttf")
   (:text "\"foo\" -> \"foo\"" :font "DroidSansMono.ttf"))
  ((:text "foo -> <value bound to foo>" :font "DroidSansMono.ttf"))
  ((:text "(bar 1 2)" :font "DroidSansMono.ttf"))
  ((:text "(bar 1 foo (+ 4 5))" :font "DroidSansMono.ttf"))
  ()
  ((:text "(print (+ 10 20)) -> 30" :font "DroidSansMono.ttf")))

(slide 8 "Speedy Lisp Introduction"
  ("Evaluation Basics (quote):"
   (:text "(print (+ 10 20)) -> 30" :font "DroidSansMono.ttf"))
  ((:text "(print '(+ 10 20)) -> (+ 10 20)" :font "DroidSansMono.ttf"))
  ((:text "(first '(+ 10 20)) -> +" :font "DroidSansMono.ttf")
   (:text "(second '(+ 10 20)) -> 10" :font "DroidSansMono.ttf")
   (:text "(type-of (first '(+ 10 20))) -> SYMBOL" :font "DroidSansMono.ttf")))

(slide 9 "Speedy Lisp Introduction"
  ("Evaluation Basics (quasi-quote):")
  ((:text "(print '((+ 1 2) (+ 1 2))) -> ((+ 1 2) (+ 1 2))" :font "DroidSansMono.ttf")
   (:text "(print `((+ 1 2) ,(+ 1 2))) -> ((+ 1 2) 3)" :font "DroidSansMono.ttf")))

(slide 10 "And that's how it works!"
  ()
  ("..except for when it isn't :|")
  ("Evaluation Basics (special-forms):")
  ((:text "(if (the-reds-are-coming)" :font "DroidSansMono.ttf")
   (:text "    (fire-ze-missiles)" :font "DroidSansMono.ttf" :spacing 2)
   (:text "    (have-a-nap))" :font "DroidSansMono.ttf" :spacing 2))
  ((:text "" :size 25)
   (:text "(let ((foo 10))" :font "DroidSansMono.ttf")
   (:text "  (* foo 10)) -> 100" :font "DroidSansMono.ttf" :spacing 2))
  ((:text "" :size 20)
   (:text "(progn" :font "DroidSansMono.ttf")
   (:text "  (print \"a\"))" :font "DroidSansMono.ttf" :spacing 2)
   (:text "  (print \"b\"))" :font "DroidSansMono.ttf" :spacing 2)
   (:text "  (print \"c\")) -> \"c\" " :font "DroidSansMono.ttf" :spacing 2)))

(slide 11 "Macros"
  ("'The worst thing about macros is the name'"
   (:text " - some smartass -" :size 20))
  ("Macros are functions. What is interesting about them is not 'what' they do,"
   "but 'when'.")
  ("")
  ("Can be easier to think of them as hooks into the compiler"))

(slide 12 "4 kinds of macro"
  ("Reader Macro (Hook into the parser):"
   (:text "(length [1 2 3 4]) -> 4" :font "DroidSansMono.ttf")
   (:text "{:a 1 :b 2} -> #<HASHTABLE>" :font "DroidSansMono.ttf")))

(slide 13 "4 kinds of macro"
  ("Regular Macro (AST Transform):"
   (:text "(or x y)" :font "DroidSansMono.ttf")
   (:text "(let ((tmp0 x))" :font "DroidSansMono.ttf")
   ""
   (:text "  (if tmp0" :font "DroidSansMono.ttf" :spacing 2)
   (:text "      tmp0" :font "DroidSansMono.ttf" :spacing 2)
   (:text "      (let ((tmp1 y))" :font "DroidSansMono.ttf" :spacing 2)
   (:text "        (if tmp1" :font "DroidSansMono.ttf" :spacing 2)
   (:text "            tmp1" :font "DroidSansMono.ttf" :spacing 2)
   (:text "            nil))))" :font "DroidSansMono.ttf" :spacing 2)))

(slide 14 "4 kinds of macro"
  ("Compiler Macro (Optimize function call site):"
   (:text "(length [1 2 3 4]) -> 4" :font "DroidSansMono.ttf")
   (:text "{:a 1 :b 2} -> #<HASHTABLE>" :font "DroidSansMono.ttf")))

(slide 15 "4 kinds of macro"
  ("Symbol Macro:"
   "Cool, but not important for now"))


(slide 15 "Massive Thumb"
  ("- Does it intrigue you boy?"
   "- Agony"
   "- Black voodoo"
   "- Wet jigsaw puzzle"))

(slide 16 "Thankyou!")
(slide 17 "Questions?")
