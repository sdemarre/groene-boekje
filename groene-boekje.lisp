;;;; groene-boekje.lisp

(in-package #:groene-boekje)

(defun get-page (letter number)
  (let ((uri (format nil "http://woordenlijst.org/voorvoegsel/~a/~a" letter number)))
    (car (multiple-value-list (drakma:http-request uri)))))

(defun letter-counts ()
  #(5421 7983 3147 4662 2327 1953 5266 4246 2356 815
    6085 3638 4665 2006 5959 6035 80 4268 9853
    4748 1125 7303 3785 22 34 2742))
(defun letter-count (letter)
  (elt (letter-counts) (- (char-code letter) (char-code #\a))))
(defun get-strong-words (text)
  (let (result)
    (cl-ppcre:do-matches-as-strings (s "(strong>)(.+)(</strong)" text)
      (let ((first (position #\> s))
	    (last (position #\< s :from-end t)))
	(when (and first last)
	  (push (subseq s (1+ first) last) result))))
    (reverse result)))


(defun get-words-for-letter (letter)
  (let ((result))
    (iter (for url-index from 1)	
	  (while (< url-index (1+ (floor (letter-count letter) 20))))
	  (sleep 2)
	  (format t "getting ~a/~a~%" letter url-index)
	  (iter (for word in (get-strong-words (get-page letter url-index)))
		(push word result)))
    (reverse result)))
(defun save-words-for-letter (letter)
  (let ((filename (format nil "c:/users/serge.demarre/appdata/roaming/src/lisp/systems/boggle/woorden-~a" letter)))
    (with-open-file (s filename :direction :output :if-exists :supersede)
      (iter (for word in (get-words-for-letter letter))
	    (format s "~a~%" word)))))
