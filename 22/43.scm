; Exercise 2.43.  Louis Reasoner is having a terrible time doing exercise 2.42. His queens procedure seems to work, but it runs extremely slowly. (Louis never does manage to wait long enough for it to solve even the 6×6 case.) When Louis asks Eva Lu Ator for help, she points out that he has interchanged the order of the nested mappings in the flatmap, writing it as

; (flatmap
;  (lambda (new-row)
;    (map (lambda (rest-of-queens)
;           (adjoin-position new-row k rest-of-queens))
;         (queen-cols (- k 1))))
;  (enumerate-interval 1 board-size))

; Explain why this interchange makes the program run slowly. Estimate how long it will take Louis's program to solve the eight-queens puzzle, assuming that the program in exercise 2.42 solves the puzzle in time T.

; The program run slowly because per (queen-cols k) call we evaluate:
; - in original version: function (enumerate-interval 1 board-size) (length (queen-cols (- k 1))) times;
; - in modified version: function (queen-cols (- k 1)) (length (enumerate-interval 1 board-size)) = board-size times.

; Both enumerate-interval and queen-cols are recursive, but enumerate-interval is cheap call (with easy logic inside) while queen-cols is expensive (with heavy machinery inside). That's the reason why topmost calls take different times.

; Original function consists of following calls:
; (queen-cols 8), each of which is
; (queen-cols 7), each of which is
; ...
; (queen-cols 0)

; Modified function consists of following calls:
; (queen-cols 8), each of which is
; 8 * (queen-cols 7), each of which is
; 8 * 8 * (queen-cols 6), each of which is
; ...
; 8^8 * (queen-cols 0)

; I suppose that modified program should take time around 8^8*T.
