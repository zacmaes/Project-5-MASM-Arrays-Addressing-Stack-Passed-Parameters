TITLE Project Five: Arrays, Addressing, Stack Passed Params     (Proj5_maesz.asm)

; Author: Zachary Maes
; Last Modified: August 4th, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 5               Due Date: August 7th, 2022
; Description: 


; PROGRAM DESCRIPTION FROM CANVAS

; 1. Introduce the program

; 2. Declare global constants with initial sizes ( ARRAYSIZE=200, LO=15, and HI=50.)
;		-Generate ARRAYSIZE random integers in the range from LO to HI (Inclusive)
;		-Store these random integers in consecutive elements of array randArray.
;		-Hint: Call Randomize once in main to generate a random seed. Later, use RandomRange to generate each random number.
;					HI - (LO - 1) into EAX to get EAX, 36... returned random in range [0 - 35 inc.]...add LO [15] to the random val in EAX when done.

; 3. Display the list of integers before sorting, 20 numbers per line with one space between eah value.

; 4. Sort the list in ascending order (smallest first)

; 5. Calculate and display the median value of the sorted randArray, rounded to the nearest integer. (USING Round half up rounding described in Canvas) 

; 6. Display the sorted randArray, 20 numbers per line with one space between each value. Use (not a complete sentance in canvas...)

; 7. generate an array counts which holds the number of times each value in the range [LO, HI] is ssen in randArray, 
;		even if the number of times a value is seen is zero.
;	    For example check canvas...also report 0 count as a 0 in the array

; 8. Display the array counts, 20 numbers per line with one space between each value.



; PROGRAM REQUIREMENTS FROM CANVAS

; 1. The program must be constructed using procedures. Required procedures listed below:
;		a. main
;			input parameters: N/A
;		   output parameters: N/A

;		b. introduction
;			input parameters: intro1 (reference), intro2 (reference), ...etc if needed
;		   output parameters: N/A

;       c. fillArray
;			input parameters: N/A
;		   output parameters: someArray (reference)
;						Note: LO, HI, ARRAYSIZE will be used as globals within this procedure

;		d. sortList
;			input parameters: 
;		   output parameters:

;		e. exchangeElements
;			input parameters:
;		   output parameters:

;		f. displayMedian
;			input parameters:
;		   output parameters:

;		g. displayList
;			input parameters:
;		   output parameters:

;		h. countList
;			input parameters:
;		   output parameters:
;
;
;
;
;
;
;

INCLUDE Irvine32.inc
; (insert macro definitions here)
; (insert constant definitions here)

ARRAYSIZE = 200
LO        = 15
HI        = 50

.data
; (insert variable definitions here)

;INTRODUCTION DATA
greeting		BYTE	"Welcome to Project Five: Arrays, Addressing, Stack Passed Params by Zachary Maes!",0
description_1   BYTE	"This program will do something akin to magic... The programmer WILL CHANGE THIS DESCRIPTION LATER ON!!!",0



; DISPLAY DATA
unsorted_message    BYTE    "Your unsorted random numbers:",0
median_message      BYTE    "The median value of the array: ",0
sorted_message      BYTE    "Your sorted random numbers:",0
list_message        BYTE    "Your list of instances of each generated number, starting with the smallest value:",0

; FAREWELL DATA
farewell_1          BYTE    "If you have made it this far, congratulations! Thanks for reading my program, goodbye!",0

.code
main PROC
; (insert executable instructions here)

	call introduction
	call fillArray
	call sortList
	call exchangeElements
	call displayMedian
	call displayList
	call countList
	call farewell			; My additional procedure

	Invoke ExitProcess,0	; exit to operating system
main ENDP
; (insert additional procedures here)

END main
