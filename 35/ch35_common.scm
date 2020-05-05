(load "../common.scm")

; stream constructors

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

; stream operations

(define (add-streams s1 s2)
  (stream-map + s1 s2))

; stream operations for testing

(define (stream-to-list s)
  (define reversed-list nil)
  (define (append-to-list elt)
    (set! reversed-list (cons elt reversed-list)))
  (stream-for-each append-to-list s)
  (reverse reversed-list))

(define (display-line x)
  (newline)
  (display x))

(define (display-stream s)
  (stream-for-each display-line s))
