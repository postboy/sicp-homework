(load "../common.scm")

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

; for testing

(define (stream-to-list s)
  (define reversed-list nil)
  (define (append-to-list elt)
    (set! reversed-list (cons elt reversed-list)))
  (stream-for-each append-to-list s)
  (reverse reversed-list))
