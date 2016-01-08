; (load "nqueens_scheme.rkt")

(#%require (only racket/base random))
(#%require (only racket/base current-inexact-milliseconds))





(define steps 0)

(define (check-diagonals vector r c)
	(+ (+ (up_left vector r c) (up_right vector r c) ) (+ (down_left vector r c) (down_right vector r c) ) )
)

(define (up_left vector r c)

	(if (and (> r -1)(> c -1))
	    (if (= (vector-ref vector c) r)
	        (+ (up_left vector (- r 1) (- c 1)) 1)
	        (up_left vector (- r 1) (- c 1))
	    )
	    -1
	)
)

(define (down_left vector r c)

	(if (and (< r (vector-length vector))(> c -1))
	    (if (= (vector-ref vector c) r)
	        (+ (down_left vector (+ r 1) (- c 1)) 1)
	        (down_left vector (+ r 1) (- c 1))
	    )
	    -1
	)
)

(define (up_right vector r c)

	(if (and (> r -1)(< c (vector-length vector)))
	    (if (= (vector-ref vector c) r)
	        (+ (up_right vector (- r 1) (+ c 1)) 1)
	        (up_right vector (- r 1) (+ c 1))
	    )
	    -1
	)
)

(define (down_right vector r c)

	(if (and (< r (vector-length vector)) (< c (vector-length vector)))
	    (if (= (vector-ref vector c) r)
	        (+ (down_right vector (+ r 1) (+ c 1)) 1)
	        (down_right vector (+ r 1) (+ c 1))
	    )
	    -1
	)
)

; seems to work
; only call on a queen's r and c!!!
(define (check-rows vector r c)

	(do
		(
			(
				i ; iterate through the columns
				0
				(+ i 1)
			)

			(
				total
				0
				;(if (= r (vector-ref vector 0))
		  ;  		1
		  ;  		0
		  ;  	)
				(if (= r (vector-ref vector i))
		    		(+ total 1)
		    		total
		    	)

			)

		)

		(
			(= i (vector-length vector) )
			(- total 1) ; dont count self
		)
		;body
		;(display total)
		;(display " ")
		;(display i)
		;(newline)
	)
)


(define (check-columns vector r c)
	0 ; will only ever be 1 queen per column
)

; not ready
(define (num-threats vector)	
; for each queen
	(do
		(
			(
				c
				0
				(+ c 1)
			)

			;(
			;	r
			;	(vector-ref vector 0)
			;	;(and (vector-ref vector c) (display "c is ") (display c) (newline))
			;	(vector-ref vector c)
			;)

			(
				total
				0
				(if (= (vector-ref vector c) -1)
				   total
				   (+ total (+(+(check-columns vector (vector-ref vector c) c) (check-rows vector (vector-ref vector c) c)) (check-diagonals vector (vector-ref vector c) c)) )
				)
				

			)

		)

		(
			(= c (vector-length vector))
			(/ total 2)
			;(display r)
			;(display " ")
			;(display c)
			;(display " ")
			;(display total)
			;(display " ")
			;;(display (vector-ref vector c))
			;(newline)
		)



		; body

		;(display r)
		;(display " ")
		;(display c)
		;(display " ")
		;(display total)
		;(display " ")
		;(display (vector-ref vector c))
		;(newline)
		
	)
)

(define (display-board vector)

	(display "board:")
	(newline)

	(do
		(
			(
				r      ; for the rows
				0
				(+ r 1)
			)

		)

		(
			(= r (vector-length vector) )
			(newline)
		)

		; body

		(do
			(
				(
					c
					0
					(+ c 1)
				)
			)

			(
				(= c (vector-length vector) )
				(newline)
			)

			; body

			(if (= r (vector-ref vector c))
			    (display "1 ")
			    (display "0 ")
			)


		)

	)

)

(define (nq-bt bool n)

	(define board (make-vector n -1))
	;(display-board board)
	;(define steps 0)

	(backtrack bool board n 0)

	(if (equal? bool #t)
	    (display-board board)
	)
	
	(begin
		(display board)
		(newline)	
		(display "number of steps: ")
		(display steps)
		(newline)
		(newline)
		(set! steps 0)
		board
	)

)

(define (nq-bt_timed_test bool n)

	(define board (make-vector n -1))
	;(display-board board)
	;(define steps 0)
	(begin (backtrack bool board n 0) steps)

)


; extra credit, finds all the board solutions
(define (backtrack-all-sol bool board n column)

	(define saved-board board)

	; if done:
	(if (= column n)
	    (display-board board)
		

	

		(do
			(
				(
					; iterate
					row
					0
					(+ row 1)
				)
			)

			(
				;end?
				(= row n)
				#f
			)

			;body

			; make a move (put/move a queen in)
			(vector-set! board column row) ; set vector[column] = row
			; this will never get out of bounds, because the end check prevents it


			(if (= (num-threats board) 0)

				(if (backtrack-all-sol bool board n (+ column 1)) ; recurse if 0 threats
				    #t
				    (reset-board board column)
				)

			    
			    ; ? do nothing ?
			)

		)
	




	) ; end of first if

)

(define (backtrack bool board n column)

	(define saved-board board)
	(define return-bool #f)

	; if done:

	(if (= column n)
	    (set! return-bool #t)
	)
	

	(do
		(
			(
				; iterate
				row
				0
				(+ row 1)
			)
		)

		(
			;end?
			(or (= row n) (equal? return-bool #t))
			return-bool
		)

		;body

		(set! steps (+ steps 1))
		;(display steps)
		;(display " ")
		; make a move (put/move a queen in)

		(vector-set! board column row) ; set vector[column] = row
		; this will never get out of bounds, because the end check prevents it WRONG lol


		(if (= (num-threats board) 0)

			(if (equal? (backtrack bool board n (+ column 1)) #t) ; recurse if 0 threats
			    (set! return-bool #t)
			    (reset-board board column)
			)

		    
		    ; ? do nothing ?
		)

	)

)

; deletes all the queens to the left of the column-th column
(define (reset-board board column)
	(do
		(
			(
				i
				(+ column 1)
				(+ i 1)
			)

		)

		(
			(= i (vector-length board))
			board
		)

		(vector-set! board i -1)


	)
)





;****************************************************************************************************






;*********
; If two queens would attack from the same direction (row, or diagonal) then the conflict is only counted once.





(define (nq-mc bool n)

	(define board (make-vector n -1))

	(greedy-make-board board n)

	;(display-board board)

	(min-conflicts board n)

	(if (equal? bool #t)
	    (display-board board)
	)

	(begin
		;(display board)
		(newline)	
		(display "number of steps: ")
		(display steps)
		(newline)
		(newline)
		(set! steps 0)
		board
	)

)

(define (nq-mc_timed_test bool n)

	(define board (make-vector n -1))
	(greedy-make-board board n)
	;(display-board board)
	;(define steps 0)
	(begin (min-conflicts board n) steps)

)

;greedily place queens to minimize conflicts.
(define (greedy-make-board board n)
; similar to backtrack, but no backtracking
	;(define randlist (vector 0))

	(do
		(
			(
				;iterate through the columns
				c
				0
				(+ c 1)
			)
		)

		(
			;end?
			(= c n)
			#t

		)

		;body
		;(set! randlist (get-min-conflicts board n c)) ; a vector

		;(display (get-min-conflicts board n c))

		(vector-set! board c (get-min-conflicts board n c)) ; put a queen in a min spot

	)

	;(display-board board)
)


(define (min-conflicts board n)

	(do
		(
			(
				; pick a random column each iteration for reassignment
				randcolumn
				(random n)
				(random n) ; only goes up to n-1
			)
		)

		(
			; end?
			(= (num-threats board) 0)
			;(begin (display-board board) board)
			board
		)

		; body

		(if (>= steps (* n 30))
		    (and (set! board (make-vector n -1)) (greedy-make-board board n) (set! steps 0))

		)
		

		(set! steps (+ steps 1))
		(vector-set! board randcolumn (get-min-conflicts board n randcolumn))

	)

)


; returns a random min conflict from column c
(define (get-min-conflicts board n c)

	(define minimum-threat -1)

	; find the minimum

	(do
		(
			(
				;iterate
				r
				0
				(+ r 1)
			)
			(
				minimum
				n
				(if (> minimum (num-threats-single board r c))
				    (num-threats-single board r c)
				    minimum
				)
			)
		)

		(
			;end?
			(= r n)
			(set! minimum-threat minimum)
		)

		;body
		

	)


	;********

	; find if there are duplicates of the minimum



	(do
		(
			(
				;iterate
				r
				0
				(+ r 1)
			)
			(
				thelist
				'()
				(if (= (num-threats-single board r c) minimum-threat)
				    (append thelist (list r))
				    thelist
				)

			)
		)

		(
			;end?
			(= r n)
			(vector-ref (list->vector thelist) (random (length thelist)))
			;thelist ; for testing purposes
		)

		;body
		

	)

)

; should be able to check from anywhere, not only from a queen, but does it?
(define (num-threats-single board r c)

	(+ 
		(if (= r (vector-ref board c))
		    (min (check-rows board r c) 1)
		    (min (check-rows-nonq board r c) 1)
		)
		
		(check-diagonals-capped board r c)  
	)
)

(define (check-rows-nonq vector r c)

	(do
		(
			(
				i ; iterate through the columns
				0
				(+ i 1)
			)

			(
				total
				0
				;(if (= r (vector-ref vector 0))
		  ;  		1
		  ;  		0
		  ;  	)
				(if (= r (vector-ref vector i))
		    		(+ total 1)
		    		total
		    	)

			)

		)

		(
			(= i (vector-length vector) )
			total
		)
		;body
		;(display total)
		;(display " ")
		;(display i)
		;(newline)
	)
)

(define (check-diagonals-capped vector r c)
; if checking for a queen (r != -1) need to subtract 1, so call the old methods
	(if (= r (vector-ref vector c))

		(+ 
			(min (+ (up_left vector r c) (down_right vector r c) ) 1)
			(min (+ (down_left vector r c) (up_right vector r c) ) 1)
		)

		(+ 
			(min (+ (up_left-nonq vector r c) (down_right-nonq vector r c) ) 1)
			(min (+ (down_left-nonq vector r c) (up_right-nonq vector r c) ) 1) 
		)



	)
)

(define (up_left-nonq vector r c)

	(if (and (> r -1)(> c -1))
	    (if (= (vector-ref vector c) r)
	        (+ (up_left-nonq vector (- r 1) (- c 1)) 1)
	        (up_left-nonq vector (- r 1) (- c 1))
	    )
	    0
	)
)

(define (down_left-nonq vector r c)

	(if (and (< r (vector-length vector))(> c -1))
	    (if (= (vector-ref vector c) r)
	        (+ (down_left-nonq vector (+ r 1) (- c 1)) 1)
	        (down_left-nonq vector (+ r 1) (- c 1))
	    )
	    0
	)
)

(define (up_right-nonq vector r c)

	(if (and (> r -1)(< c (vector-length vector)))
	    (if (= (vector-ref vector c) r)
	        (+ (up_right-nonq vector (- r 1) (+ c 1)) 1)
	        (up_right-nonq vector (- r 1) (+ c 1))
	    )
	    0
	)
)

(define (down_right-nonq vector r c)

	(if (and (< r (vector-length vector)) (< c (vector-length vector)))
	    (if (= (vector-ref vector c) r)
	        (+ (down_right-nonq vector (+ r 1) (+ c 1)) 1)
	        (down_right-nonq vector (+ r 1) (+ c 1))
	    )
	    0
	)
)












;***********************************************************************************************

(define (nq-mrv bool n)

	

	(define board (make-vector n -1))
	(define columns-left (make-vector n 1))
	;(display-board board)
	;(define steps 0)

	(backtrack-mrv bool board n 0)

	(if (equal? bool #t)
	    (display-board board)
	)
	
	(begin
		;(display board)
		(newline)	
		(display "number of steps: ")
		(display steps)
		(newline)
		(newline)
		(set! steps 0)
		board
	)

)




(define (backtrack-mrv bool board n column)

	(define saved-board board)
	(define return-bool #f)



	; if done:

	(if (= column n);(and (= column n) (check-if-done board n) )
		; recurse on backtrack.mrv?
	    (set! return-bool #t)
	    (if (= 0 (num-legal board column))
	    	#f;(and (display-board board) (display "column: ") (display column) (display " least legal: ") (display (get-least-legal-column board column)) (newline))
		)
	)

	;(if (equal? (vector 0 2 4 1 -1 -1) board)
	;    (and (display-board board) (display "column: ") (display column) (display " least legal: ") (display (get-least-legal-column board column)) (newline))
	;)


	

	(do
		(
			(
				; iterate
				row
				0
				(+ row 1)
			)
		)

		(
			;end?
			(or (= row n) (equal? return-bool #t))
			return-bool
		)

		;body

		(set! steps (+ steps 1))
		;(display steps)
		;(display " ")
		; make a move (put/move a queen in)

		(vector-set! board column row) ; set board[column] = row
		; this will never get out of bounds, because the end check prevents it WRONG lol


		(if (= (num-threats board) 0)

			(if  (equal? (backtrack-mrv bool board n (get-least-legal-column board 0)) #t) ; recurse if 0 threats
			    (set! return-bool #t)
			    (reset-board board column)
			)

		    
		    ; ? do nothing ?
		)

	)

)

; find the next free column

(define (next-free-col board i)

	(if (= i (vector-length board))
	    (vector-length board)
	)

	(if (= -1 (vector-ref board i))
	    i
		((next-free-col board (+ i 1)))
	)

)

(define (check-if-done board n)

	(define returnval #t)

	(do
		(
			(
				i
				0
				(+ i 1)
			)
		)

		(
			;end?
			(= i (- n 1))
			returnval
		)

		;(display "i")
		(if (= (vector-ref board i) -1)
		    (set! returnval #f)
		)

	)

)

(define (get-legal-columns board n)

	(list->vector (derpderp board n 0))

)

(define (derpderp board n i)

	(if (= i n)
	    '()
	    (if (= -1 (vector-ref board i))
	    	(append (list i) (derpderp board n (+ i 1)))
			(derpderp board n (+ i 1))
		)
	)

	

)

(define (get-least-legal-column board start-column) ; start-column = column to start from, inclusive

	(define derp (get-legal-columns board (vector-length board)))

	(if (= (vector-length derp) 0)
	    -1
	)

	(define banana (vector-ref derp 0))

	(do
		(
			(
				i
				0
				(+ i 1)
			)

			(
				c
				(vector-ref derp 0)
				(vector-ref derp i)
			)
			(
				trump
				banana
				(if (> (num-legal board trump) (num-legal board c))
				    (num-legal board c)
					trump    
				)
			)
		)

		(
			(= i (vector-length derp))
			trump
		)


	)



)

(define (num-legal board column)

	;(if (= column -1)
	;	(vector-length board)
	;)

	(do
		(
			(
				r
				0
				(+ r 1)
			)
			(
				total
				0
				(if (= (num-threats-single board r column) 0)
				    (+ total 1)
				    total
				)
			)
		)
		(
			;end
			(= r (vector-length board))
			total
		)

		;body

	)

)



(define (nq-mrv_timed_test bool n)
	(define board (make-vector n -1))

	(begin (backtrack-mrv bool board n 0) steps)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DATA COLLECTION

(define (test_nqueens data method num)

	(if (equal? data avg_time) (and (display method) (newline) (display "size ") (display "avg_milliseconds") (newline)))
    (if (equal? data avg_steps) (and (display method) (newline) (display "size ") (display "avg_steps") (newline)))


	(do

		(

			(
				i
				4
				(+ i 1)
			)

		)

		(
			(= i (+ num 1))

		)

		(display i)
		(display "    ")
		(display (data method i))
		(newline)


	)

)

(define (avg_steps method n)

	(do

		(

			(
				i
				1
				(+ i 1)
			)

			(
				total
				0
				(+ total (exact->inexact (method n)))
			)

		)

		(
			(= i 11)
			(/ total 10)

		)

		;(display (exact->inexact (do_the_thing i))) (newline)

	)

)

(define (avg_time method n)

	(do

		(

			(
				i
				1
				(+ i 1)
			)

			(
				total
				0
				(+ total (exact->inexact (method n)))
			)

		)

		(
			(= i 10)
			(exact->inexact (/ total 10))

		)


		;(display (exact->inexact (do_the_thing i))) (newline)


	)

)

(define (timed_nq-bt n)

	(define time1 (current-inexact-milliseconds))
	
	(begin 

		(nq-bt_timed_test #f n)
		(set! steps 0)
		(- (current-inexact-milliseconds) time1)

	)
)

(define (timed_nq-mc n)

	(define time1 (current-inexact-milliseconds))
	
	(begin 

		(nq-mc_timed_test #f n)
		(set! steps 0)
		(- (current-inexact-milliseconds) time1)

	)
)

(define (timed_nq-mrv n)

	(define time1 (current-inexact-milliseconds))
	
	(begin 

		(nq-mrv_timed_test #f n)
		(set! steps 0)
		(- (current-inexact-milliseconds) time1)

	)
)

(define (counted_nq-bt n)

	(nq-bt_timed_test #f n)

	(define saved-steps steps)


	(begin 
		(set! steps 0)
		saved-steps
	)

)

(define (counted_nq-mrv n)

	(nq-mrv_timed_test #f n)

	(define saved-steps steps)


	(begin 
		(set! steps 0)
		saved-steps
	)

)

(define (counted_nq-mc n)

	(nq-mc_timed_test #f n)

	(define saved-steps steps)

	(begin 
		(set! steps 0)
		saved-steps
	)

)



;(avg_nq timed_nq-bt 17) ; run 10 trials of backtrack size 17
;(avg_nq timed_nq-mc 200) ; run to trials of min conflict size 100
;(avg_nq timed_nq-mrv 200)

;(test_nqueens avg_time timed_nq-mc 400)
;(test_nqueens avg_steps counted_nq-bt 25)
;(test_nqueens avg_steps counted_nq-mc 100)

;(nq-bt #t 17)





;(nq-mc #f 20)

;(define testboard (make-vector 15 -1))

;(backtrack-all-sol #t testboard 15 0)

;(nq-mrv #t 6)

;(nq-mc #t 10)



















