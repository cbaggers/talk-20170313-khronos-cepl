(in-package :talk)

(slide 0 "Lisping on the GPU")

(slide 1 "Obligatory 'me' slide"
  ("- github.com/cbaggers"
   "- techsnuffle.com"
   "- Lisping for ~5 years"
   "- Programmer at Fuse (We are hiring!)"
   (:image "fuse0.png" :pos (0 -0.3))))

(slide 2 "WAT"
  ("- Where did it come from?"
   "- What is it now?"
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
  ("- Eager"
   "- Dynamically Typed"
   "- Incrementally Compiled")
  ("- Compiled or Interpreted")
  ("- Declarations")
  ("- MACROS   :-)"))  ;; standardization - for industry

(slide 5 "Speedy Lisp Introduction")

(slide 6 "Speedy Lisp Introduction"
  ("Evaluation Basics:")
  ((:text "foo" :font "DroidSansMono.ttf"))
  ((:text "(bar 1 2)" :font "DroidSansMono.ttf"))
  ((:text "(bar 1 foo (+ 4 5))" :font "DroidSansMono.ttf"))
  ()
  ((:text "(print (+ 10 20)) -> 30" :font "DroidSansMono.ttf")))

(slide 7 "Speedy Lisp Introduction"
  ("Evaluation Basics (quote):")
  ((:text "(print (+ 10 20)) -> 30" :font "DroidSansMono.ttf"))
  ((:text "(print '(+ 10 20)) -> (+ 10 20)" :font "DroidSansMono.ttf"))
  ((:text "(first '(+ 10 20)) -> +" :font "DroidSansMono.ttf")
   (:text "(second '(+ 10 20)) -> 10" :font "DroidSansMono.ttf")
   (:text "(type-of (first '(+ 10 20))) -> SYMBOL" :font "DroidSansMono.ttf")))

(slide 8 "Speedy Lisp Introduction"
  ("Evaluation Basics (special-forms):"
   (:text "(let ((foo 10))" :font "DroidSansMono.ttf")
   (:text "  (* foo 10)) -> 100" :font "DroidSansMono.ttf" :spacing 1))
  (""
   (:text "(progn" :font "DroidSansMono.ttf")
   (:text "  (print \"a\"))" :font "DroidSansMono.ttf" :spacing 1)
   (:text "  (print \"b\"))" :font "DroidSansMono.ttf" :spacing 1)
   (:text "  (print \"c\")) -> \"c\" " :font "DroidSansMono.ttf" :spacing 1)))

(slide 9 "Macros"
  ("'The worst thing about macros is the name'"
   (:text " - some smartass -" :size 40)
   "Macros are functions. What is interesting about them is"
   "not 'what' they do, but 'when'.")
  (""
   "4 kinds of macro"
   "- reader"
   "- regular"
   "- compiler"
   "- symbol"))

(slide 10 "Massive Thumb"
  ("- Does it intrigue you boy?"
   "- Agony"
   "- Black voodoo"
   "- Wet jigsaw puzzle"))

(slide 11 "Thankyou!")
(slide 12 "Questions?")
