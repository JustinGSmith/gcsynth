(define-module (gcsynth event-test)
   #:use-module ((srfi srfi-64) #:prefix test:)
   #:use-module ((gcsynth event) #:prefix event:)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-assert (gcsynth:event? event:test-event))

  (exit (test:test-runner-fail-count (test:test-runner-get))))
