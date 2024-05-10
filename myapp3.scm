(define-module (myapp3)
  #:use-module (myapp3 lib mylib)
  #:use-module (ice-9 pretty-print)
  #:use-module (dbi dbi)

  #:export(main)
  )


(define (main args)
		(let* ((help-topic "plate")
		       (var1 "variable-one-from-controller")
		       (var2 ( get-rand-file-name "plate" "txt"))
		       ;;(var2 ((@ (myapp lib mylib) get-rand-file-name) "plate" "txt"))		       
		       (sql (string-append "INSERT INTO ref(pmid) VALUES ('777584');"))	
		       (ciccio (dbi-open "mysql" "plapan_conman_ad:welcome:plapan_conman:tcp:192.254.187.215:3306"))
		       
		       (dummy (dbi-query ciccio sql))
   	;;(dummy (dbi-close ciccio))
		     
		       )
		  (pretty-print "finished pages.scm")))
