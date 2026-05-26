(define-module (noisesmith util-test)
   #:use-module ((srfi srfi-64) #:prefix test:)
   #:use-module ((noisesmith util) #:prefix util:))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-begin "noisesmith util map-indexed test")

  (test:test-assert
    (equal? (util:map-indexed 100 identity '(a b c d))
            '((100 . a) (101 . b) (102 . c) (103 . d))))

  (test:test-end "noisesmith util map-indexed test")

  (test:test-begin "noisesmith util reverse-assoc test")

  (test:test-assert
    (equal? (util:reverse-assoc '((a . 0) (b . 1)))
            '((0 . a) (1 . b))))

  (test:test-end "noisesmith util reverse-assoc test")

  (exit (test:test-runner-fail-count (test:test-runner-get))))
