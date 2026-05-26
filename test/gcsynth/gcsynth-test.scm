(define-module (gcsynth gcsynth-test)
   #:use-module ((srfi srfi-64) #:prefix test:)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-begin "gcsynth gcsynth parameters test")

  (define parameters
    (gcsynth:parameters '(((name . iamp) (default . 1))
                          ((name . icps) (default . 440)))))

  (test:test-assert
    (gcsynth:parameters? parameters))

  (test:test-assert
    (equal? (gcsynth:parameter-positions parameters)
            '((iamp . 4) (icps . 5))))

  (test:test-assert
    (equal? (gcsynth:parameter-names parameters)
            '((4 . iamp) (5 . icps))))

  (test:test-assert
    (equal? (gcsynth:parameter-defaults parameters)
            '((iamp . 1) (icps . 440))))

  (test:test-end "gcsynth gcsynth parameters test")

  (exit (test:test-runner-fail-count (test:test-runner-get))))
