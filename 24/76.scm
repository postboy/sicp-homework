; Exercise 2.76.  As a large system with generic operations evolves, new types of data objects or new operations may be needed. For each of the three strategies -- generic operations with explicit dispatch, data-directed style, and message-passing-style -- describe the changes that must be made to a system in order to add new types or new operations. Which organization would be most appropriate for a system in which new types must often be added? Which would be most appropriate for a system in which new operations must often be added?

; Let's clarify the terms: in the following text logic function is called "method", while function in terms of code is called "function".

; Generic operations with explicit dispatch:
; - to add new type, change all existing method functions to support it;
; - to add new method, write new function dealing with all existing types.
; Most appropriate for a system in which new operations must often be added.

; Message-passing-style:
; - to add new type, write new function dealing with all existing methods;
; - to add new method, change all existing type functions to support it.
; Most appropriate for a system in which new types must often be added.

; Data-directed style:
; - to add new type, write and register new functions implementing all existing methods for this type;
; - to add new method, write and register new functions implementing this method for all existing types.
; If functions are already grouped by type then situation is similar to message-passing-style; if by method then situation is similar to generic operations with explicit dispatch; otherwise system is just a big mess! In principle, we can try to add new type or new method independently of old code, but this will produce code debt, so it's a bad idea.
; Note that with this approach we have to register new functions.
