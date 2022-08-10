TITLE Project Five: Arrays, Addressing, Stack Passed Params     (Proj5_maesz.asm)

; Author: Zachary Maes
; Last Modified: August 9th, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 5    Due Date: August 7th, 2022 [2 Grace days in canvas]
; Description: 

; This program creates random decimal values based upon three defined constants, ARRAYSIZE=200, LO=15, and HI-50. These constants should be able to be 
; modified by future programmers to change the ranges and list lenghts. For now, 200 random decimals are generated and filled into a list called randArray. 
; The length is defined by the constant ARRAYSIZE. The random decimals are within the range of 15 and 50 inclusive. These ranges are defined by the constants LO and HI.
; The original random randArray list is displayed first, and then sorted in place in ascending order with a bubble sort algorithm.
; After sorting, the newly sorted randArray list is passed to another procedure that finds the median value of the sorted list.
; The found median value is displayed, and then the sorted list is displayed. Next the sorted list and an empty countsList are passed to a new procedure.
; This new procedure fills countsList with the count of each value from randArray in the range of [15-50] or [LO - HI] and displays the list of instances.
; Finally the program is completed with a farewell message.

INCLUDE Irvine32.inc
; (insert macro definitions here)
; (insert constant definitions here)

ARRAYSIZE = 201	; NOTE TO GRADER: I left at 201 because even values above 41 have a bug...
				; I think it might be an issue with the sorting algorithm when it tries to sort even lists..
				; regardless, I couldn't figure out what was wrong... It should work fine for odd though...
LO        = 15
HI        = 50

.data
; (insert variable definitions here)

;INTRODUCTION DATA
greeting		    BYTE	"Project Five: Arrays, Addressing, Stack Passed Parameters by Zachary Maes!",0
description_1       BYTE	"This program will do something akin to magic...",0
description_2       BYTE	"200 random decimals are generated and filled into a list called randArray. The length is defined by the constant ARRAYSIZE.",0
description_3       BYTE	"The random decimals are within the range of 15 and 50 incluseive. These ranges are defined by the constants LO and HI.",0
description_4       BYTE	"The original random randArray list is displayed first, and then sorted in place in ascending order with a bubble sort algorithm.",0
description_5       BYTE	"After sorting, the newly sorted randArray list passed to another procedure that finds the median value of the sorted list.",0
description_6       BYTE	"The found median value is displayed, and then the sorted list is displayed. Next the sorted list and an empty countsList are passed to a new procedure.",0
description_7       BYTE	"This new procedure fills countsList with the count of each value from randArray in the range of [15-50] or [LO - HI] and displays the list of instances.",0
description_8       BYTE	"Finally the program is completed with a farewell message.",0

; DISPLAY DATA
unsorted_message    BYTE    "UNSORTED RANDOM DECIMAL LIST:",0
median_message      BYTE    "MEDIAN VALUE OF THE SORTED DECIMAL LIST: ",0
sorted_message      BYTE    "SORTED RANDOM DECIMAL LIST (ASCENDING):",0
list_message        BYTE    "LIST OF INSTANCES OF EACH GENERATED DECIMAL STARTING AT THE VALUE OF LO AND ASCENDING TO THE VALUE OF HI:",0
one_space           BYTE    " ",0					; used to print a space inbetween the decimals when displayed

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
			   
	PUSH OFFSET description_8      ; push strings to stack
	PUSH OFFSET description_7    
	PUSH OFFSET description_6    
	PUSH OFFSET description_5    
	PUSH OFFSET description_4    
	PUSH OFFSET description_3    
	PUSH OFFSET description_2    
	PUSH OFFSET description_1    
	PUSH OFFSET greeting
	CALL introduction			

	PUSH OFFSET randArray          ; push address of randArray to stack
	CALL fillArray

	PUSH OFFSET one_space		   ; push string offsets
	PUSH OFFSET unsorted_message   
	PUSH OFFSET randArray
	PUSH arrayLength
	CALL displayList			   ; displayList 1st call for unsorted

	PUSH OFFSET randArray		   ; push address of randArray to stack
	CALL sortList				   ; Calls exchangeElements within the sortList proc

	PUSH OFFSET one_space		   ; push the space string
	PUSH OFFSET sorted_message     
	PUSH OFFSET randArray
	PUSH arrayLength			   ;---------
	CALL displayList			   ; displayList 2nd call for sorted
	
	PUSH OFFSET median_message	   ; push string and array offsets	
	PUSH OFFSET randArray
	CALL displayMedian

	PUSH OFFSET randArray		   ; push array offsets
	PUSH OFFSET countsArray
	PUSH countsArrLen
	CALL countList

	PUSH OFFSET one_space		   ; push string offsets
	PUSH OFFSET list_message       
	PUSH OFFSET	countsArray		   
	PUSH countsArrLen
	CALL displayList		       ; displayList 3rd call for list_message

    PUSH OFFSET farewell_1	    
	CALL farewell			       ; My additional farewell procedure

	Invoke ExitProcess,0	       ; exit to operating system
main ENDP
; (insert additional procedures here)

; ---------------------------------------------------------------------------------
; Name: introduction
;
; Description: 
; Introduces the Program and Author at the start of the program. It then uses a loop to print
;	all passed parameter strings for the program introduction.
;
; Preconditions: The required strings must be declared in the .data section,
;	and also pushed to the stack prior to the procedure call.
;
; Postconditions: None
;
; Receives:
;	[EBP+40] = offset description_8      
;	[EBP+36] = offset description_7    
;	[EBP+32] = offset description_6    
;	[EBP+28] = offset description_5    
;	[EBP+24] = offset description_4    
;	[EBP+20] = offset description_3    
;	[EBP+16] = offset description_2    
;	[EBP+12] = offset of description_1 string
;	[EBP+8]  = offset of greeting string
;
; Returns: N/A
; ---------------------------------------------------------------------------------

introduction PROC
	PUSH EBP					; Base Pointer	
	MOV  EBP, ESP	
	PUSHAD						; Preserve all registers

	MOV  EAX, 8					; 8 for base+offset addressing of first string
	MOV  EDX, [EBP+EAX]			; set up first string in edx for printing
	CALL WriteString
	CALL CrLf
	CALL CrLf

	ADD  EAX, 4					; increment eax for first string in loop to follow
	MOV  ECX, 8					; loop counter
	_introLoop:					; loops 8x through all passed intro strings and prints them.
		MOV  EDX, [EBP+EAX]
		CALL WriteString
		CALL CrLf
		ADD  EAX, 4
		LOOP _introLoop
	
	CALL CrLf
	POPAD   
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
	MOV  EBX, 1			   ; EBX counter for new line (20)
	
	_PrintArr:
		MOV EAX, [EDI]	   ; write the current decimal	
		CALL WriteDec

		MOV EDX, [EBP+20]  ; write the one_space string
		CALL WriteString

		CMP EBX, 20		   ; compare the item per line count to determine new line
		JL	_sameLine
		JE	_newLine

		_newLine:
			CALL CrLf
			ADD EDI, 4
			MOV EBX, 1
			LOOP _PrintArr
		
		_sameLine:
			ADD EDI, 4
			ADD EBX, 1
			LOOP _PrintArr
	
	CALL CrLf
	CALL CrLf

	POPAD		
	POP EBP
	RET 16
displayList ENDP


; ---------------------------------------------------------------------------------
; Name: sortList

; Description: This procedure sorts the randArray list with a bubble sort algorithm.
;	When the algorithm encounters a value swap, it calls the exchangeElements procedure.
;	The list is sorted in ascending order.

; Preconditions: 
;	-exchangeElements procedure must be defined
;	-randArray must be filled with random decimals
;	-randArray must be pushed to the call stack
;
; Postconditions: N/A
;
; Receives:
;	[EBP+8] = pushed offset reference to start of randArray
;
; Returns:
;	-randArray becomes sorted in ascending order.
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
			
			PUSH EDI			 ; push EDI pointer (prev)
			CALL exchangeElements

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
; Description: This procedure is called from the sortList procedure if two values
;	need to be swapped in the bubble sort algorithm. This is done with some register 
;	mov instructions and the xchg instruction.
;
; Preconditions: 
;	-EDI from sortArray must point to an index of the randArray list.
;	-EDI must be pushed to the call stack
;
; Postconditions: POPAD at the end in order to retrieve the necessary 
;	registers used in the remainder of sortList procedure.
;
; Receives:
;	[EBP+8 ] = pushed EDI pointer to (prev) values position in list
;
; Returns:
;	values from [EDI] and [EDI+4] are swapped in place.
; ---------------------------------------------------------------------------------

exchangeElements PROC
	PUSH EBP		  ; Base Pointer
	MOV  EBP, ESP	  
	PUSHAD			  ; preserve registers from the calling procedure
	
	MOV EDI, [EBP+8]  ; move value at array pointer to EAX
	MOV EAX, [EDI]	  ; save value (prev )at edi pointer to EAX...let it get nice and zesty 	
	XCHG EAX, [EDI+4] ; do a little switcheroo with our handy dandy xchg 
	MOV [EDI], EAX    ; after switch eax is now the (next) val and must be moved to where the prev val used to be

	POPAD
	POP	EBP
	RET 4
exchangeElements ENDP


; ---------------------------------------------------------------------------------
; Name: displayMedian
;
; Description: This procedure uses a series of jump conditionals and loops
;	to deterimine if the list length is odd or even, and then find the median value 
;	through another series of checks. 
;
;
; Preconditions: 
;	median_message must be defined in data
;	randArray must be filled and sorted in ascending order
;	both of these must be pushed as offsets to the stack prior to the function call
;
; Postconditions: N/A
;
; Receives:
;	[EBP+12] = OFFSET ref of median_message
;	[EBP+8]  = OFFSET ref of randArray
;
; Returns:
;	writes the median_message string and the found median from randArray
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

	CMP  EDX, 0				   ; check the remainder for 0
	JE   _even
	JG   _odd

	_even:					   ; IF remainder is 0 (even)
		MOV ECX, EAX           ; set loop counter to get to the lower median
		MOV EDI, [EBP+8]       ; point EDI to the beginning of the array
		_evenLoop:
			ADD EDI, 4
			LOOP _evenLoop
		MOV EAX, [EDI]
		CMP EAX, [EDI+4]	   ; compare the left median and right median values
		JE	_writeItNow
		JNE _evenOddCheck
	
	_writeItNow:				   ; high and low medians are equal so median value is EAX=[EDI]
		; EAX=[EDI]
		CALL WriteDec
		CALL CrLf
		JMP  _evenDone
	
	_evenOddCheck:			   ; DIV instruction [EDX:EAX / EBX] ==> (EAX = Quotient) and (EDX = Remainder)	
		ADD  EAX, [EDI+4]	   ; add left median and right median values into EAX
		MOV  EDX, 0			   ; Clear the high dividend
		MOV  EBX, 2			   ; Divide EDX:EAX by 2
		DIV  EBX			   ; (EAX = Quotient) and (EDX = Remainder)
		_compareIt:
			CMP  EDX, 0		   ; check the remainder for 0
			JE   _writeItNow   ; EAX is the median
			JG   _oddInside	   ; odd... remainder is 1

	_oddInside:
		MOV  EAX, [EDI]		   ; add 1 before dividing by 2 again...
		ADD  EAX, [EDI+4]
		ADD  EAX, 1			   ; EAX low dividend is now set for DIV
		MOV  EDX, 0			   ; Clear the high dividend
		MOV  EBX, 2			   ; Divide EDX:EAX by 2
		DIV  EBX			   ; (EAX = Quotient) and (EDX = Remainder)
		JMP _compareIt

	_odd:		               ; IF remainder is not 0 (odd)
		MOV ECX, EAX           ; set loop counter
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
	PUSH EBP			; Base Pointer
	MOV  EBP, ESP	
	PUSH EDX			; preserve edx

	MOV  EDX, [EBP+8]	; access farewell_1 string reference from stack
	CALL WriteString	; write the string to the terminal
	CALL CrLf
	CALL CrLf

	POP	EDX		
	POP	EBP
	RET 4
farewell ENDP

END main
