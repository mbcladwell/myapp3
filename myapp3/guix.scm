(define-module (labsolns myapp3)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
;;  #:use-module (guix build-system gnu)
  #:use-module (guix build-system guile)
  #:use-module (gnu packages guile)
  #:use-module (guix utils)
  #:use-module ((guix build utils) #:select (alist-replace))
  #:use-module (ice-9 match)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module ((srfi srfi-1) #:select (alist-delete))
  )


(define-public myapp3
  (package
    (name "myapp3")
    (version "0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mbcladwell/myapp3.git")
             (commit "bbfe0ef5c6c126b47955ff6fb44dc9470544f828")))
       (sha256
             (base32 "09ir68fx9ymgigffszs21h2r6f5n9h5fahzag1p2sn3yl0a2m98x"))))
    (build-system guile-build-system)
    (native-inputs
     `(("guile" ,guile-3.0)))
    (home-page "https://github.com/mbcladwell/myapp3")
    (synopsis "Colorized REPL for Guile")
    (description
     "Guile-colorized provides you with a colorized REPL for GNU Guile.")
    (license license:gpl3+)))

myapp3
