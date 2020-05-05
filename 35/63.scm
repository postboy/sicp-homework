; Exercise 3.63.  Louis Reasoner asks why the sqrt-stream procedure was not written in the following more straightforward way, without the local variable guesses:

(define (sqrt-stream x)
  (cons-stream 1.0
               (stream-map (lambda (guess)
                             (sqrt-improve guess x))
                           (sqrt-stream x))))

; Alyssa P. Hacker replies that this version of the procedure is considerably less efficient because it performs redundant computation. Explain Alyssa's answer. Would the two versions still differ in efficiency if our implementation of delay used only (lambda () <exp>) without using the optimization provided by memo-proc (section 3.5.1)?

; Alyssa is concerned about recursive part of the definition. With old procedure version, we don't need any extra streams to compute next element of the stream because we get previous elements directly from the stream itself. With Louis' version we instead get them from another temporary stream created just for that task. What's worse, it happens recursively: to get third element, we need extra stream for second element; to get it, we need extra stream for first element. Without memo-proc optimization, two versions would be equally inefficient because old procedure version would recreate the list on any occasion too.
