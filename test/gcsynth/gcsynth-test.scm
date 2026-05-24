(define-module (gcsynth gcsynth-test)
   #:use-module (srfi srfi-64)
   #:use-module (srfi srfi-8)
   #:use-module (ice-9 regex)
   #:use-module (noisesmith test)
   #:use-module (gcsynth gcsynth))


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

(define instrument-text
  (render-instrument simple-osc))

(define instrument-regex
  (space-separated "" "*instr" "+1," "+simple_osc\n"
                   "*iamp" "+init" "+p4\n"
                   "*icps" "+init" "+p5\n"
                   "*oscil_sig" "+oscil" "+iamp," "*icps," "*1\n"
                   "*outs" "+oscil_sig," "*oscil_sig\n"
                   "*endin"))

(test-assert
  (string-match
    instrument-regex
    instrument-text))

(test-end "instrument-test")


(test-begin "event-test")

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

(define event-text
  (render-event
    (event simple-osc '(0 10)
           '((iamp 0.7)
             (icps 8000)))))

(format #t "event text:~%~s~%" event-text)

(receive (success last-match)
         (regex-path
           '((instr . "i") (instr-id . "1")
             (start-time . "0") (duration . "10")
             (amplitude . "0.7") (cps . "8000"))
           event-text)
   (test-assert success)
   (test-assert (not last-match)))

(test-end "event-test")
