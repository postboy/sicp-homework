; Exercise 3.80.  A series RLC circuit consists of a resistor, a capacitor, and an inductor connected in series, as shown in figure 3.36. If R, L, and C are the resistance, inductance, and capacitance, then the relations between voltage (v) and current (i) for the three components are described by the equations <...> and the circuit connections dictate the relations <...>. Combining these equations shows that the state of the circuit (summarized by vC, the voltage across the capacitor, and iL, the current in the inductor) is described by the pair of differential equations <...>. The signal-flow diagram representing this system of differential equations is shown in figure 3.37.
; Write a procedure RLC that takes as arguments the parameters R, L, and C of the circuit and the time increment dt. In a manner similar to that of the RC procedure of exercise 3.73, RLC should produce a procedure that takes the initial values of the state variables, vC0 and iL0, and produces a pair (using cons) of the streams of states vC and iL. Using RLC, generate the pair of streams that models the behavior of a series RLC circuit with R = 1 ohm, C = 0.2 farad, L = 1 henry, dt = 0.1 second, and initial values iL0 = 0 amps and vC0 = 10 volts.

(load "77.scm")

(define (RLC R L C dt)
  (define (internal v0 i0)
    (define v (integral (delay dv) v0 dt))
    (define i (integral (delay di) i0 dt))
    (define dv (scale-stream i (- (/ 1 C))))
    (define di (add-streams (scale-stream v (/ 1 L)) (scale-stream i (- (/ R L)))))
    (cons v i))
  internal)

(define RLC1 (RLC 1 1 0.2 0.1))
(define result (RLC1 10 0))
(assert (stream-head (car result) 10)
	'(10 10 9.5 8.55 7.220000000000001 5.5955 3.77245 1.8519299999999999 -0.0651605000000004 -1.8831384500000004))
(assert (stream-head (cdr result) 10)
	'(0 1. 1.9 2.66 3.249 3.6461 3.84104 3.834181 3.6359559 3.2658442599999997))
