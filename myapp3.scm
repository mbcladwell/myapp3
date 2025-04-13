(define-module (labsolns myapp3)
;;  #:use-module (labsolns myapp3 lib mylib)
  #:use-module (ice-9 pretty-print)
  #:use-module (dbi dbi)

  #:export(main)
  )


;;guile -e '(myapp3)' -L /home/mbc/projects/myapp3 -s ./myapp3.scm boogie

(define (main args)
		(let* (
		       (txt (cadr args) )
		       (_ (pretty-print txt))
		       (sql (format #f "INSERT INTO ref(pmid, journal) VALUES ('~a', 'this is a test');" txt))
		       (_ (pretty-print sql))
		       
		       (ciccio (dbi-open "mysql" "plapan_conman_ad:welcome:plapan_conman:tcp:192.254.187.215:3306"))
		       
		       (dummy (dbi-query ciccio sql))
   	;;(dummy (dbi-close ciccio))
		     
		       )
		  (pretty-print "finished pages.scm")))
