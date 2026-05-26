(define-module (noisesmith test)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 match)
  ;; #:use-module (srfi srfi-64)
  #:export (space-separated regex-path))

(define (space-separated . args)
  (string-join args "[[:space:]]"))

(define (regex-path path str)
  (match path
         (() (values #t #f))
         (((key . match-str) more ...)
          (match (string-match match-str str)
                 (#f
                  (values #f key))
                 (#(s (start . end))
                  (regex-path more (substring str end)))))))
