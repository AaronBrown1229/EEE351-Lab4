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
            ; will put all numbers into RAM for us to milipulate
            ldx  #StartROM
            ldy  #StartRAM
startloop   ldaa 1,x+
            staa 1,y+
            cmpa #$FF
            bne  startloop    
            
                   
loop        ldy  #StartRAM
            
            ; program stuff  
              ; for each pair of bits check if in right order
for         ldaa 1,y+
            ldab 0,y
            
            cmpb #$FF
            beq skip
            
            cba
            ;if not swaped increment y and store values
            bgt  swap
                       
afterswap   bsr for
            
                ;if not right order go to subroutine swap
                ;set swap bit to true
                
            ; check if swap bit is true
skip        ldaa Swapped  ;temp hold of swapped bit
            cmpa #01
            ; set swap bit to false
            ldaa #00
            staa Swapped
            beq  loop
                

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
