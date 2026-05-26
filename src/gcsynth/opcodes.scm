(define-module (gcsynth opcodes)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
   #:export (get-params
             oscil
             outs))

(define (get-params spec bindings)
  (map (lambda (param)
         (or (assoc-ref bindings (car param))
             (cdr param)))
       spec))

(define oscil
  (gcsynth:opcode 'oscil
                  '((amp . "0dbfs")
                    (cps . 440)
                    (fn . 1))
                  '((sig . asig))))

(define outs
  (gcsynth:opcode 'outs
                  '((left . asig)
                    (right . asig))
                  '()))
