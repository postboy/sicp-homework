; common code for this chapter

(define (assert exp act)
  (if (eq? exp act)
	 #t
	 (display "assert failed!")))
