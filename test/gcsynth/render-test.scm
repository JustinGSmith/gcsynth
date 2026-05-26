(define-module (gcsynth render-test)
  #:use-module ((gcsynth render) #:prefix render:)
  #:use-module ((srfi srfi-64) #:prefix test:)
  #:use-module ((ice-9 regex) #:prefix re:)
  #:use-module ((gcsynth opcodes) #:prefix opcodes:)
  #:use-module ((gcsynth instruments) #:prefix orch:)
  #:use-module ((gcsynth event) #:prefix event:)
  #:use-module ((gcsynth gcsynth) #:prefix gcsynth:))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-begin "gcsynth render instrument test")


  (define instrument-text
    (render:instrument orch:simple-osc))

  (define instrument-regex
    (ns-test:space-separated "" "*instr" "+1," "+simple_osc\n"
                             "*iamp" "+init" "+p4\n"
                             "*icps" "+init" "+p5\n"
                             "*oscil_sig" "+oscil" "+iamp," "*icps," "*1\n"
                             "*outs" "+oscil_sig," "*oscil_sig\n"
                             "*endin"))

  (test-assert
    (re:string-match
      instrument-regex
      instrument-text))

  (test-end "gcsynth render instrumen test")

  (exit (test:test-runner-fail-count (test:test-runner-get))))

;;
;; 
;; (test-begin "event-test")
;;
;; (define event-text
;;   (render:event orch:test-event))
;;
;; (format #t "event text:~%~s~%" event-text)
;;
;; #!
;; (bind:receive (success last-match)
;;          (regex-path
;;            '((instr . "i") (instr-id . "1")
;;              (start-time . "0") (duration . "10")
;;              (amplitude . "0.7") (cps . "8000"))
;;            event-text)
;;    (test-assert success)
;;    (test-assert (not last-match)))
;; !#
;;
;; (test-end "event-test")
