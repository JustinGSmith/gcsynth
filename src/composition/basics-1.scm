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
                          ((name . ileft) (default . 1))
                          ((name . iright) (default . 1))
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
                          ((left . "aoscil_sig * ileft * gigain")
                           (right . "aoscil_sig * iright * gigain"))
                          ()))))

(define f-1
  (ftables:sine-sum 1 (ftables:powtwo 16)))

(define overture
  (list
    ;; drone
    (gcsynth:event drunk-osc '(0 100)
                   '((iamp . 0.8)
                     (icps . 66.827)
                     (idivergence . 10.97)
                     (imutation_speed . 10.113)))
    ;; wailing right
    (gcsynth:event drunk-osc '(10 30)
                   '((iamp . 0.8)
                     (ileft . 0.3)
                     (iright . 1)
                     (icps . 1027.113)
                     (idivergence . 98.213)
                     (imutation_speed . 63.36)))
    ;; wailing left
    (gcsynth:event drunk-osc '(12 28)
                   '((iamp . 0.8)
                     (ileft . 1)
                     (iright . 0.3)
                     (icps . 1027.113)
                     (idivergence . 98.213)
                     (imutation_speed . 63.36)))
    ;; whiner
    (gcsynth:event drunk-osc '(20 10)
                   '((iamp . 0.8)
                     (icps . 8090.383)
                     (idivergence . 100.01)
                     (imutation_speed . 20.222)))

    ;; wailing left
    (gcsynth:event drunk-osc '(80 30)
                   '((iamp . 0.8)
                     (iright . 0.3)
                     (ileft . 1)
                     (icps . 1027.113)
                     (idivergence . 98.213)
                     (imutation_speed . 63.36)))
    ;; wailing right
    (gcsynth:event drunk-osc '(82 28)
                   '((iamp . 0.8)
                     (iright . 1)
                     (ileft . 0.3)
                     (icps . 1027.113)
                     (idivergence . 98.213)
                     (imutation_speed . 63.36)))
    ;; whiner
    (gcsynth:event drunk-osc '(92 10)
                   '((iamp . 0.9)
                     (icps . 8090.383)
                     (idivergence . 100.01)
                     (imutation_speed . 20.222)))
    ;; drone
    (gcsynth:event drunk-osc '(110 100)
                   '((iamp . 0.8)
                     (icps . 66.827)
                     (idivergence . 10.97)
                     (imutation_speed . 10.113)))))

(define csd-text
  (render:csd
    '("-W"
      "-o basics-1.wav")
    (list "nchnls = 2"
          "0dbfs = 1"
          "ksmps = 64"
          "gigain = 0.3"
          drunk-osc)
    (cons f-1
          overture)))

(format #t csd-text)
