;********************************************************************************
;*
;* File: main.asm
;*
;* Author: OCdt Brown & OCdt Gillingham
;*
;* Description: This is a file for sorting an array of integers. The integers
;*              are already placed into ROM. It will check for an array terminator
;*              symbol of $FF. If not at end of array will call swap. By looping
;*              through this process untill no swaps occure a bubble sort algo
;*              will be compleated.
;*
;********************************************************************************

; export symbols
            XDEF Entry            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

StartRAM    EQU  $0800  ; where sorted list will be stored
StartROM    EQU  $8000  ; where unsorted list will be stored
Program     EQU  $C000  ; where program will be stored
Swapped     EQU  $BFFF  ; will store if a swap occured
                         ; did I spell occured correctly

; variable/data section
            ORG Swapped  ; stres if a swap occured
            DC.B 00      ; 01 is true

            ORG StartROM ;where the unsorted list is stored
           
            ;thise are dec numbers
NewList	    DC.B 71, 87, 87, 11, 51, 67, 41, 100
	          DC.B 51, 0 , 77, 52, 11, 14, 55, 56
	          DC.B 99, 92, 54, 56, 64, 2, 51, 9
	          DC.B $FF	

;second test
;HexList     DC.B $32, $15, $EB, $07, $E6, $FA, $F5, $84
;            DC.B $84, $89, $78, $0F, $EE, $EF, $12, $93
;            DC.B $34, $91, $DA, $11, $FC, $32, $F3, $A2
;            DC.B $FF

; code section
            ORG   Program

Entry:
            ; start up stuff
            ldx  #StartROM
            ldy  #StartRAM
            
            ; loads all the numbers into RAM
startloop   ldaa 1,x+
            staa 1,y+
            cmpa #$FF
            bne  startloop    
                        
            ;loop is used to sort  
loop        ldy  #StartRAM
  
              ; for each pair of bits check if in right order
for         ldaa 1,y+
            ldab 0,y
            
            cmpb #$FF
            beq skip
            
            cba
            ;if not swaped increment y and store values
            ;compares singed values need to compare unsinged values!!!!!!!!!!!!!!!!!!!!!!
            bhs  swap
                       
afterswap   bra for
            
                ;if not right order go to subroutine swap
                ;set swap bit to true
                
            ; check if swap bit is true
skip        ldaa Swapped  ;temp hold of swapped bit
            cmpa #01
            ; set swap bit to false
            ldaa #00
            staa Swapped
            beq  loop
                
;********************************************************************************
;*
;* Subroutine: Decrypt
;*
;* Description: This subroutine is where the algo will swap the order the numbers
;*              are stored in memory.
;*
;* Inputs: A -  contains the value that needs to be stored second
;*         B -  contains the value that needs to be stored first
;*         IY - contains the address to store the values in A and B
;*
;* Outputs: None
;*
;* Subroutines: None
;********************************************************************************                 
swap:
            dey
            stab 1,y+
            staa 0,y
            ldaa #01
            staa Swapped            
            bsr  afterswap
            rts           
            

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
