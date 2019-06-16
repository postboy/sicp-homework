; Exercise 2.70.  The following eight-symbol alphabet with associated relative frequencies was designed to efficiently encode the lyrics of 1950s rock songs. (Note that the ``symbols'' of an ``alphabet'' need not be individual letters.)

; Use generate-huffman-tree (exercise 2.69) to generate a corresponding Huffman tree, and use encode (exercise 2.68) to encode the following message: <...>

(load "68.scm")
(load "69.scm")

(define 50s-stats '((A 2) (BOOM 1) (GET 2) (JOB 2) (NA 16) (SHA 3) (YIP 9) (WAH 1)))
(define 50s-tree (generate-huffman-tree 50s-stats))
(define 50s-msg '(Get a job Sha na na na na na na na na Get a job Sha na na na na na na na na Wah yip yip yip yip yip yip yip yip yip Sha boom))
(define 50s-msg-encoded (encode 50s-msg 50s-tree))

; How many bits are required for the encoding? What is the smallest number of bits that would be needed to encode this song if we used a fixed-length code for the eight-symbol alphabet?

(assert 50s-msg-encoded '(1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 1 0 1 1))
(assert (length 50s-msg-encoded) 84)

; If we're going to use fixed-width encoding for alphabet with 8 symbols then we'll have to encode each symbol with at least 3 bits (2 ^ 3 = 8 >= 8 symbols).
(assert (* 3 (length 50s-msg)) 108)
; As we can see, for this message variable-length encoding allows us to encode message more effectively, using only 84/108 ~ 78% bits of most effective fixed-length encoding.
