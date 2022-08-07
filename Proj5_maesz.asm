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
one_space           BYTE    " ",0


; ARRAY
randArray			DWORD   ARRAYSIZE DUP(?)	; DUP declaration, empty Array of ARRAYSIZE 

; FAREWELL DATA
farewell_1          BYTE    "If you have made it this far, congratulations! Thanks for reading my program, goodbye!",0



.code
main PROC
; (insert executable instructions here)
	CALL Randomize				 ; Initialize starting seed vaue of RandomRange procedure
	
	PUSH OFFSET greeting		 ; offset +4
	PUSH OFFSET description_1    ; offset +4
	CALL introduction			 ; return address +4

	PUSH OFFSET randArray        ; pass address of element 1 in randArray
	PUSH ARRAYSIZE
	PUSH LO
	PUSH HI
	CALL fillArray

	; TEST DISPLAY IN MAIN---DELETE THIS---THIS bWorks!!!
	CALL CrLf
	MOV  ESI, OFFSET randArray
	MOV  ECX, LENGTHOF randArray
	_PrintArrTest:
		MOV EAX, [ESI]
		CALL WriteDec

		MOV EDX, OFFSET one_space
		CALL WriteString

		ADD ESI, 4
		
		LOOP _PrintArrTest
	CALL CrLf

	PUSH OFFSET unsorted_message ; offset +4
	CALL displayList			 ; displayList 1st call for unsorted



;	CALL sortList

	PUSH OFFSET sorted_message   ; offset +4
	CALL displayList			 ; displayList 2nd call for sorted

	PUSH OFFSET list_message     ; offset +4
	CALL displayList		     ; displayList 3rd call for list_message

;  OTHER REQUIRED PROCS
;	CALL exchangeElements
;	CALL displayMedian
;	CALL displayList			; this procedure is called 3 times to display the various arrays
;	CALL countList

    PUSH OFFSET farewell_1	;offset +4
	CALL farewell			; My additional procedure, stack return address +4

	Invoke ExitProcess,0	; exit to operating system
main ENDP
; (insert additional procedures here)

; ---------------------------------------------------------------------------------
; Name: introduction
;
; Description: 
;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;
; Returns:
; ---------------------------------------------------------------------------------

introduction PROC
	; Set up Base pointer
	PUSH EBP		; +4
	MOV  EBP, ESP	; Base Pointer
	PUSH EDX
	; ...

	MOV  EDX, [EBP+12] 
	CALL WriteString
	CALL CrLf
	CALL CrLf

	MOV  EDX, [EBP+8]
	CALL WriteString
	CALL CrLf
	CALL CrLf

	;...
	POP EDX
	POP EBP
	RET 8
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: fillArray
;
; Description: 
;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;
; Returns:
; ---------------------------------------------------------------------------------

fillArray PROC
	; Set up Base pointer
	PUSH EBP		; +4
	MOV  EBP, ESP	; Base Pointer

	PUSH EAX        ; Preserve used registers
	PUSH ECX
	PUSH EDI
	; ...
	MOV  ECX, [EBP+16] ; List length into ECX
	MOV  EDI, [EBP+20] ; Address of list into EDI

	;...LOOP...
	_fillLoop:
		; GENERATE RANDOM NUM
		MOV EAX, [EBP+8]  ; HI from stack into EAX
		SUB EAX, [EBP+12] ; HI - LO
		INC EAX			  ; add 1 to EAX to get upper limit(exclusive) for randomRange	
		CALL RandomRange  ; generates 0 - EAX (exclusive), saves random val in EAX
		ADD EAX, [EBP+12] ; Add LO value to EAX random num to get random within HI-LO range

		; FILL ARRAY
		MOV [EDI], EAX	  ; overwrite value in memory pointed to by EDI
		ADD EDI, 4		  ; Hardcoded 4 (DWORD) to increment to next index in Array
		LOOP _fillLoop

	;...
	POP EDI
	POP ECX
	POP EAX
	POP EBP
	RET 16
fillArray ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
;
; Description: 
;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;
; Returns:
; ---------------------------------------------------------------------------------

displayList PROC
	; Set up Base pointer
	PUSH EBP		; +4
	MOV  EBP, ESP	; Base Pointer
	PUSH EDX        ; preserve edx
	; ...

	MOV  EDX, [EBP+8] 
	CALL WriteString
	CALL CrLf
	CALL CrLf

	; ...
	; Display the list of ints here

	POP	EDX
	POP	EBP
	RET 4
displayList ENDP



; ---------------------------------------------------------------------------------
; Name: farewell
;
; Description: 
;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;
; Returns:
; ---------------------------------------------------------------------------------

farewell PROC
	; Set up Base pointer
	PUSH EBP		; +4
	MOV  EBP, ESP	; Base Pointer
	PUSH EDX        ; preserve edx
	; ...

	MOV  EDX, [EBP+8] 
	CALL WriteString
	CALL CrLf
	CALL CrLf

	POP	EDX
	POP	EBP
	RET 4
farewell ENDP

END main

; DELETE THIS!!!
; EXAMPLE PYTHON INSERTION SORT
; def insertion_sort(a_list):
;     """
;     Insertion sort algorithm that sorts a_list in ascending order.
;     """
;     for index in range(1, len(a_list)):
;         value = a_list[index]
;         pos = index - 1
;         while pos >= 0 and a_list[pos] > value:
;             a_list[pos + 1] = a_list[pos]
;             pos -= 1
;         a_list[pos + 1] = value