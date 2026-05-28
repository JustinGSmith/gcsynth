(define-module (gcsynth opcodes)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
   #:export (get-params
             mirror
             oscil
             outs
             rand
             randh))

(define (get-params spec bindings)
  (filter identity ; filter unprovided optional params
          (map (lambda (param)
                 (or (assoc-ref bindings (car param))
                     (cdr param)))
               spec)))

(define mirror
  (gcsynth:opcode 'mirror
                  '((sig . #f)
                    (low . #f)
                    (high . #f))
                  '((res . #f))))

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

(define rand
  (gcsynth:opcode 'rand
                  '((amp . 1)
                    (seed . 0.5)
                    (sel . 0)
                    (offset . 0))
                  '((res . #f))))

(define randh
  (gcsynth:opcode 'randh
                  '((amp . 1)
                    (cps . 20)
                    (seed . 0.5)
                    (size . 0)
                    (offset . 0))
                  '((res . #f))))
