; Exercise 2.15.  Eva Lu Ator, another user, has also noticed the different intervals computed by different but algebraically equivalent expressions. She says that a formula to compute with intervals using Alyssa's system will produce tighter error bounds if it can be written in such a form that no variable that represents an uncertain number is repeated. Thus, she says, par2 is a ``better'' program for parallel resistances than par1. Is she right? Why?

; Yes, I think that she's right.

; Let's consider any operation on intervals in our system. System designed in such way that result's width is no better than widest width of it's arguments, and often it's even wider. It means that in general any operation on intervals produces extra width, so more operations in formula means more width and more percents in final result. The obvious exception is the operations where at least one argument is exact -- those do not "degrade" our numbers via their widening. Looks like avoiding repeated inexact values in formulas indeed produces less "degrading" operations.

; First formula contains multiplication, addition and division, and both of the arguments in each operation is in general inexact, so we have three "degrading" operations. Second formula contains three divisions and addition, but among them only addition is "degrading". As a consequence, second formula gives more exact result.
