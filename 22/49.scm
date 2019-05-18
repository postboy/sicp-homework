; Exercise 2.49.  Use segments->painter to define the following primitive painters:

(load "47.scm")
(load "48.scm")

(define device (make-graphics-device (car (enumerate-graphics-types))))

(define miniframe (make-frame (make-vect -0.5 -0.5)
			      (make-vect 1.5 0)
			      (make-vect 0 1)))

; a.  The painter that draws the outline of the designated frame.

(define (outline frame)
  (define segments
    (list (make-segment (make-vect 0 0) (make-vect 0 1))
	  (make-segment (make-vect 0 1) (make-vect 1 1))
	  (make-segment (make-vect 1 1) (make-vect 1 0))
	  (make-segment (make-vect 1 0) (make-vect 0 0))))
  ((segments->painter segments) frame))

(graphics-clear device)
(outline miniframe)

; b.  The painter that draws an ``X'' by connecting opposite corners of the frame.

(define (cross frame)
  (define segments
    (list (make-segment (make-vect 0 0) (make-vect 1 1))
	  (make-segment (make-vect 0 1) (make-vect 1 0))))
  ((segments->painter segments) frame))

(graphics-clear device)
(cross miniframe)

; c.  The painter that draws a diamond shape by connecting the midpoints of the sides of the frame.

(define (diamond frame)
  (define segments
    (list (make-segment (make-vect 0.5 0) (make-vect 1 0.5))
	  (make-segment (make-vect 1 0.5) (make-vect 0.5 1))
	  (make-segment (make-vect 0.5 1) (make-vect 0 0.5))
	  (make-segment (make-vect 0 0.5) (make-vect 0.5 0))))
  ((segments->painter segments) frame))

(graphics-clear device)
(diamond miniframe)

; d.  The wave painter.

; I've borrowed segments from SICP wiki.
(define (wave frame)
  (define segments
    (list (make-segment (make-vect .25 0) (make-vect .35 .5)) 
	  (make-segment (make-vect .35 .5) (make-vect .3 .6)) 
	  (make-segment (make-vect .3 .6) (make-vect .15 .4)) 
	  (make-segment (make-vect .15 .4) (make-vect 0 .65)) 
	  (make-segment (make-vect 0 .65) (make-vect 0 .85)) 
	  (make-segment (make-vect 0 .85) (make-vect .15 .6)) 
	  (make-segment (make-vect .15 .6) (make-vect .3 .65)) 
	  (make-segment (make-vect .3 .65) (make-vect .4 .65)) 
	  (make-segment (make-vect .4 .65) (make-vect .35 .85)) 
	  (make-segment (make-vect .35 .85) (make-vect .4 1)) 
	  (make-segment (make-vect .4 1) (make-vect .6 1)) 
	  (make-segment (make-vect .6 1) (make-vect .65 .85)) 
	  (make-segment (make-vect .65 .85) (make-vect .6 .65)) 
	  (make-segment (make-vect .6 .65) (make-vect .75 .65)) 
	  (make-segment (make-vect .75 .65) (make-vect 1 .35)) 
	  (make-segment (make-vect 1 .35) (make-vect 1 .15)) 
	  (make-segment (make-vect 1 .15) (make-vect .6 .45)) 
	  (make-segment (make-vect .6 .45) (make-vect .75 0)) 
	  (make-segment (make-vect .75 0) (make-vect .6 0)) 
	  (make-segment (make-vect .6 0) (make-vect .5 .3)) 
	  (make-segment (make-vect .5 .3) (make-vect .4 0)) 
	  (make-segment (make-vect .4 0) (make-vect .25 0))))
  ((segments->painter segments) frame))

(graphics-clear device)
(wave miniframe)

(graphics-close device)
