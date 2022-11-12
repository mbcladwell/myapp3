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
             (commit "f2610b50d452f03f1c4745c8cefb5c59c4a38b45")))
       (sha256
             (base32 "03yvjbw1nhsjd99xq5xl4kgb4xjkr0abmqcjb3a0h56kq23kxd66"))))
    (build-system guile-build-system)
    (native-inputs
     `(("guile" ,guile-3.0)))
    (home-page "https://github.com/mbcladwell/myapp3")
    (synopsis "Colorized REPL for Guile")
    (description
     "Guile-colorized provides you with a colorized REPL for GNU Guile.")
    (license license:gpl3+)))

myapp3
