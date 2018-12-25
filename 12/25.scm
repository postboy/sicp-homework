; Exercise 1.25.  Alyssa P. Hacker complains that we went to a lot of extra work in writing expmod. After all, she says, since we already know how to compute exponentials, we could have simply written

(define (expmod base exp m)
  (remainder (fast-expt base exp) m))

; Is she correct? Would this procedure serve as well for our fast prime tester? Explain.

; Indeed, theoretically we could use this naive implementation, but it definitely would work much slower than implementation from 1.24. Maybe it would work so much slower that this implementation would be just unusable for our numbers. As note 46 says, "This technique is useful because it means we can perform our computation without ever having to deal with numbers much larger than m." Bigger numbers mean bigger time and memory to make computations on them.

; Furthermore, my assumtion that this implementation could be used as well as previous is based on prerequisite that MIT/GNU Scheme implements bignum arithmetic under the hood. If it wouldn't, I suppose that many (if not all) of our computations from 1.24 could be done with 64-bit wide integers. By contrast, this implementation clearly requires bignum arithmetic for numbers from 1.24.
