(define-module (myapp3 pages)  
;;  #:use-module (gnu packages)
  #:use-module (myapp3 lib mylib)
  #:use-module (ice-9 pretty-print)
  #:export(main)
  )


(define (main args)
		(let* ((help-topic "plate")
		       (var1 "variable-one-from-controller")
		       (var2 ( get-rand-file-name "plate" "txt"));; <=== does not work; method not found	     
		       )
		  (pretty-print (string-append var1 "\n" var2 "\n" ))))
