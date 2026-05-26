(define-module (gcsynth instruments-test)
   #:use-module ((srfi srfi-64) #:prefix test:)
   #:use-module ((gcsynth instruments) #:prefix instruments:)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-begin "gcsynth instruments simple-osc test")

  (test:test-assert
    (gcsynth:instrument? instruments:simple-osc))

  (test:test-end "gcsynth instruments simple-osc test")

  (exit (test:test-runner-fail-count (test:test-runner-get))))
