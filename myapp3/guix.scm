(define-module (myapp3)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system guile)
  #:use-module (gnu packages guile)
  #:use-module (guix utils)
  #:use-module ((guix build utils) #:select (alist-replace))
  #:use-module (ice-9 match)
;;  #:use-module (gnu home)
;;  #:use-module (gnu home services)
;;  #:use-module (gnu home services shells)
;;  #:use-module (gnu services)
;;  #:use-module (gnu packages admin)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module ((srfi srfi-1) #:select (alist-delete)))


(define-public myapp3
  (package
    (name "myapp3")
    (version "0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mbcladwell/myapp3.git")
             (commit "0e23c7eeb5c0b093ac22b2412a14cd5a11c8ae6b")))
       (sha256
             (base32 "0a3xh9xp21j0q7ny9449p70c964l4j5mphkbv8ladg7rw790xk1f"))))
    (build-system guile-build-system)
    (native-inputs
     `(("guile" ,guile-3.0)))
    (home-page "https://github.com/mbcladwell/myapp3")
    (synopsis "Colorized REPL for Guile")
    (description
     "Guile-colorized provides you with a colorized REPL for GNU Guile.")
    (license license:gpl3+)))

myapp3
