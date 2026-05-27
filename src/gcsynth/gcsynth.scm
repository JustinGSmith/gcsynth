(define-module (gcsynth gcsynth)
   #:use-module ((srfi srfi-9) #:prefix rec:)
   #:use-module ((noisesmith util) #:prefix util:)
   #:use-module (ice-9 match)
   #:export (opcode opcode? opcode-name opcode-outputs opcode-inputs

             parameters parameters? parameter-positions parameter-names
             parameter-defaults

             instrument instrument? instrument-number instrument-name
             instrument-parameters instrument-expressions

             event event? event-instrument event-timing event-parameters

             ftable ftable? ftable-table-id ftable-time ftable-size
             ftable-function-id ftable-params))

(rec:define-record-type <opcode>
  (opcode name inputs outputs)
  opcode?
  ;; string or symbol
  (name opcode-name)
  ;; alist of string or symbol to csound data or symbol
  (outputs opcode-outputs)
  ;; alist of string or symbol to csound data or symbol
  (inputs opcode-inputs))

(rec:define-record-type <parameters>
  (parameters% positions names defaults)
  parameters?
  ;; alist of name to index
  (positions parameter-positions)
  ;; alist of index to name
  (names parameter-names)
  ;; alist of name to default value
  (defaults parameter-defaults))


(define (parameters specs)
  (let* ((positions (util:map-indexed 4
                                      (lambda (spec)
                                        (assoc-ref spec 'name))
                                      specs))
         (names (util:reverse-assoc positions))
         (defaults (map (lambda (spec)
                          (cons (assoc-ref spec 'name)
                                (assoc-ref spec 'default)))
                        specs)))
    (parameters% names positions defaults)))

(rec:define-record-type <instrument>
  (instrument number name parameters expressions)
  instrument?
  ;; integer
  (number instrument-number)
  ;; string or symbol
  (name instrument-name)
  ;; an instance of the parameters structure
  (parameters instrument-parameters)
  ;; list of (opcode inputs outputs) or string
  ;; where inputs and outputs are alist of parameter name to value
  ;; string can be any single line csound expression
  (expressions instrument-expressions))

(rec:define-record-type <event>
  (event instrument timing parameters)
  event?
  ;; an instance of the instrument record
  (instrument event-instrument)
  ;; a list of start time and duration
  (timing event-timing)
  ;; alist of name (as defined in instrument) to value
  (parameters event-parameters))

(rec:define-record-type <ftable>
  (ftable table-id time size function-id params)
  ftable?
  (table-id ftable-table-id)
  (time ftable-time)
  (size ftable-size)
  (function-id ftable-function-id)
  (params ftable-params))
