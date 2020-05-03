; Exercise 3.47.  A semaphore (of size n) is a generalization of a mutex. Like a mutex, a semaphore supports acquire and release operations, but it is more general in that up to n processes can acquire it concurrently. Additional processes that attempt to acquire the semaphore must wait for release operations. Give implementations of semaphores...

(load "ch34_common.scm")

; As far as I understand, it's ok to allow a single process to acquire same semaphore N times if semaphore's number will be decremented N times.

; a. ...in terms of mutexes.

(define (make-semaphore initial)
  (let ((value initial)
	(the-mutex (make-mutex)))
    (define (the-semaphore m)
      (cond ((eq? m 'acquire)
             (the-mutex 'acquire)
	     (if (< value 1)
		 (begin (the-mutex 'release)
			(the-semaphore 'acquire)) ; retry acquiring semaphore
		 (begin (set! value (- value 1))
			(the-mutex 'release)
			#t)))
            ((eq? m 'release)
	     (the-mutex 'acquire)
	     (if (= value initial)
		 (error "released semaphore wasn't acqured")
		 (set! value (+ value 1)))
	     (the-mutex 'release)
	     #t)))
    (if (< initial 1)
	(error "initial is non-positive:" initial)
	the-semaphore)))

; produces error message
;(define sem (make-semaphore 0))
(define sem (make-semaphore 2))
(assert (sem 'acquire) #t)
(assert (sem 'acquire) #t)
; Warning: hangs Scheme!
;(assert (sem 'acquire) #f)
(assert (sem 'release) #t)
(assert (sem 'release) #t)
; produces error message
;(assert (sem 'release) #f)

; b. ...in terms of atomic test-and-set! operations.

(define (make-semaphore initial)
  (let ((value initial)
	(cell (list false)))
    (define (the-semaphore m)
      (cond ((eq? m 'acquire)
	     (if (test-and-set! cell)
		 (the-semaphore 'acquire) ; retry acquiring internal lock
		 (begin (if (< value 1)
			    (begin (clear! cell)
				   (the-semaphore 'acquire)) ; retry acquiring semaphore
			    (begin (set! value (- value 1))
				   (clear! cell)
				   #t)))))
            ((eq? m 'release)
	     (if (test-and-set! cell)
		 (the-semaphore 'release) ; retry acquiring internal lock
		 (if (= value initial)
		     (begin (error "released semaphore wasn't acqured")
			    (clear! cell)
			    #f)
		     (begin (set! value (+ value 1))
			    (clear! cell)
			    #t))))))
    (if (< initial 1)
	(error "initial is non-positive:" initial)
	the-semaphore)))

; produces error message
;(define sem (make-semaphore 0))
(define sem (make-semaphore 2))
(assert (sem 'acquire) #t)
(assert (sem 'acquire) #t)
; Warning: hangs Scheme!
;(assert (sem 'acquire) #f)
(assert (sem 'release) #t)
(assert (sem 'release) #t)
; produces error message
;(assert (sem 'release) #f)
