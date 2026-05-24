(define-module (gcsynth gcsynth)
   #:use-module (srfi srfi-1)
   #:use-module (srfi srfi-9)
   #:use-module (ice-9 match)
   #:export (instrument oscil outs render-instrument))

(define-record-type <opcode>
  (opcode name inputs outputs)
  opcode?
  ;; string or symbol
  (name opcode-name)
  ;; alist of string or symbol to csound data or symbol
  (outputs opcode-outputs)
  ;; alist of string or symbol to csound data or symbol
  (inputs opcode-inputs))

(define-record-type <instrument>
  (instrument number name parameters expressions)
  instrument?
  ;; integer
  (number instrument-number)
  ;; string or symbol
  (name instrument-name)
  ;; alist of position index to name
  (parameters instrument-parameters)
  ;; list of (opcode inputs outputs) or string
  ;; where inputs and outputs are alist of parameter name to value
  ;; string can be any single line csound expression
  (expressions instrument-expressions))

(define-record-type <event>
  (event instrument timing parameters)
  event?
  ;; an instance of the instrument record
  (instrument event-instrument)
  ;; a list of start time and duration
  (timing event-timing)
  ;; alist of name (as defined in instrument) to value
  (parameters event-parameters))

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
                                     (format #f "~a init p~a"
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

(define (sequential-keys assoc-data)
  (match assoc-data
         (()
          #t)
         ((x . ())
          #t)
         (((x . a) (y . b) _ ...)
          (and (= y (+ x 1))
               (sequential-keys (cdr assoc-data))))))

(define (reverse-assoc alist)
  (map (lambda (binding)
         (match binding
                ((k . v) `(,v . ,k))))
       alist))

(define (resolve-keys alist resolver)
  (map (lambda (binding)
         (match binding
                ((k . (v)) `(,(assoc-ref resolver k) . ,v))))
       alist))

(define (untangle-parameters instrument event)
  ;; given an instrument and an event, gets the named parameters
  ;; from the event and maps them to the positions expected by
  ;; the instrument
  (letrec ( ; translate from (position . name) to (name . position)
            (name->position (reverse-assoc (instrument-parameters instrument)))
            ;; translate from (name . value) to (position . value)
            (position->value (resolve-keys (event-parameters event)
                                           name->position))
            (sorted-positions (sort position->value
                                    (lambda (a b)
                                      (< (car a) (car b))))))
      (match sorted-positions
        (()
         #t)
        (((index . v) _ ...)
         (if (not (= index 4))
           (raise-exception
             (format #f
                     "positional params cannot start at index ~a"
                     index)))))
    (if (not (sequential-keys sorted-positions))
      (raise-exception
        "keys for fields must be sequential"))
    ; (format #t "debug: name->position ~s~%" name->position)
    ; (format #t "debug: sorted-positions ~s~%" sorted-positions)
    ; (format #t "debug: position->value ~s~%" position->value)
    (match sorted-positions
           (((index . value) ...)
            value))))

(define (render-event event)
  (letrec ((ins (event-instrument event))
           (prefix (match (event-timing event)
                          ((start duration)
                           (format #f "i~a ~a ~a"
                                   (instrument-number (event-instrument event))
                                   start
                                   duration))))
           (params (untangle-parameters ins event)))
    (format #f "~a~{ ~a~}" prefix params)))
