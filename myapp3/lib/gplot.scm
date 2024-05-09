(define-module (limsn lib gplot)
 ;; #:use-module (guix packages)
  #:use-module (artanis artanis) 
  #:use-module (artanis utils)  
  #:use-module (artanis config)  
  #:use-module (artanis irregex)
  #:use-module (ice-9 local-eval)
  #:use-module (ice-9 regex) ;;list-matches
  #:use-module (srfi srfi-1)
  #:use-module (dbi dbi)
  #:use-module (ice-9 textual-ports)  
  #:use-module (ice-9 rdelim)  ;;read-line
  #:use-module (ice-9 popen)
  #:use-module (rnrs bytevectors)
  #:use-module (web uri)
  #:use-module (limsn lib artass)
  #:use-module (ice-9 pretty-print)
  #:export (
	    ns-lst
	    tef-lst
	    fts-lst
	    make-scatter-plot
	    get-96-row-labels
	    get-384-row-labels
	    get-1536-row-labels
	    get-spl-color
	    make-scatter-plot-svg
	    make-layout-plot-spl-out
	    make-layout-plot-spl-rep-out
	    make-layout-plot-trg-rep-out
	    get-layout-preview-plot-svg
	    prep-lyt-for-g
	    ))



;; used to reverse row labels for plotting
(define ns-lst
  ;; 96 well rows
  '((1 . 8)(2 . 7)(3 . 6)(4 . 5)(5 . 4)(6 . 3)(7 . 2)(8 . 1)))
(define tef-lst
  ;; 384 well rows
  '((1 . 16)(2 . 15)(3 . 14)(4 . 13)(5 . 12)(6 . 11)(7 . 10)(8 . 9)(9 . 8)(10 . 7)(11 . 6)(12 . 5)(13 . 4)(14 . 3)(15 . 2)(16 . 1)))
(define fts-lst
  ;; 1536 well rows
'((1 . 32)(2 . 31)(3 . 30)(4 . 29)(5 . 28)(6 . 27)(7 . 26)(8 . 25)(9 . 24)(10 . 23)(11 . 22)(12 . 21)(13 . 20)(14 . 19)(15 . 18)(16 . 17)(17 . 16)(18 . 15)(19 . 14)(20 . 13)(21 . 12)(22 . 11)(23 . 10)(24 . 9)(25 . 8)(26 . 7)(27 . 6)(28 . 5)(29 . 4)(30 . 3)(31 . 2)(32 . 1)))

(define get-96-row-labels '( (1 . "A")(2 . "B")(3 . "C")(4 . "D")(5 . "E")(6 . "F")(7 . "G")(8 . "H")))

(define get-384-row-labels '( (1 . "A")(2 . "B")(3 . "C")(4 . "D")(5 . "E")(6 . "F")(7 . "G")(8 . "H")(9 . "I")(10 . "J")(11 . "K")(12 . "L")(13 . "M")(14 . "N")(15 . "O")(16 . "P")))

(define get-1536-row-labels '( (1 . "A")(2 . ".")(3 . "C")(4 . ".")(5 . "E")(6 . ".")(7 . "G")(8 . ".")(9 . "I")(10 . ".")(11 . "K")(12 . ".")(13 . "M")(14 . ".")(15 . "O")(16 . ".")(17 . "Q")(18 . ".")(19 . "S")(20 . ".")(21 . "U")(22 . ".")(23 . "W")(24 . ".")(25 . "Y")(26 . ".")(27 . "AA")(28 . ".")(29 . "AC")(30 . ".")(31 . "AE")(32 . ".")))


(define get-spl-color '((1 . "0x000000")   ;;unk black
			(2 . "0x00ff00")   ;;pos green
			(3 . "0xff0000")   ;;neg red 
			(4 . "0x969696")   ;;blank grey
			(5 . "0x33FFFF"))) ;;edge light blue

(define (get-svg-content gnuplot-script-file)
  ;;requires:   set terminal svg size 600,400
  ;;            save '-'
  ;;in the script
  ;;gnuplot-script is the script as a text variable
  (let* ((port (open-input-pipe (string-append "gnuplot " gnuplot-script-file)))
	 (a "")	 
	 (dummy (let loop ((line (read-line port)))
		  (if (not (eof-object? line))
		      (begin
			(set! a (string-append a line))
			(loop (read-line port))))))	 	 
	 (dummy (close-pipe port))
	 (dummy (pretty-print a))
	 (coord-start (string-match "<svg  width=" a ))
	 (coord-end (string-match "</g></svg>" a)))
    (xsubstring a (match:start coord-start) (match:end coord-end))
  ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SCATTER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-scatter-plot outfile response metric threshold nrows num-hits data-body )
;; Threshold  called metric below x,y are coordinates for printing
  ;; outfile: .png filename
  ;; nrows number of data points to plot
  ;; num-hits given the threshold
  ;; threshold must be a number
  (let* ((y-label (cond ((equal? response "0") "Background Subtracted")
			((equal? response "1") "Normalized")
			((equal? response "2") "Normalized to positive controls")
			((equal? response "3") "% Enhanced")))
	 (metric-text (cond   ((equal? metric "1") "> mean(pos)")
			      ((equal? metric "2") "mean(neg) + 2SD")
			      ((equal? metric "3") "mean(neg) + 3SD")
			      (else "Manual")))
	 (metric-text-x (number->string (* nrows 0.08)))
	 ;;if  response=3 %enhanced, mean of threshold is 0 so set y to 5%
	 (metric-text-y (if (equal? response "3") "-5" (number->string (- threshold (* threshold 0.06)))))
	 (xmax (number->string (+ nrows 4)))
	 (hit-num-text (string-append "hits: " num-hits))
	 (hit-num-text-x (number->string (* nrows 0.08)))
	 (hit-num-text-y (if (equal? response "3") "5" (number->string (+ threshold (* threshold 0.06)))))
	 (thresholdstr (number->string threshold))
	 (gplot-script (get-gplot-scatter-script outfile y-label thresholdstr xmax hit-num-text hit-num-text-x hit-num-text-y metric-text-x metric-text-y data-body))
	 ;; (p  (open-output-file (get-rand-file-name "script" "txt")))
	 ;; (dummy (begin
	 ;; 	  (put-string p gplot-script )
	 ;; 	  (force-output p)))
	 (port (open-output-pipe "gnuplot"))
	 )
    (begin
      (display gplot-script port)
      (close-pipe port))
    )) 


(define (make-scatter-plot-svg outfile response metric threshold nrows num-hits data-body )
  ;; Threshold  called metric below x,y are coordinates for printing
  ;; nrows number of data points to plot
  ;; num-hits given the threshold
  ;; threshold must be a number
  (let* ((y-label (cond ((equal? response "0") "Background Subtracted")
			((equal? response "1") "Normalized")
			((equal? response "2") "Normalized to positive controls")
			((equal? response "3") "% Enhanced")))
	 (metric-text (cond   ((equal? metric "1") "> mean(pos)")
			      ((equal? metric "2") "mean(neg) + 2SD")
			      ((equal? metric "3") "mean(neg) + 3SD")
			      (else "Manual")))
	 (metric-text-x (number->string (* nrows 0.08)))
	 ;;if  response=3 %enhanced, mean of threshold is 0 so set y to 5%
	 (metric-text-y (if (equal? response "3") "-5" (number->string (- threshold (* threshold 0.06)))))
	 (xmax (number->string (+ nrows 4)))
	 (hit-num-text (string-append "hits: " num-hits))
	 (hit-num-text-x (number->string (* nrows 0.08)))
	 (hit-num-text-y (if (equal? response "3") "5" (number->string (+ threshold (* threshold 0.06)))))
	 (thresholdstr (number->string threshold))
	 (gplot-script (get-gplot-scatter-script y-label thresholdstr xmax hit-num-text hit-num-text-x hit-num-text-y metric-text metric-text-x metric-text-y data-body))
	 (p  (open-output-file outfile))
	  (dummy (begin
	  	  (put-string p gplot-script )
	 	  (force-output p)))
	 )
    (get-svg-content outfile)
    )) 

;;uses svg method
(define (get-gplot-scatter-script  ylabel threshold xmax hit-num-text hit-num-text-x hit-num-text-y metric-text metric-text-x metric-text-y data)
  ;;xmax is 100 for 96 well plates, 385 for 384 well plate etc
  ;; hit-num-text e.g. 38 hits
  ;; metric-text e.g. Norm + 3SD
  (let* (
	 (str1 "reset session\nset terminal svg size 800,500\nsave '-' ")
	 (str2 "\nset key box ins vert right top\nset grid\nset arrow 1 nohead from 0,")
	 (str3 " to ")
	 (str4 ", ")
	 (str5 " linewidth 1 dashtype 2\nset xlabel \"Index\"\nset ylabel \"")	       
	 (str6 "\"\nset label '")
	 (str7 "' at ")
	 (str8 ",")
	 (str9 "\nset label '")
	 (str10 "' at ")
	 (str11 ",")
	 (str12 "\nplot '-' using 1:2:3 notitle with points pt 2 lc rgbcolor variable, NaN with points pt 20 lc rgb \"green\" title \"pos\", NaN with points pt 20 lc rgb \"red\" title \"neg\", NaN with points pt 20 lc rgb \"black\" title \"unk\", NaN with points pt 20  lc rgb \"grey\" title \"blank\"\n")
	 (str13 "e"))   
   (string-append str1 str2 threshold str3 xmax str4 threshold str5 ylabel str6  hit-num-text str7 hit-num-text-x str8 hit-num-text-y str9 metric-text str10 metric-text-x str11 metric-text-y str12 data str13 ) ))

	 
    
;; old method using text files on disk
;; (define (get-gplot-scatter-script out-file ylabel threshold xmax hit-num-text hit-num-text-x hit-num-text-y metric-text metric-text-x metric-text-y data)
;;   ;;xmax is 100 for 96 well plates, 385 for 384 well plate etc
;;   ;; hit-num-text e.g. 38 hits
;;   ;; metric-text e.g. Norm + 3SD
;;   (let* (
;; 	 (str1 "reset session\nset terminal pngcairo size 800,500\nset output '")
;; 	 (str2 "'\nset key box ins vert right top\nset grid\nset arrow 1 nohead from 0,")
;; 	 (str3 " to ")
;; 	 (str4 ", ")
;; 	 (str5 " linewidth 1 dashtype 2\nset xlabel \"Index\"\nset ylabel \"")	       
;; 	 (str6 "\"\nset label '")
;; 	 (str7 "' at ")
;; 	 (str8 ",")
;; 	 (str9 "\nset label '")
;; 	 (str10 "' at ")
;; 	 (str11 ",")
;; 	 (str12 "\nplot '-' using 1:2:3 notitle with points pt 2 lc rgbcolor variable, NaN with points pt 20 lc rgb \"green\" title \"pos\", NaN with points pt 20 lc rgb \"red\" title \"neg\", NaN with points pt 20 lc rgb \"black\" title \"unk\", NaN with points pt 20  lc rgb \"grey\" title \"blank\"\n")
;; 	 (str13 "e"))   
;;    (string-append str1  out-file str2 threshold str3 xmax str4 threshold str5 ylabel str6  hit-num-text str7 hit-num-text-x str8 hit-num-text-y str9 metric-text str10 metric-text-x str11 metric-text-y str12 data str13 ) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LAYOUT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (prep-lyt-for-g a format)
  ;; 1 'unknown' ? 0x000000  black
  ;; 2 'positive' ? 0x00ff00  green
  ;; 3 'negative' ? 0xff0000  red
  ;; 4 'blank' ? 0x969696    grey
  ;; 5 'edge'    0x33FFFF    lightblue

  ;; rep1 0x000000  black
  ;; rep2
  ;; rep3
  ;; rep4
  (fold (lambda (x prev)
          (let* ((row-num (get-c1 x))
		 (rev-row (cond ((equal? format "96")  (assq-ref ns-lst (string->number row-num)))
				((equal? format "384") (assq-ref tef-lst (string->number row-num)))
				((equal? format "1536") (assq-ref fts-lst (string->number row-num)))
				))
		 (col (result-ref x "col"))
		 (y-tic-label (cond ((equal? format "96")  (assq-ref get-96-row-labels (string->number row-num)))
				    ((equal? format "384") (assq-ref get-384-row-labels (string->number row-num)))
				    ((equal? format "1536") (assq-ref get-1536-row-labels (string->number row-num)))
				))
		 
		 (type (cond ((equal? (get-c3 x ) "1") "0x000000")
			     ((equal? (get-c3 x ) "2") "0x00ff00")
			     ((equal? (get-c3 x ) "3") "0xff0000")
			     ((equal? (get-c3 x ) "4") "0x969696")			     
			     ((equal? (get-c3 x ) "5") "0x33FFFF")))
		 (replicates (cond ((equal? (get-c4 x ) "1") "0x000000")
			     ((equal? (get-c4 x ) "2") "0xFFFFFF")
			     ((equal? (get-c4 x ) "3") "0x0000FF")
			     ((equal? (get-c4 x ) "4") "0x33FFFF")))		         
		 (target (cond ((equal? (get-c5 x ) "1") "0x000000")
			     ((equal? (get-c5 x ) "2") "0xFFFFFF")
			     ((equal? (get-c5 x ) "3") "0x0000FF")
			     ((equal? (get-c5 x ) "4") "0x33FFFF")))			     
		 )
            (cons (string-append  row-num "\t" (number->string rev-row) "\t" col "\t" y-tic-label  "\t" type "\t" replicates "\t" target "\n")
		  prev)))
        '() a))



;; (define (make-layout-plot spl-out spl-rep-out trg-rep-out data-body arid format)
;; ;; Threshold  called metric below x,y are coordinates for printing
;;   ;; outfile: .png filename
;;   ;; nrows number of data points to plot
;;   ;; num-hits given the threshold
;;   ;; threshold must be a number
;;   (let* ((xmax (cond ((equal? format "96")  "13")
;; 		     ((equal? format "384") "25")
;; 		     ((equal? format "1536") "49")
;; 		     ))	 
;; 	 (ymax (cond ((equal? format "96")  "9")
;; 		     ((equal? format "384") "17")
;; 		     ((equal? format "1536") "33")
;; 		     ))
;; 	 (ptsize (cond ((equal? format "96")  "3")
;; 		     ((equal? format "384") "2")
;; 		     ((equal? format "1536") "1")
;; 		     ))
	 
;; 	 (gplot-script   (string-append "reset session\n$Data <<EOD\n" data-body "EOD\nset terminal pngcairo size 600,350\nset output 'pub/" spl-out "'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:5:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb \"green\" title \"pos\", NaN with points pt 20 lc rgb \"red\" title \"neg\", NaN with points pt 20 lc rgb \"black\" title \"unk\", NaN with points pt 20  lc rgb \"grey\" title \"blank\", NaN with points pt 20  lc rgb 0x33FFFF title \"edge\"\nset output 'pub/" spl-rep-out "'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:6:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb 0x000000 title \"plate1\", NaN with points pt 20 lc rgb 0xFFFFFF title \"plate2\", NaN with points pt 20 lc rgb 0x0000FF title \"plate3\", NaN with points pt 20  lc rgb 0x33FFFF title \"plate4\"\nset output 'pub/" trg-rep-out "'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:7:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb 0x000000 title \"target1\", NaN with points pt 20 lc rgb 0xFFFFFF title \"target2\", NaN with points pt 20 lc rgb 0x0000FF title \"target3\", NaN with points pt 20  lc rgb 0x33FFFF title \"target4\""))
;; ;;	 (p  (open-output-file (get-rand-file-name "script" "txt")))
    	 
;; 	 (port (open-output-pipe "gnuplot"))
;; 	 )
;;     (begin
;;       (display gplot-script port)
;;       (close-pipe port))
;;    ;; (begin
;;      ;; (put-string p gplot-script )
;;      ;; (force-output p))   
;;     ))

(define (make-layout-plot-spl-out spl-out data-body arid format)
;; Threshold  called metric below x,y are coordinates for printing
  ;; nrows number of data points to plot
  ;; num-hits given the threshold
  ;; threshold must be a number
  (let* ((xmax (cond ((equal? format "96")  "13")
		     ((equal? format "384") "25")
		     ((equal? format "1536") "49")
		     ))	 
	 (ymax (cond ((equal? format "96")  "9")
		     ((equal? format "384") "17")
		     ((equal? format "1536") "33")
		     ))
	 (ptsize (cond ((equal? format "96")  "2")
		     ((equal? format "384") "1")
		     ((equal? format "1536") "1")
		     ))
	 
	 (gplot-script   (string-append "reset session\n$Data <<EOD\n" data-body "EOD\nset terminal svg size 600,350\nsave '-'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:5:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb \"green\" title \"pos\", NaN with points pt 20 lc rgb \"red\" title \"neg\", NaN with points pt 20 lc rgb \"black\" title \"unk\", NaN with points pt 20  lc rgb \"grey\" title \"blank\", NaN with points pt 20  lc rgb 0x33FFFF title \"edge\""))
	 (p  (open-output-file spl-out))
	 (dummy (begin
	  	  (put-string p gplot-script )
	 	  (force-output p)))
	 )
    (get-svg-content spl-out)
    )) 



(define (make-layout-plot-spl-rep-out spl-rep-out data-body arid format)
;; Threshold  called metric below x,y are coordinates for printing
  ;; outfile: .png filename
  ;; nrows number of data points to plot
  ;; num-hits given the threshold
  ;; threshold must be a number
  (let* ((xmax (cond ((equal? format "96")  "13")
		     ((equal? format "384") "25")
		     ((equal? format "1536") "49")
		     ))	 
	 (ymax (cond ((equal? format "96")  "9")
		     ((equal? format "384") "17")
		     ((equal? format "1536") "33")
		     ))
	 (ptsize (cond ((equal? format "96")  "2")
		     ((equal? format "384") "1")
		     ((equal? format "1536") "1")
		     ))	 
	 (gplot-script   (string-append "reset session\n$Data <<EOD\n" data-body "EOD\nset terminal svg size 600,350\nsave '-'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:6:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb 0x000000 title \"plate1\", NaN with points pt 20 lc rgb 0xFFFFFF title \"plate2\", NaN with points pt 20 lc rgb 0x0000FF title \"plate3\", NaN with points pt 20  lc rgb 0x33FFFF title \"plate4\""))
	 (p  (open-output-file spl-rep-out))
	 (dummy (begin
	  	  (put-string p gplot-script )
	 	  (force-output p)))
	 )
    (get-svg-content spl-rep-out)
    )) 

(define (make-layout-plot-trg-rep-out trg-rep-out data-body arid format)
;; Threshold  called metric below x,y are coordinates for printing
  ;; outfile: .png filename
  ;; nrows number of data points to plot
  ;; num-hits given the threshold
  ;; threshold must be a number
  (let* ((xmax (cond ((equal? format "96")  "13")
		     ((equal? format "384") "25")
		     ((equal? format "1536") "49")
		     ))	 
	 (ymax (cond ((equal? format "96")  "9")
		     ((equal? format "384") "17")
		     ((equal? format "1536") "33")
		     ))
	 (ptsize (cond ((equal? format "96")  "2")
		     ((equal? format "384") "1")
		     ((equal? format "1536") "1")
		     ))
	 
	 (gplot-script   (string-append "reset session\n$Data <<EOD\n" data-body "EOD\nset terminal svg size 600,350\nsave '-'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:7:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb 0x000000 title \"target1\", NaN with points pt 20 lc rgb 0xFFFFFF title \"target2\", NaN with points pt 20 lc rgb 0x0000FF title \"target3\", NaN with points pt 20  lc rgb 0x33FFFF title \"target4\""))
	 (p  (open-output-file trg-rep-out))
	 (dummy (begin
	  	  (put-string p gplot-script )
	 	  (force-output p)))
	 )
    (get-svg-content trg-rep-out)
    )) 

	 
;;;;;;;;;;

(define (get-layout-preview-plot-svg spl-out data-body format)
;; Threshold  called metric below x,y are coordinates for printing
  ;; outfile: .png filename
  ;; nrows number of data points to plot
  ;; num-hits given the threshold
  ;; threshold must be a number
  (let* ((xmax (cond ((equal? format "96")  "13")
		     ((equal? format "384") "25")
		     ((equal? format "1536") "49")
		     ))	 
	 (ymax (cond ((equal? format "96")  "9")
		     ((equal? format "384") "17")
		     ((equal? format "1536") "33")
		     ))
	 (ptsize (cond ((equal? format "96")  "2")
		     ((equal? format "384") "1")
		     ((equal? format "1536") "1")
		     ))	 
	 (gplot-script   (string-append "reset session\n$Data <<EOD\n" data-body "EOD\nset terminal svg size 600,350\nsave '-'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 1:2:4:ytic(3) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb \"green\" title \"pos\", NaN with points pt 20 lc rgb \"red\" title \"neg\", NaN with points pt 20 lc rgb \"black\" title \"unk\", NaN with points pt 20  lc rgb \"grey\" title \"blank\", NaN with points pt 20  lc rgb 0x33FFFF title \"edge\"\n"))
	 (p  (open-output-file spl-out))
	 (dummy (begin
	  	  (put-string p gplot-script )
	 	  (force-output p)))
	 )
    (get-svg-content spl-out)
    )) 

;;below is pre svg, files only OLD

;; (define (make-layout-plot spl-out spl-rep-out trg-rep-out data-body arid format)
;; ;; Threshold  called metric below x,y are coordinates for printing
;;   ;; outfile: .png filename
;;   ;; nrows number of data points to plot
;;   ;; num-hits given the threshold
;;   ;; threshold must be a number
;;   (let* ((xmax (cond ((equal? format "96")  "13")
;; 		     ((equal? format "384") "25")
;; 		     ((equal? format "1536") "49")
;; 		     ))	 
;; 	 (ymax (cond ((equal? format "96")  "9")
;; 		     ((equal? format "384") "17")
;; 		     ((equal? format "1536") "33")
;; 		     ))
;; 	 (ptsize (cond ((equal? format "96")  "3")
;; 		     ((equal? format "384") "2")
;; 		     ((equal? format "1536") "1")
;; 		     ))
	 
;; 	 (gplot-script   (string-append "reset session\n$Data <<EOD\n" data-body "EOD\nset terminal pngcairo size 600,350\nset output 'pub/" spl-out "'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:5:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb \"green\" title \"pos\", NaN with points pt 20 lc rgb \"red\" title \"neg\", NaN with points pt 20 lc rgb \"black\" title \"unk\", NaN with points pt 20  lc rgb \"grey\" title \"blank\", NaN with points pt 20  lc rgb 0x33FFFF title \"edge\"\nset output 'pub/" spl-rep-out "'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:6:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb 0x000000 title \"plate1\", NaN with points pt 20 lc rgb 0xFFFFFF title \"plate2\", NaN with points pt 20 lc rgb 0x0000FF title \"plate3\", NaN with points pt 20  lc rgb 0x33FFFF title \"plate4\"\nset output 'pub/" trg-rep-out "'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 3:2:7:ytic(4) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb 0x000000 title \"target1\", NaN with points pt 20 lc rgb 0xFFFFFF title \"target2\", NaN with points pt 20 lc rgb 0x0000FF title \"target3\", NaN with points pt 20  lc rgb 0x33FFFF title \"target4\""))
;; ;;	 (p  (open-output-file (get-rand-file-name "script" "txt")))
    	 
;; 	 (port (open-output-pipe "gnuplot"))
;; 	 )
;;     (begin
;;       (display gplot-script port)
;;       (close-pipe port))
;;    ;; (begin
;;      ;; (put-string p gplot-script )
;;      ;; (force-output p))   
;;     )) 

;; (define (make-layout-preview-plot spl-out data-body format)
;; ;; Threshold  called metric below x,y are coordinates for printing
;;   ;; outfile: .png filename
;;   ;; nrows number of data points to plot
;;   ;; num-hits given the threshold
;;   ;; threshold must be a number
;;   (let* ((xmax (cond ((equal? format "96")  "13")
;; 		     ((equal? format "384") "25")
;; 		     ((equal? format "1536") "49")
;; 		     ))	 
;; 	 (ymax (cond ((equal? format "96")  "9")
;; 		     ((equal? format "384") "17")
;; 		     ((equal? format "1536") "33")
;; 		     ))
;; 	 (ptsize (cond ((equal? format "96")  "3")
;; 		     ((equal? format "384") "2")
;; 		     ((equal? format "1536") "1")
;; 		     ))	 
;; 	 (gplot-script   (string-append "reset session\n$Data <<EOD\n" data-body "EOD\nset terminal pngcairo size 600,350\nset output 'pub/" spl-out "'\nset key box outs vert right center\nset xrange [0:" xmax  "]\nset yrange [0:" ymax "]\nset x2tics\nset x2label \"Columns\"\nset ylabel \"Rows\"\nunset xtics\nset xtics format \" \"\nplot $Data using 1:2:4:ytic(3) notitle with points ps " ptsize " lc rgbcolor variable pt 20, NaN with points pt 20 lc rgb \"green\" title \"pos\", NaN with points pt 20 lc rgb \"red\" title \"neg\", NaN with points pt 20 lc rgb \"black\" title \"unk\", NaN with points pt 20  lc rgb \"grey\" title \"blank\", NaN with points pt 20  lc rgb 0x33FFFF title \"edge\"\n"))
;; ;;	 (p  (open-output-file (get-rand-file-name "script" "txt")))
	 
;; 	 (port (open-output-pipe "gnuplot"))
;; 	 )
;;     (begin
;;       (display gplot-script port)
;;       (close-pipe port))
;;    ;; (begin
;;      ;; (put-string p gplot-script )
;;      ;; (force-output p))   
;;     )) 

