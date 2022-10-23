; fix title
;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

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
           
            ;thise are dec numbers will show up as hex in debugger
NewList	    DC.B 71, 87, 87, 11, 51, 67, 41, 100
	          DC.B 51, 0 , 77, 52, 11, 14, 55, 56
	          DC.B 99, 92, 54, 56, 64, 2, 51, 9
	          DC.B $FF	

; code section
            ORG   Program

Entry:
            ; start up stuff
loop        ldx  #StartROM
            ldy  #StartRAM
            
            ; program stuff  
              ; for each pair of bits check if in right order
for         ldaa 1,x+
            ldab 0,x
            cba
            ;if not swaped increment y and store values
            bgt  swap
            ble  notswap
afterswap   cmpa #$FF
            bne  for
                ;if not right order go to subroutine swap
                ;set swap bit to true
                
            ; check if swap bit is true
            ldab Swapped  ;temp hold of swapped bit
            cmpb #01
            ; set swap bit to false
            ldab #00
            stab Swapped
            beq  loop
                

swap:
            stab 1,y+
            staa 0,y
            ldaa #01
            staa Swapped
            bsr  afterswap
            
notswap:
            staa 1,y+
            stab 0,y
            bsr  afterswap
            

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
