(define-module (noisesmith test)
  #:use-module ((ice-9 regex) #:prefix re:)
  #:use-module (ice-9 match)
  #:export (space-separated regex-path))

(define (space-separated . args)
  (string-join args "[[:space:]]"))

(define (regex-path path str)
  (match path
         (() (values #t #f))
         (((key . match-str) more ...)
          (match (re:string-match match-str str)
                 (#f
                  (values #f key))
                 (#(s (start . end))
                  (regex-path more (substring str end)))))))
