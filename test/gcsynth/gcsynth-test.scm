(define-module (gcsynth gcsynth-test)
   #:use-module (srfi srfi-64)
   #:use-module (ice-9 regex)
   #:use-module (gcsynth gcsynth))

(test-begin "test-test")
(test-assert #t)
(test-end "test-test")

(test-begin "instrument-test")
(define simple-osc
  (instrument 1
              "simple_osc"
              '((4 . iamp)
                (5 . icps))
              `((,oscil
                  ((amp . iamp) (cps . icps))
                  ((sig . oscil_sig)))
                (,outs
                  ((left . oscil_sig) (right . oscil_sig))
                  ()))))

;; (test-assert
;; (format #t
;;         "instrument definition:~%~a~%"
;;         (render-instrument simple-osc))

(define (space-separated . args)
  (string-join args "[[:space:]]"))

(define instrument-text
  (render-instrument simple-osc))

(define instrument-regex
  (space-separated "" "*instr" "+1," "+simple_osc\n"
                   "*iamp" "+init" "+p4\n"
                   "*icps" "+init" "+p5\n"
                   "*oscil_sig" "+oscil" "+iamp," "*icps," "*1\n"
                   "*outs" "+oscil_sig," "*oscil_sig\n"
                   "*endin"))

;; (format #t "actual~%~s~%expected~%~s"
;;        instrument-text
;;        instrument-regex)

(test-assert
  (string-match
    instrument-regex
    instrument-text))

(test-end "instrument-test")

#!
(format #t
        "note definition:~%~a~%"
        (render-event
          (event simple-osc '(0 10)
                 '((iamp 0.7)
                   (icps 8000)))))
!#
