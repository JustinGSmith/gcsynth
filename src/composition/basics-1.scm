(define-module (composition basics-1)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
   #:use-module ((gcsynth render) #:prefix render:)
   #:use-module ((gcsynth opcodes) #:prefix opcodes:)
   #:use-module ((gcsynth ftables) #:prefix ftables:))

(define drunk-osc
  (gcsynth:instrument 1
                      "drunk_osc"
                      (gcsynth:parameters
                        '(((name . iamp) (default . 1))
                          ((name . icps) (default . 440))
                          ((name . idivergence) (default. 3))
                          ((name . imutation_speed) (default . 20))))
                      `((,opcodes:rand
                          ((amp . imutation_speed))
                          ((res . krand_speed)))
                        "krand_cps = krand_speed + imutation_speed * 2"
                        (,opcodes:randh
                          ((amp . idivergence) (cps . krand_cps))
                          ((res . kwalk_step)))
                        "kcps init icps"
                        (,opcodes:mirror
                          ((sig . "kcps + kwalk_step")
                           (low . "(icps / 2)") (high . "icps * 2"))
                          ((res . kcps)))
                        ; "  printk2 kcps, 10, 1"
                        (,opcodes:oscil
                          ((amp . iamp) (cps . kcps))
                          ((sig . aoscil_sig)))
                        (,opcodes:outs
                          ((left . aoscil_sig) (right . aoscil_sig))
                          ()))))

(define f-1
  (ftables:sine-sum 1 (ftables:powtwo 16)))

(define overture
  (gcsynth:event drunk-osc '(0 100)
                 '((iamp . 0.8)
                   (icps . 666)
                   (idivergence . 300)
                   (imutation_speed . 100))))

(define csd-text
  (render:csd
    '("-W"
      "-o basics-1.wav")
    (list "0dbfs = 1"
          "ksmps = 64"
          drunk-osc)
    (list f-1
          overture)))

(format #t csd-text)
