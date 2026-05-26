(define-module (gcsynth event)
  #:use-module ((gcsynth opcodes) #:prefix opcode:)
  #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
  #:export (test-event))

(define test-event
  (gcsynth:event opcode:oscil
         '(0 10)
         '((iamp 0.7)
           (icps 8000))))
