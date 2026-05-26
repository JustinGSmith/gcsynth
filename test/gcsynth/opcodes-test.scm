(define-module (gcsynth opcodes-test)
   #:use-module ((srfi srfi-64) #:prefix test:)
   #:use-module ((gcsynth opcodes) #:prefix opcodes:)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-begin "gcsynth opcodes oscil test")

  (test:test-assert
    (gcsynth:opcode? opcodes:oscil))

  (test:test-end "gcsynth opcodes oscil test")

  (test:test-begin "gcsynth opcodes get-params test")

  (test:test-assert
    (equal? (opcodes:get-params '((a . default-a)
                                  (b . default-b))
                                '((a . specified-a)))
            '(specified-a default-b)))

  (test:test-end "gcsynth opcodes get-params test")
  (exit (test:test-runner-fail-count (test:test-runner-get))))
