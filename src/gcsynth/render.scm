(define-module (gcsynth render)
  #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
  #:use-module ((gcsynth opcodes) #:prefix opcode:)
  #:use-module ((gcsynth instruments) #:prefix orch:)
  #:export (opcode instrument event csd))


;; TODO refactor this to be in the opcode module


(define (opcode opcode inputs outputs)
  (format #f "~a	~a	~a"
          (util:commas (opcode:get-params
                         (gcsynth:opcode-outputs opcode)
                         outputs))
          (gcsynth:opcode-name opcode)
          (util:commas (get-params (gcsynth:opcode-inputs opcode)
                                   inputs))))

(define (instrument ins)
  (let ((definition (format #f "	instr ~a, ~a"
                            (gcsynth:instrument-number ins)
                            (igcsynth:nstrument-name ins)))
        (prelude (string-join (map (lambda (param)
                                     (format #f "~a init p~a"
                                             (cdr param)
                                             (car param)))
                                   (gcsynth:parameter-positions
                                     (gcsynth:instrument-parameters ins)))
                              "\n"))
        (body (string-join (map (lambda (expression)
                                  (cond ((and (list? expression)
                                              (gcsynth:opcode? (car expression)))
                                         (apply opcode expression))
                                        (#t
                                         expression)))
                                (gcsynth:instrument-expressions ins))
                           "\n")))
    (string-join (list definition
                       prelude
                       body
                       "	endin")
                 "\n")))

(define (event evt)
  (letrec ((ins (gcsynth:event-instrument evt))
           (prefix (match (gcsynth:event-timing evt)
                          ((start duration)
                           (format #f "i~a ~a ~a"
                                   (gcsynth:instrument-number ins)
                                   start
                                   duration))))
           (base-parameters (gcsynth:instrument-parameters ins))
           (specified (gcsynth:event-parameters evt))
           (params (map (match-lambda
                          ((param-name . default)
                           (or (assoc-ref specified param-name)
                               default)))
                        (gcsynth:parameter-defaults base-parameters))))
    (format #f "~a~{ ~a~}" prefix params)))

(define (tag name opts contents)
  (format #f "<~a ~a>~%~a~%</~a>"
          name
          opts
          contents
          name))

(define (csd options orchestra score)
  (tag "CsoundSynthesizer"
       ""
       (tag "CsOptions"
            ""
            options)
       (tag "CsInstruments"
            ""
            orchestra)
       (tag "CsScore"
            ""
            score)))
