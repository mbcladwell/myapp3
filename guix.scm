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
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module ((srfi srfi-1) #:select (alist-delete)))

(define-public myapp3
  (let ((commit "5be1009ec3dbb3cd28e0480768b9750d19b5d1b3")
        (revision "1"))
    (package
      (name "myapp3")
      (version (string-append "0-" revision "." (string-take commit 7)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/mbcladwell/myapp3.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0vlgld7xyh30n5pyp1hhavnjwy0551byxswj70b4aaifbc3dqh9p"))))
      (build-system guile-build-system)
      ;; (arguments
      ;;  '(#:phases
      ;;    (modify-phases %standard-phases
      ;;      (add-after 'unpack 'patch
      ;;        (lambda* (#:key inputs #:allow-other-keys)
      ;;          (substitute* "squee.scm"
      ;;            (("dynamic-link \"libpq\"")
      ;;             (string-append
      ;;              "dynamic-link \""
      ;;              (assoc-ref inputs "postgresql") "/lib/libpq.so"
      ;;              "\"")))
      ;;          #t)))))
;      (inputs
 ;      `(("postgresql" ,postgresql)))
      (native-inputs
       `(("guile" ,guile-3.0)))
      (home-page "https://notabug.org/cwebber/guile-squee")
      (synopsis "Connect to PostgreSQL using Guile")
      (description
       "@code{squee} is a Guile library for connecting to PostgreSQL databases
using Guile's foreign function interface.")
      (license license:lgpl3+))))

myapp3
