(define-module (noisesmith test-test)
   #:use-module ((srfi srfi-64) #:prefix test:)
   #:use-module ((noisesmith test) #:prefix test-util:)
   #:use-module ((srfi srfi-8) #:prefix bind))

(test:test-with-runner
  ((test:test-runner-factory))

  (test:test-begin "noisesmith test space-separated test")

  (test:test-assert
    (equal? (test-util:space-separated "a" "b" "c" "d")
            "a[[:space:]]b[[:space::]]c[[:space:]]d"))

  (test:test-assert
    (equal? (test-util:space-separated)
            ""))

  (test:test-end "noisesmith test space-separated test")

  (test:test-begin "noisesmith test regex-path test")

  (define match-seq
    '((a . "a")
      (b . "b")
      (c . "c")
      (d . "d")))

  (bind:receive (success fail-case)
        (test-util:regex-path match-seq "a xyz b xyzc d")

        (test:test-assert
          (equal? success #t))
        (test:test-assert
          (equal? fail-case #f)))

  (bind:receive (success fail-case)
                   (test-util:regex-path match-seq "")

                   (test:test-assert
                     (equal? success #f))
                   (test:test-assert
                     (equal? fail-case 'a)))

  (test:test-end "noisesmith util regex-path test")

  (exit (test:test-runner-fail-count (test:test-runner-get))))
