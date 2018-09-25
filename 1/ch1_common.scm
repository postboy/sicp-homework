; common code for this chapter

(define (assert exp act)
  (cond ((eq? exp act)
	 #t)
	(else
	 (display "assert failed!"))))
