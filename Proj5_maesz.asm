TITLE Project Five: Arrays, Addressing, Stack Passed Params     (Proj5_maesz.asm)

; Author: Zachary Maes
; Last Modified: August 4th, 2022
; OSU email address: maesz@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 5               Due Date: August 7th, 2022
; Description: 
; 
; 
; 
; 
; 
; 
; 
; 
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

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
