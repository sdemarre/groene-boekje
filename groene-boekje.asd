;;;; groene-boekje.asd

(asdf:defsystem #:groene-boekje
  :description "Describe groene-boekje here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :serial t
  :depends-on (#:drakma #:cl-ppcre #:iterate)
  :components ((:file "package")
               (:file "groene-boekje")))

