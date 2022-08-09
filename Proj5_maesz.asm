TITLE Project Five: Arrays, Addressing, Stack Passed Params     (Proj5_maesz.asm)

; Author: Zachary Maes
; Last Modified: August 4th, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 5               Due Date: August 7th, 2022
; Description: 



; DELETE THIS!!!
; EXAMPLE PYTHON BUBBLE SORT
;def bubble_sort(a_list):
    ;"""
    ;Bubble sort algorithm that sorts a_list in ascending order.
    ;"""
    ;for pass_num in range(len(a_list) - 1):
    ;    for index in range(len(a_list) - 1 - pass_num):
       ;     if a_list[index] > a_list[index + 1]:
     ;           temp = a_list[index]
     ;           a_list[index] = a_list[index + 1]
     ;           a_list[index + 1] = temp


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

ARRAYSIZE = 30
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


; ARRAYS
randArray			DWORD   ARRAYSIZE DUP(?)	; DUP declaration, empty Array of ARRAYSIZE
arrayLength			DWORD	LENGTHOF randArray  ; save length of randArray

countsArray         DWORD   (HI - LO + 1) DUP(?) ; set up counts array to store the final counted elements
countsArrLen		DWORD	LENGTHOF countsArray ; length of the the counts array for use in loop.

; FAREWELL DATA
farewell_1          BYTE    "If you have made it this far, congratulations! Thanks for reading my program, goodbye!",0



.code
main PROC
; (insert executable instructions here)
	CALL Randomize				 ; Initialize starting seed vaue of RandomRange procedure

	; ---
	
	PUSH OFFSET greeting		 ; offset +4
	PUSH OFFSET description_1    ; offset +4
	CALL introduction			 ; return address +4

	; ---

	PUSH OFFSET randArray        ; pass address of element 1 in randArray
	PUSH ARRAYSIZE
	PUSH LO
	PUSH HI
	CALL fillArray

	; ---

	PUSH OFFSET one_space		; push the space string
	PUSH OFFSET unsorted_message ; offset +4
	PUSH OFFSET randArray
	PUSH ARRAYSIZE
	; PUSH arrayType
	CALL displayList			 ; displayList 1st call for unsorted

	; ---

	PUSH OFFSET randArray
	CALL sortList

	; ---

	PUSH OFFSET one_space		; push the space string
	PUSH OFFSET sorted_message   ; offset +4
	PUSH OFFSET randArray
	PUSH ARRAYSIZE
	;PUSH arrayType
	CALL displayList			 ; displayList 2nd call for sorted

	; ---
	PUSH OFFSET median_message
	PUSH OFFSET randArray
	CALL displayMedian

	; ---
	PUSH OFFSET randArray
	PUSH OFFSET countsArray
	PUSH countsArrLen
	CALL countList


	; ---

	PUSH OFFSET one_space		; push the space string
	PUSH OFFSET list_message     ; offset +4
	PUSH OFFSET	countsArray			; ****** THIS WILL NEED TO BE CHANGED TO THE NUMS LIST EVENTUALLY *****
	PUSH countsArrLen
	;PUSH arrayType
	CALL displayList		     ; displayList 3rd call for list_message

	; ---


;  OTHER REQUIRED PROCS
;	CALL exchangeElements
;	CALL displayMedian
;	CALL displayList			; this procedure is called 3 times to display the various arrays
;	CALL countList

	; ---

    PUSH OFFSET farewell_1	;offset +4
	CALL farewell			; My additional procedure, stack return address +4

	Invoke ExitProcess,0	; exit to operating system
main ENDP
; (insert additional procedures here)

; ---------------------------------------------------------------------------------
; Name: introduction
;
; Description: 
; Introduces the 
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

	PUSHAD        ; Preserve used registers
	
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
	POPAD
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

	PUSHAD			; preserve all gp registers
	; ...

	MOV  EDX, [EBP+16] ; Write the message string
	CALL WriteString
	CALL CrLf

	; ...
	; Display the list of ints here
	MOV  EDI, [EBP+12]	; move randArray start ref to EDI
	MOV  ECX, [EBP+8]	; move ARRAYSIZE or countsArrLen to ECX counter
	_PrintArr:
		MOV EAX, [EDI]
		CALL WriteDec

		MOV EDX, [EBP+20]	; wrtie the one_space string
		CALL WriteString

		ADD EDI, 4
		
		LOOP _PrintArr
	
	CALL CrLf
	CALL CrLf

	POPAD		; restore all gp registers
	POP EBP
	RET 16
displayList ENDP


; ---------------------------------------------------------------------------------
; Name: sortList
;
; Description: 

; DELETE THIS!!!
; EXAMPLE PYTHON BUBBLE SORT
;def bubble_sort(a_list):
    ;"""
    ;Bubble sort algorithm that sorts a_list in ascending order.
    ;"""
    ;for pass_num in range(len(a_list) - 1):
    ;    for index in range(len(a_list) - 1 - pass_num):
       ;     if a_list[index] > a_list[index + 1]:
     ;           temp = a_list[index]
     ;           a_list[index] = a_list[index + 1]
     ;           a_list[index + 1] = temp

;
; Preconditions: 
;
; Postconditions:
;
; Receives:
;
; Returns:
; ---------------------------------------------------------------------------------

sortList PROC
	; Set up Base pointer
	PUSH EBP		; +4
	MOV  EBP, ESP	; Base Pointer
	
	PUSHAD			; preserve registers
	; ...

	MOV ECX, ARRAYSIZE      ; number of elements of randArray into ECX for decrementing the loop iteration counter

	_arrayLoop:
		PUSH ECX			; save register for loop count
		MOV EDI, [EBP+8] ; address of first element of randArray into EDI [or next incremented element after loop]

		_innerLoop:
			MOV EAX, [EDI]     ; move array element at EDI pointer to EAX register
			CMP [EDI+4], EAX   ; compare next index to previous index at this iteration of the bubble sort
			JGE _noExchange	   ; next is greater than or equal to previous so there is no exchage of values
			; CALL exchangeElements
			XCHG EAX, [EDI+4]
			MOV [EDI], EAX



		_noExchange:
			ADD EDI, 4			; increment EDI pointer
			LOOP _innerLoop

			POP ECX				; pop the _arrayLoop counter out of the stack
			LOOP _arrayLoop

	POPAD

	POP	EBP
	RET 4
sortList ENDP

; ---------------------------------------------------------------------------------
; Name: exchangeElements
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

;exchangeElements PROC
	; Set up Base pointer
	;PUSH EBP		; +4
	;MOV  EBP, ESP	; Base Pointer
	
	; ...





	
	;POP	EBP
	;RET
;exchangeElements ENDP


; ---------------------------------------------------------------------------------
; Name: displayMedian
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

displayMedian PROC
	; Set up Base pointer
	PUSH EBP		; +4
	MOV  EBP, ESP	; Base Pointer
	
	PUSHAD
	; ...

	MOV  EDX, [EBP+12] 
	CALL WriteString

	; ---
	; DIV instruction [EDX:EAX / EBX] ==> (EAX = Quotient) and (EDX = Remainder)
	MOV EAX, ARRAYSIZE		; Set low dividend
	MOV EDX, 0				; Clear the high dividend
	MOV EBX, 2				; Divide EDX:EAX by 2
	DIV EBX					; (EAX = Quotient) and (EDX = Remainder)

	CMP EDX, 0
	JE  _even
	JG  _odd

	_even:		; IF remainder is 0 (even)
		; DO SOMETHING HERE
		; EAX is the left middle, at this point
		
		MOV ECX, EAX ;set loop count for lower mid index in eax to ecx
		MOV EDI, [EBP+8]
		_evenLoop1:
			ADD EDI, 4
			LOOP _evenLoop1
	
		
		MOV EAX, [EDI]
		_evensDiv:
			ADD EAX, [EDI+4]
			MOV EDX, 0
			MOV EBX, 2
			DIV EBX		
		
		CMP EDX, 0			; if even--> eax is the quotient and median val, if odd--> add 1 before div and follow even rules after div
		JE  _finalEven
		JNE _addOneAndDivAgain

		_addOneAndDivAgain:
			MOV EAX, [EDI]
			ADD EAX, 1
			JMP _evensDiv

		_finalEven:
			CALL WriteDec
			CALL CrLf
			JMP _evenDone

			
	


			;JMP _final

	_odd:		; IF remainder is not 0 (odd)
		; Example: ARRAYSIZE = 21, 21/2 has remainder > 0
		;	-add 1 to arraysize (use arraysize in register first)
		;	-divide arraysize+1 by 2 to get the median index position
		;   -print the median index from the list
		MOV ECX, EAX     ; set loop counter
		MOV EDI, [EBP+8]
		_oddLoop:
			ADD EDI, 4
			LOOP _oddLoop
		JMP _finalOdd


	_finalOdd:
		MOV EAX, [EDI]
		CALL WriteDec
		CALL CrLf
	
	_evenDone:
	; ---

	CALL CrLf
	POPAD
	POP	EBP
	RET 8
displayMedian ENDP

; ---------------------------------------------------------------------------------
; Name: countList
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

countList PROC
	; Set up Base pointer
	PUSH EBP		; +4
	MOV  EBP, ESP	; Base Pointer
	PUSHAD        ; preserve registers
	; ...



	MOV ECX, [EBP+8]	; loop counter to countsArrLen
	MOV EDI, [EBP+16]   ; pointer to start of randArray index0
	MOV ESI, [EBP+12]	; pointer to start of countsArray index0
	MOV EDX, LO			; holds Lo and increments up 

	_countsArrLoop:
		MOV EBX, 0      ; value amount counter reset to 0
		
		_skipValReset:
			CMP [EDI], EDX
			JNE _inputValue
			JE  _sameValueHappened

		_sameValueHappened:
			ADD	EBX, 1	   ; add 1 to value counter
			ADD EDI, 4     ; inc edi pointer
			JMP _skipValReset

		_inputValue:
			MOV [ESI], EBX	
			ADD ESI, 4
			ADD EDX, 1
			LOOP _countsArrLoop   ; dec ecx

	POPAD
	POP	EBP
	RET 12
countList ENDP





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


; OLDE counList

; countList PROC
	; Set up Base pointer
;	PUSH EBP		; +4
;	MOV  EBP, ESP	; Base Pointer
;	PUSHAD        ; preserve registers
;	; ...
;
;
;
;	MOV ECX, ARRAYSIZE	; loop counter to arraysize
;	MOV ESI, [EBP+8]	; pointer to start of countsArray index0
;	MOV EDI, [EBP+12]   ; pointer to start of randArray index0
;	
;	;MOV EAX, [EDI]		; copy first array value at EDI pointer to EAX
;	MOV EBX, 0			; count for index of randArray
;	MOV EDX, LO			; holds Lo and increments up 
;
;	; not handling if a value at lo (or later on)... need to account for if values have zero instances
;	_checkVals:
;		; dont forget to stop the loop with HI when EDX reaches it...
;		CMP EDX, HI
;		JG  _endCountItter...
;
;		CMP [EDI], EDX		; compare randArray item to LO (+)
;		JNE _countZero
;		JE  _sameValueHappened
;
;	_countZero:
;		MOV [ESI], 0	
;		ADD ESI, 4
;		ADD EDX, 1
;		JMP _checkVals
;
;	_sameValueHappened:
;		ADD	EBX, 1	   ; add 1 to value counter
;		MOV EAX, [EDI] ; eax now holds the current (soon to be old) value for comparison
;		ADD EDI, 4     ; inc EDI pointer
;		CMP [EDI], EAX ; compare next to prev
;		JG  _endCountItter
;		JE  _checkVals
;
;	_endCountItter:
;		MOV [ESI], EBX  ; move ebx count into current esi array position
;
;
;
;

 ; not incorporated into above yet... fix this

;	_countsLoop:
;		CMP [EDI], EAX
;		JE	 _sameVal
;		JNE  _diffVal
;		
;
;		_sameVal:
;			ADD EBX, 1
;			JMP _countsEnd
;
;		_diffVal:
;			MOV 
;
;		_countsEnd:
;			ADD EDI, 4
;			LOOP _countsLoop
;
;	POPAD
;	POP	EBP
;	RET 8
;countList ENDP