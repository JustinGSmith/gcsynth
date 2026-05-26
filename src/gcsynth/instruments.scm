(define-module (gcsynth instruments)
  #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
  #:use-module ((gcsynth opcodes) #:prefix opcodes:)
  #:export (simple-osc))


(define simple-osc
  (gcsynth:instrument 1
                      "simple_osc"
                      (gcsynth:parameters '(((name . iamp) (default . 1))
                                            ((name . icps) (default . 440))))
                      `((,opcodes:oscil
                          ((amp . iamp) (cps . icps))
                          ((sig . oscil_sig)))
                        (,opcodes:outs
                          ((left . oscil_sig) (right . oscil_sig))
                          ()))))
