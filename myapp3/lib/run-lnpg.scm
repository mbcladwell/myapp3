(define-module (limsn lib run-lnpg))
 
(define (main args)
  ;;args:  ip port username password dbname method destination
  ;;first item of args list is the file name so skip
  ;;method: 'init' or 'refresh'
  ;;destination: local aws esql  
  (init-db args))
	 

;; change to manifest
;; https://lists.gnu.org/archive/html/help-guix/2021-07/msg00037.html
