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
greeting		    BYTE	"Welcome to Project Five: Arrays, Addressing, Stack Passed Params by Zachary Maes!",0
description_1       BYTE	"This program will do something akin to magic... The programmer WILL CHANGE THIS DESCRIPTION LATER ON!!!",0

; DISPLAY DATA
unsorted_message    BYTE    "Your unsorted random numbers:",0
median_message      BYTE    "The median value of the array: ",0
sorted_message      BYTE    "Your sorted random numbers:",0
list_message        BYTE    "Your list of instances of each generated number, starting with the smallest value:",0
one_space           BYTE    " ",0

; ARRAYS
randArray			DWORD   ARRAYSIZE DUP(?)	    ; DUP declaration, empty Array of ARRAYSIZE
arrayLength			DWORD	LENGTHOF randArray      ; save length of randArray

countsArray         DWORD   (HI - LO + 1) DUP(?)    ; set up counts array to store the final counted elements
countsArrLen		DWORD	LENGTHOF countsArray    ; length of the the counts array for use in loop.

; FAREWELL DATA
farewell_1          BYTE    "If you have made it this far, congratulations! Thanks for reading my program, goodbye!",0

.code
main PROC
; (insert executable instructions here)
	CALL Randomize				   ; Initialize starting seed vaue of RandomRange procedure

	PUSH OFFSET greeting		   ; push strings to stack
	PUSH OFFSET description_1    
	CALL introduction			

	PUSH OFFSET randArray          ; push address of randArray to stack
	CALL fillArray

	PUSH OFFSET one_space		   ; push the space string
	PUSH OFFSET unsorted_message   ; offset +4
	PUSH OFFSET randArray
	PUSH ARRAYSIZE
	CALL displayList			   ; displayList 1st call for unsorted

	PUSH OFFSET randArray		   ; push address of randArray to stack
	CALL sortList

	PUSH OFFSET one_space		   ; push the space string
	PUSH OFFSET sorted_message     ; offset +4
	PUSH OFFSET randArray
	PUSH ARRAYSIZE
	CALL displayList			   ; displayList 2nd call for sorted
	
	PUSH OFFSET median_message
	PUSH OFFSET randArray
	CALL displayMedian

	PUSH OFFSET randArray
	PUSH OFFSET countsArray
	PUSH countsArrLen
	CALL countList

	PUSH OFFSET one_space		   ; push the space string
	PUSH OFFSET list_message       ; offset +4
	PUSH OFFSET	countsArray		   
	PUSH countsArrLen
	CALL displayList		       ; displayList 3rd call for list_message

;  OTHER REQUIRED PROCS
;	CALL exchangeElements

    PUSH OFFSET farewell_1	    
	CALL farewell			       ; My additional procedure, stack return address +4

	Invoke ExitProcess,0	       ; exit to operating system
main ENDP
; (insert additional procedures here)

; ---------------------------------------------------------------------------------
; Name: introduction
;
; Description: 
; Introduces the Program and Author at the start of the program.
;
; Preconditions: The required strings must be declared in the .data section,
;	and also pushed to the stack prior to the procedure call.
;
; Postconditions: None
;
; Receives:
;	[EBP+12] = offset of greeting string
;	[EBP+8]  = offset of description_1 string 
;
; Returns: N/A
; ---------------------------------------------------------------------------------

introduction PROC
	PUSH EBP	        ; Base Pointer	
	MOV  EBP, ESP	
	PUSH EDX			; Preserve EDX

	MOV  EDX, [EBP+12] 
	CALL WriteString
	CALL CrLf
	CALL CrLf

	MOV  EDX, [EBP+8]
	CALL WriteString
	CALL CrLf
	CALL CrLf

	POP EDX   
	POP EBP
	RET 8
introduction ENDP

; ---------------------------------------------------------------------------------
; Name: fillArray
;
; This procedure uses a loop to generate random decimals and insert them into 
;     an empty array called randArray.
;
; Preconditions: randArray must be declared in data as an empty array with 
;     the ARRAYSIZE constant as its size and DWORD as its type.
;
; Postconditions: randArray will be filled with ARRAYSIZE number of decimals.
;
; Receives:
;     [EBP+8] = offset reference to randArray
;     LO, HI, and ARRAYSIZE used as globals
;
; Returns:
;	  randArray
; ---------------------------------------------------------------------------------

fillArray PROC
	PUSH EBP		      ; Base Pointer     
	MOV  EBP, ESP	      
	PUSHAD				  ; Preserve used registers
	
	MOV  ECX, ARRAYSIZE   ; ARRAYSIZE List length into ECX
	MOV  EDI, [EBP+8]     ; Address of list into EDI

	_fillLoop:
	; GENERATE RANDOM DECIMAL
		MOV  EAX, HI	  ; HI into EAX
		SUB  EAX, LO      ; HI - LO
		ADD  EAX, 1		  ; add 1 to EAX to get upper limit(exclusive) for randomRange	
		CALL RandomRange  ; generates 0 - EAX (exclusive), saves random val in EAX
		ADD  EAX, LO      ; Add LO value to EAX random num to get random within HI-LO range

	; FILL ARRAY
		MOV [EDI], EAX	  ; overwrite value in memory pointed to by EDI
		ADD  EDI, 4		  ; Hardcoded 4 (DWORD) to increment to next index in Array
		LOOP _fillLoop

	POPAD
	POP EBP
	RET 16
fillArray ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
;
; Description: This procedure is called on three separate ocassions. It prints a passed 
;	  parameter string. It then iterates through a passed array parameter, printing out 
;     the current item in the array followed by a space. This repets for all elements 
;     in the array. 
;
; Preconditions: 
;	 -randArray must be filled prior to the first displayList call.
;	 -randArray must be sorted prior to the second displayList call.
;	 -countsArray must be filled prior to the third displayList call.
;	 -countsArrLen must be declared in .data with the LENGTHOF operator
;
; Postconditions: N/A
;
; Receives:
;    [EBP+20] = OFFSET reference of one_space string in memory
;	 [EBP+16] = OFFSET reference of variable string message in memory
;					[1st. unsorted_message // 2nd. sorted_message // 3rd. list_message]
;	 [EBP+12] = OFFSET reference of variable array in memory
;					[1st. randArray // 2nd. randArry // 3rd. countsArray]
;    [EBP+8]  = pushed length of array. [ARRAYSIZE or countsArrLen]
;
; Returns:
;    -No specific returns other than writing strings and decimals to the terminal.
; ---------------------------------------------------------------------------------

displayList PROC
	PUSH EBP		       ; Base Pointer
	MOV  EBP, ESP	
	PUSHAD			       ; preserve all gp registers

	MOV  EDX, [EBP+16]     ; Write the message string
	CALL WriteString
	CALL CrLf

	MOV  EDI, [EBP+12]	   ; move randArray start ref to EDI
	MOV  ECX, [EBP+8]	   ; move ARRAYSIZE or countsArrLen to ECX counter
	
	_PrintArr:
		MOV EAX, [EDI]
		CALL WriteDec

		MOV EDX, [EBP+20]  ; wrtie the one_space string
		CALL WriteString

		ADD EDI, 4
		
		LOOP _PrintArr
	
	CALL CrLf
	CALL CrLf

	POPAD		
	POP EBP
	RET 16
displayList ENDP


; ---------------------------------------------------------------------------------
; Name: sortList

; Description: The sortList procedure will have a really ice description once it is completed
; 
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
	PUSH EBP		             ; Base Pointer
	MOV  EBP, ESP	
	PUSHAD			             ; preserve registers

	MOV ECX, ARRAYSIZE           ; number of elements of randArray into ECX for decrementing the loop iteration counter
	
	_arrayLoop:
		PUSH ECX			     ; save register for loop count
		MOV EDI, [EBP+8]         ; address of first element of randArray into EDI [or next incremented element after loop]
		
		_innerLoop:
			MOV EAX, [EDI]       ; move array element at EDI pointer to EAX register
			CMP [EDI+4], EAX     ; compare next index to previous index at this iteration of the bubble sort
			JGE _noExchange	     ; next is greater than or equal to previous so there is no exchage of values
			
			; CALL exchangeElements {REFACTOR THIS!!!!!!!!!}
			XCHG EAX, [EDI+4]
			MOV [EDI], EAX

		_noExchange:
			ADD EDI, 4			 ; increment EDI pointer
			LOOP _innerLoop

			POP ECX				 ; pop the _arrayLoop counter out of the stack
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
	PUSH EBP		           ; Base Pointer
	MOV  EBP, ESP	
	PUSHAD

	MOV  EDX, [EBP+12]		   ; display message
	CALL WriteString

	MOV  EAX, ARRAYSIZE		   ; Set low dividend =====> DIV instruction [EDX:EAX / EBX] ==> (EAX = Quotient) and (EDX = Remainder)
	MOV  EDX, 0				   ; Clear the high dividend
	MOV  EBX, 2				   ; Divide EDX:EAX by 2
	DIV  EBX				   ; (EAX = Quotient) and (EDX = Remainder)

	CMP  EDX, 0
	JE   _even
	JG   _odd

	_even:		               ; IF remainder is 0 (even)
	; EAX is the left middle, at this point
		MOV ECX, EAX           ;set loop count for lower mid index in eax to ecx
		MOV EDI, [EBP+8]

		_evenLoop1:
			ADD  EDI, 4
			LOOP _evenLoop1
		
		MOV EAX, [EDI]

		_evensDiv:
			ADD EAX, [EDI+4]
			MOV EDX, 0
			MOV EBX, 2
			DIV EBX		
		
		CMP EDX, 0			    ; if even--> eax is the quotient and median val, if odd--> add 1 before div and follow even rules after div
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


	_odd:		    ; IF remainder is not 0 (odd)
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
; Description: This procedure counts the number of instances of each decimal occurance
;	within the randArray passed parameter. It is checking for all decimals in the given
;   constant range of [LO to HI] inclusive. The count is then placed into the passed 
;   countsList array (including counts of 0.)

; Preconditions: 
;	-randArray must be filled first and also sorted in ascending order
;   -empty countsArray must be declared to (HI-LO+1) length
;   -countsArrLen must be declared with LENGTHOF countsArray
;
; Postconditions: N/A
;
; Receives:
;	[EBP+16] = OFFSET reference to sorted randArray
;	[EBP+12] = OFFSET reference to empty countsArray
;	[EBP+8]  = countsArrLen variable
;
; Returns:
;	-filled countsArray 
; ---------------------------------------------------------------------------------

countList PROC
	PUSH EBP						; Base Pointer
	MOV  EBP, ESP				
	PUSHAD							; preserve registers

	MOV  ECX, [EBP+8]				; loop counter to countsArrLen
	MOV  EDI, [EBP+16]				; pointer to start of randArray index0
	MOV  ESI, [EBP+12]				; pointer to start of countsArray index0
	MOV  EDX, LO					; holds Lo and increments up 

	_countsArrLoop:
		MOV EBX, 0					; value amount counter reset to 0
		
		_skipValReset:
			CMP [EDI], EDX
			JNE  _inputValue
			JE   _sameValueHappened

		_sameValueHappened:
			ADD	 EBX, 1				; add 1 to value counter
			ADD  EDI, 4				; inc edi pointer
			JMP  _skipValReset

		_inputValue:
			MOV [ESI], EBX	
			ADD  ESI, 4
			ADD  EDX, 1
			LOOP _countsArrLoop     ; dec ecx

	POPAD
	POP	EBP
	RET 12
countList ENDP

; ---------------------------------------------------------------------------------
; Name: farewell
;
; Description: Extra procedure to print a farewell message. 
;
; Preconditions:
;	-farewell_1 data string must be declared and passed as a parmeter.
;
; Postconditions: N/A
;
; Receives:
;	[EBP+8] = OFFSET reference to farewell_1 string
;
; Returns:
;	-Uses WriteString instruction to print farewell_1 string
; ---------------------------------------------------------------------------------

farewell PROC
	PUSH EBP		; Base Pointer
	MOV  EBP, ESP	
	PUSH EDX        ; preserve edx

	MOV  EDX, [EBP+8] 
	CALL WriteString
	CALL CrLf
	CALL CrLf

	POP	EDX
	POP	EBP
	RET 4
farewell ENDP

END main
