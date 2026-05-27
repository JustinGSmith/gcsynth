(define-module (gcsynth ftables)
   #:use-module ((gcsynth gcsynth) #:prefix gcsynth:)
   #:use-module ((ice-9 optargs) #:prefix opt:)
   #:use-module ((srfi srfi-1) #:prefix list:)
   #:export (name->table-id
             polynomial
             sine-sum-phase))

(import (rnrs base))

(define name->table-id
  '((file . 1)
    (literal . 2)
    (polynomial . 3)
    (normalizing . 4)
    (exponential . 5)
    (cubic-polynomial . 6)
    (segments . 7)
    (cublic-spline . 8)
    (sine-sum-phase . 9)
    (sine-sum . 10)))

(define (polynomial table-id size . key-args)
  (opt:let-keywords key-args #f
   ((time 0)
    (left #f)
    (right #f)
    (coeffs '()))
   ;; though they are keyword args, left right and coeffs have no
   ;; reasonable defaults(?)
   (when (not (and left right))
     (assertion-violation
       '(gcsynth ftable polynomial)
       "#:left and #:right keys are mandatory"))
   (when (not (> (length coeffs) 1))
     (assertion-violation
       '(gcsynth ftable polynomial)
       "#:coeffs key is mandatory"))
   (gcsynth:ftable table-id time size (assoc-ref name->table-id 'polynomial)
                   (cons left (cons right coeffs)))))

(define (unfold-partial key-args)
  (opt:let-keywords key-args #f
     ((pn #f)
      (str 1)
      (phs 0))
     (when (not pn)
       (assertion-violation
         '(gcsynth ftable unfold-partial)
         "#:pn (partial number) key is mandatory"))
     (list pn str phs)))

(define (sine-sum-phase table-id size . key-args)
  (opt:let-keywords key-args #f
   ((time 0)
    (partials '()))
   ;; though they are keyword args, left right and coeffs have no
   ;; reasonable defaults(?)
   (when (not (> (length partials) 1))
     (assertion-violation
       '(gcsynth ftable polynomial)
       "#:partials key is mandatory"))
   (gcsynth:ftable table-id time size (assoc-ref name->table-id 'sine-sum-phase)
                   (list:append-map unfold-partial partials))))
