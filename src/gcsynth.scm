(define-module (gcsynth gcsynth)
   #:use-module (srfi srfi-9))

(define-record-type <opcode>
  (opcode name inputs outputs)
  opcode?
  (name opcode-name)
  (outputs opcode-outputs)
  (inputs opcode-inputs))

(define-record-type <instrument>
  (instrument number name parameters expressions)
  instrument?
  (number instrument-number)
  (name instrument-name)
  (parameters instrument-parameters)
  (expressions instrument-expressions))

(define (str x)
  (format #f "~a" x))

(define (commas l)
  (or (string-join (map str l) ", ")
      ""))

(define (get-params spec bindings)
  (map (lambda (param)
         (or (assoc-ref bindings (car param))
             (cdr param)))
       spec))

(define (render-opcode opcode inputs outputs)
  (format #f "~a	~a	~a"
          (commas (get-params (opcode-outputs opcode) outputs))
          (opcode-name opcode)
          (commas (get-params (opcode-inputs opcode) inputs))))

(define oscil
 (opcode 'oscil
         '((amp . "0dbfs")
           (cps . 440)
           (fn . 1))
         '((sig . asig))))

(define outs
  (opcode 'outs
          '((left . asig)
            (right . asig))
          '()))

(define (render-instrument instrument)
  (let ((definition (format #f "	instr ~a, ~a"
                            (instrument-number instrument)
                            (instrument-name instrument)))
        (prelude (string-join (map (lambda (param)
                                     (format #f"~a = p~a"
                                             (cdr param)
                                             (car param)))
                                   (instrument-parameters instrument))
                              "\n"))
        (body (string-join (map (lambda (expression)
                                  (cond ((and (list? expression)
                                              (opcode? (car expression)))
                                         (apply render-opcode expression))
                                        (#t
                                         expression)))
                                (instrument-expressions instrument))
                           "\n")))
    (string-join (list definition
                       prelude
                       body
                       "	endin")
                 "\n")))

(format #t
        "instrument definition:~%~a~%"
        (render-instrument
          (instrument 1
                      "simple_osc"
                      '((3 . iamp)
                        (4 . icps))
                      `((,oscil
                         ((amp . iamp) (cps . icps))
                         ((sig . oscil_sig)))
                        (,outs
                          ((left . oscil_sig) (right . oscil_sig))
                          ())))))
