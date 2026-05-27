(define-module (gcsynth render-test)
  #:use-module ((gcsynth render) #:prefix render:)
  #:use-module ((srfi srfi-64) #:prefix test:)
  #:use-module ((noisesmith test) #:prefix test-util:)
  #:use-module ((ice-9 regex) #:prefix re:)
  #:use-module ((srfi srfi-8) #:prefix bind:)
  #:use-module ((gcsynth opcodes) #:prefix opcodes:)
  #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
  #:use-module ((gcsynth ftables) #:prefix ftables:))

(define simple-osc
  (gcsynth:instrument 1
                      "simple_osc"
                      (gcsynth:parameters '(((name . iamp) (default . 1))
                                            ((name . icps) (default . 440))))
                      `((,opcodes:oscil
                          ((amp . iamp) (cps . icps))
                          ((sig . aoscil_sig)))
                        (,opcodes:outs
                          ((left . aoscil_sig) (right . aoscil_sig))
                          ()))))

(define test-ftable
  (gcsynth:ftable  1 0 16384 10 '(1)))

(define test-event
  (gcsynth:event simple-osc
         '(0 10)
         '((iamp . 0.7)
           (icps . 8000))))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-begin "gcsynth render instrument test")


  (define instrument-text
    (render:instrument simple-osc))

  (define instrument-regex
    (test-util:space-separated "" "*instr" "+1," "+simple_osc\n"
                               "*iamp" "+init" "+p4\n"
                               "*icps" "+init" "+p5\n"
                               "*aoscil_sig" "+oscil" "+iamp," "*icps," "*1\n"
                               "*outs" "+aoscil_sig," "*aoscil_sig\n"
                               "*endin"))

  (test:test-assert
    (re:string-match
      instrument-regex
      instrument-text))

  (test:test-end "gcsynth render instrument test")

  (test:test-begin "gcsynth render event test")

  (define event-text
    (render:event test-event))

  (bind:receive (success last-match)
                (test-util:regex-path
                  '((instr . "i") (instr-id . "1")
                                  (start-time . "0") (duration . "10")
                                  (amplitude . "0.7") (cps . "8000"))
                  event-text)
                (test:test-assert success)
                (test:test-assert (not last-match)))

  (test:test-end "gcsynth render event test")

  (test:test-begin "gcsynth render ftable test")

  (define ft
    (ftables:sine-sum-phase 1 32768
                            #:partials '((#:pn 1) (#:pn 1.3) (#:pn 1.8))))

  (define ft-string (render:ftable ft))

  (test:test-assert
    (equal? "f1 0 32768 9 1 1 0 1.3 1 0 1.8 1 0"
            ft-string))

  (test:test-end "gcsynth render ftable test")

  (test:test-begin "gcsynth render csd test")

  (define csd-text-strings
    (render:csd
      '()
      (list "0dbfs=1"
            (render:instrument simple-osc))
      (list "f1 0 16384 10 1"
            (render:event test-event))))

  (define csd-text
    (render:csd
      '()
      (list "0dbfs=1"
            simple-osc)
      (list test-ftable
            test-event)))

  ;; csd can take data structures or strings interchangibly as needed
  (test:test-assert
    (equal? csd-text-strings csd-text))

  (call-with-output-file
    "test.csd"
    (lambda (csd-file)
      (format csd-file csd-text)))

  (test:test-assert
    (=
      (system "csound test.csd")
      0))

  (test:test-end "gcsynth render csd test")

  (exit (test:test-runner-fail-count (test:test-runner-get))))
