(define-module (noisesmith util)
   #:use-module (ice-9 match)
   #:export (map-indexed reverse-assoc commas))

(define (map-indexed i f l)
  (match l
         (() '())
         ((h . t)
          (cons (cons i (f h))
                (map-indexed (+ 1 i) f t)))))

(define (reverse-assoc alist)
  (map (match-lambda
         ((k . v) (cons v  k)))
       alist))

(define (str x)
  (format #f "~a" x))

(define (commas l)
  (or (string-join (map str l) ", ")
      ""))

