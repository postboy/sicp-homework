; Exercise 2.48.  A directed line segment in the plane can be represented as a pair of vectors -- the vector running from the origin to the start-point of the segment, and the vector running from the origin to the end-point of the segment. Use your vector representation from exercise 2.46 to define a representation for segments with a constructor make-segment and selectors start-segment and end-segment.

; We already solved this problem in 2.2. Segments there was constructed from points instead of vectors, but for this functions underlying data structures doesn't matter as long as we use this functions consistently.

(cd "../21")
(load "2.scm")
(cd "../22")
