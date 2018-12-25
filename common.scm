; assert

(define (display-all . vs)
  (for-each display vs))

(define (assert exp act)
  (cond ((eq? exp act) #t)
	(else (display-all "assert failed: " exp " != " act) #f)))
