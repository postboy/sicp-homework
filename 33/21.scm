; Exercise 3.21.  Ben Bitdiddle decides to test the queue implementation described above. He types in the procedures to the Lisp interpreter and proceeds to try them out:

(load "ch33_common.scm")

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue)
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (set-front-ptr! queue (cdr (front-ptr queue)))
         queue)))

(define (print-queue queue)
  (display (front-ptr queue)) #t)

(define q1 (make-queue))
(assert (insert-queue! q1 'a) '((a) a))
(assert (insert-queue! q1 'b) '((a b) b))
(assert (empty-queue? q1) #f)
(assert (print-queue q1) #t)
(assert (delete-queue! q1) '((b) b))
(assert (delete-queue! q1) '(() b))
(assert (empty-queue? q1) #t)
(assert (print-queue q1) #t)

; ``It's all wrong!'' he complains. ``The interpreter's response shows that the last item is inserted into the queue twice. And when I delete both items, the second b is still there, so the queue isn't empty, even though it's supposed to be.'' Eva Lu Ator suggests that Ben has misunderstood what is happening. ``It's not that the items are going into the queue twice,'' she explains. ``It's just that the standard Lisp printer doesn't know how to make sense of the queue representation. If you want to see the queue printed correctly, you'll have to define your own print procedure for queues.'' Explain what Eva Lu is talking about. In particular, show why Ben's examples produce the printed results that they do. Define a procedure print-queue that takes a queue as input and prints the sequence of items in the queue.

; Our queue is a pair of pointers: one points to queue's front and another to queue's rear. What interpreter returns is exactly this pair: it's first element expands to whole queue, it's second element expands to last element in queue *if queue isn't empty*. After Ben's actions, the queue itself (i.e., first element of queue internal structure) is indeed empty, and empty-queue? will return #t, but rear pointer (i.e., second element of queue internal structure) still points to some deleted element. It doesn't affect normal functioning of queue, so Eva Lu is right.

; On the other hand, in some deep sense Ben is right too. Internal structure still contains link to deleted element, so it affects reference counter of this element, so this element won't be deleted by garbage collector after Ben's actions despite it's already completely useless. Indeed, 'b doesn't occupy much memory so it's not a real problem now, but queue can contain arbitrary structures, which means that this useless link may prevent freeing of some big useless object. This link probably should be removed if this code will be used in production.
