(define-module (myapp3 pages)
;  #:use-module (myapp lib mylib)
  #:use-module (ice-9 pretty-print)
  #:export(main)
  )


(define (main args)
		(let* ((help-topic "plate")
		       (var1 "variable-one-from-controller")
	;;	       (var2 ( get-rand-file-name "plate" "txt"));; <=== does not work; method not found
		       ;;(var2 ((@ (myapp lib mylib) get-rand-file-name) "plate" "txt"))		       
		     
		       )
		  (pretty-print (string-append var1 "\n"  ))))
