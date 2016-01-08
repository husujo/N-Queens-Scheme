Hunter Johnston		NQNEENS		12/2/15


Description of Problem

	Given a NxN chessboard, place N queens on it such that no queen threatens another. Use multiple techniques.

Implementation

	Backtracking: can handle up to around size 19 in 20 seconds
	min conflicts: can handle up to around size 400 in 20 seconds
	backtracking+minimum remaining value: handled around 300 until i discovered it was broken and incorrect...

Files

	nqueens_scheme.rkt: the scheme source file. run with "plt-r5rs nqueens_scheme.rkt" 
	WRITEUP.rtf: the text edit version of the writeup
	WRITEUP.pdf: A more detailed analysis
	README: this file

Problems

	I couldn't fix my MRV method, it had some -1's in the final board vector, which is wrong. It's because I can't get it to go back and deal with those un-dealt-with columns. Didn't finish in time.

Extra Credit

-nice data gathering methods, including: test_nqueens, avg_time, avg_steps, timed_nq-bt, counted_nq-bt, etc.

-I made an backtrack-all-sol method that returns all the solutions instead of just one (using backtracking)

-thorough attempt at mrv (nq-mrv)





