(define-module (gcsynth render)
  #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
  #:use-module ((gcsynth opcodes) #:prefix opcode:)
  #:use-module ((noisesmith util) #:prefix util:)
  #:use-module (ice-9 match)
  #:export (opcode instrument event csd))


(define (opcode opcode inputs outputs)
  (format #f "~a	~a	~a"
          (util:commas (opcode:get-params
                         (gcsynth:opcode-outputs opcode)
                         outputs))
          (gcsynth:opcode-name opcode)
          (util:commas (opcode:get-params
                         (gcsynth:opcode-inputs opcode)
                         inputs))))

(define (instrument ins)
  (let ((definition (format #f "	instr ~a, ~a"
                            (gcsynth:instrument-number ins)
                            (gcsynth:instrument-name ins)))
        (prelude (string-join (map (match-lambda
                                     ((name . position)
                                      (format #f "~a init p~a" name position)))
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
  (let* ((ins (gcsynth:event-instrument evt))
         (prefix (match (gcsynth:event-timing evt)
                        ((start duration)
                         (format #f "i~a ~a ~a"
                                 (gcsynth:instrument-number ins)
                                 start
                                 duration))))
         (base-parameters (gcsynth:instrument-parameters ins))
         (specified (gcsynth:event-parameters evt))
         (defaults (gcsynth:parameter-defaults base-parameters))
         (params (map (match-lambda
                        ((param-name . default)
                         (or (assoc-ref specified param-name)
                             default)))
                      defaults)))
    (format #f "~a~{ ~a~}" prefix params)))

(define (tag name opts contents)
  (format #f "<~a>~%~a~%</~a>"
          (string-join (cons name opts) " ")
          (string-join contents "\n\n")
          name))

;; TODO - ftable rendering

;; TODO - get and uniquify instruments from events
(define (csd options orchestra score)
  (tag "CsoundSynthesizer"
       '("")
       (list
         (tag "CsOptions"
              '()
              options)
         (tag "CsInstruments"
              '()
              orchestra)
         (tag "CsScore"
              '()
              (append score
                      '("e"))))))
