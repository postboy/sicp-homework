; Exercise 2.42.  The ``eight-queens puzzle'' asks how to place eight queens on a chessboard so that no queen is in check from any other (i.e., no two queens are in the same row, column, or diagonal). One possible solution is shown in figure 2.8. One way to solve the puzzle is to work across the board, placing a queen in each column. Once we have placed k - 1 queens, we must place the kth queen in a position where it does not check any of the queens already on the board. We can formulate this approach recursively: Assume that we have already generated the sequence of all possible ways to place k - 1 queens in the first k - 1 columns of the board. For each of these ways, generate an extended set of positions by placing a queen in each row of the kth column. Now filter these, keeping only the positions for which the queen in the kth column is safe with respect to the other queens. This produces the sequence of all ways to place k queens in the first k columns. By continuing this process, we will produce not only one solution, but all solutions to the puzzle.

; We implement this solution as a procedure queens, which returns a sequence of all solutions to the problem of placing n queens on an n×n chessboard. Queens has an internal procedure queen-cols that returns the sequence of all ways to place queens in the first k columns of the board.

; In this procedure rest-of-queens is a way to place k - 1 queens in the first k - 1 columns, and new-row is a proposed row in which to place the queen for the kth column. Complete the program by implementing the representation for sets of board positions, including the procedure adjoin-position, which adjoins a new row-column position to a set of positions, and empty-board, which represents an empty set of positions. You must also write the procedure safe?, which determines for a set of positions, whether the queen in the kth column is safe with respect to the others. (Note that we need only check whether the new queen is safe -- the other queens are already guaranteed safe with respect to each other.)

(load "ch22_common.scm")

(define empty-board nil)

(define (make-position row col)
  (list row col))

(define (get-row pos)
  (car pos))

(define (get-col pos)
  (cadr pos))

(define (adjoin-position new-row k rest-of-queens)
  (cons (make-position new-row k) rest-of-queens))

(define (check-pos x y)
  (define same-row?
    (eq? (get-row x) (get-row y)))
  (define same-col?
    (eq? (get-col x) (get-col y)))
  (define on-direct-diagonal?
    (eq? (- (get-row x) (get-col x))
	 (- (get-row y) (get-col y))))
  (define on-reverse-diagonal?
    (eq? (+ (get-row x) (get-col x))
	 (+ (get-row y) (get-col y))))
  (or (eq? x y)
      (not (or same-row?
	       same-col?
	       on-direct-diagonal?
	       on-reverse-diagonal?))))

(define p11 (make-position 1 1))
(define p12 (make-position 1 2))
(define p13 (make-position 1 3))
(define p23 (make-position 2 3))
(define p31 (make-position 3 1))
(define p32 (make-position 3 2))
(define p33 (make-position 3 3))

(assert #f (check-pos p11 p13))
(assert #f (check-pos p11 p31))
(assert #f (check-pos p11 p33))
(assert #f (check-pos p23 p32))
(assert #t (check-pos p12 p33))

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define (safe? k positions)
  (define kth-col (car (filter (lambda (pos) (eq? k (get-col pos))) positions)))
  (define (and-wrapper x y)
    (and x y))
  (accumulate and-wrapper #t
	      (map (lambda (x) (check-pos kth-col x)) positions)))

(assert #t (safe? 2 (list p12 p33)))
(assert #t (safe? 3 (list p12 p33)))
(assert #f (safe? 2 (list p23 p32)))
(assert #f (safe? 3 (list p23 p32)))
(assert #t (safe? 1 (list p23 p32 p11)))
(assert #f (safe? 2 (list p23 p32 p11)))
(assert #f (safe? 3 (list p23 p32 p11)))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(assert '(()) (queens 0))
(assert '(((1 1))) (queens 1))

(assert (length (queens 0)) 1)
(assert (length (queens 1)) 1)
(assert (length (queens 2)) 0)
(assert (length (queens 3)) 0)
(assert (length (queens 4)) 2)
(assert (length (queens 5)) 10)
(assert (length (queens 6)) 4)
(assert (length (queens 7)) 40)
(assert (length (queens 8)) 92)
; slow!
; (assert (length (queens 9)) 352)
; (assert (length (queens 10)) 724)
