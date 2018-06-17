Exercise 1.12.  The following pattern of numbers is called Pascal's triangle.

    1
   1 1
  1 2 1
 1 3 3 1
1 4 6 4 1
   ...

The numbers at the edge of the triangle are all 1, and each number inside the triangle is the sum of the two numbers above it. Write a procedure that computes elements of Pascal's triangle by means of a recursive process. 

(define (pascal-triangle-elem row column)
  (cond ((or (< row 1)
	     (< column 1)
	     (< row column))
	 -1)
	((or (= column 1)
	     (= column row))
	 1)
        (else
	 (+ (pascal-triangle-elem (- row 1) (- column 1))
	    (pascal-triangle-elem (- row 1) column)))))

(define pte pascal-triangle-elem)

(pte 0 1) ; -1
(pte 1 0) ; -1
(pte 1 2) ; -1
(pte 2 3) ; -1

(pte 1 1) ; 1

(pte 2 1) ; 1
(pte 2 2) ; 1

(pte 3 1) ; 1
(pte 3 2) ; 2
(pte 3 3) ; 1

(pte 4 1) ; 1
(pte 4 2) ; 3
(pte 4 3) ; 3
(pte 4 4) ; 1
