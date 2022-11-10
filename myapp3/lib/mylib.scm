(define-module (myapp lib mylib)
  #:use-module (srfi srfi-1)
  #:export (get-rand-file-name
	    ))

(define (get-rand-file-name pre suff)
  (string-append pre "-" (number->string (random 10000000000000000000000)) "." suff))

      
