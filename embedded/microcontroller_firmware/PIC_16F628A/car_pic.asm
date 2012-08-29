;*******************************************************************
; Function:  Wifi Robot Controller
; Processor: pic16f628 at 4 MHz using internal RC oscillator
; Filename:  car_pic.asm
; Author:    Jon Bennett
; Website:   www.jbprojects.net/projects/wifirobot
; Credit:    Based on UART Test Program
;            http://www.oz1bxm.dk/PIC/628uart.htm
;*******************************************************************

#define DEBUG 0
greenLED	equ b'10000000' ;128,RB7
redLED 		equ b'01000000' ;64, RB6
horn 		equ b'00100000' ;32, RB5


right 		equ b'00001000' ;8,  RA3
left 		equ b'00000100' ;4,  RA2
back 		equ b'00000010' ;2,  RA1
forward 	equ b'00000001' ;1   RA0


        LIST P=16F628, R=DEC    ; Use the pic16f628 and decimal system

        #include "P16F628.INC"  ; Include header file

        	__config _INTRC_OSC_NOCLKOUT & _LVP_OFF & _WDT_OFF & _PWRTE_ON & _BODEN_ON & _MCLRE_OFF

        CBLOCK 0x20             ; Declare variable addresses starting at 0x20
        dataL
		in_char
	    temp
    	d1
		d2	
        ENDC

        ORG    0x000            ; Program starts at 0x000
;
; --------------------------------
; set ANALOG/DIGITAL INPUTS PORT A
; --------------------------------
;
        movlw 7
        movwf CMCON             ; CMCON=7 set comperators off
;
; ----------------
; INITIALIZE PORTS
; ----------------
;
        movlw b'00000000'       ; set up portA
        movwf PORTA

        movlw b'00000100'       ; RB2(TX)=1 others are 0
        movwf PORTB

        bsf STATUS,RP0          ; RAM PAGE 1

        movlw 0x00
        movwf TRISA             ; portA all pins output

        movlw b'00000010'       ; RB1(RX)=input, others output
        movwf TRISB

; ------------------------------------
; set BAUD RATE TO COMMUNICATE WITH PC
; ------------------------------------
; Boot Baud Rate = 9600, No Parity, 1 Stop Bit
;
        movlw 0x19              ; 0x19=9600 bps (0x0C=19200 bps)
        movwf SPBRG
        movlw b'00100100'       ; brgh = high (2)
        movwf TXSTA             ; enable Async Transmission, set brgh

        bcf STATUS,RP0          ; RAM PAGE 0

        movlw b'10010000'       ; enable Async Reception
        movwf RCSTA
;
; ------------------------------------
; PROVIDE A setTLING TIME FOR START UP
; ------------------------------------
;
        clrf dataL
settle  decfsz dataL,F
        goto settle

        movf RCREG,W
        movf RCREG,W
        movf RCREG,W            ; flush receive buffer
;
; ---------
; MAIN LOOP
; ---------
;
		clrf PORTA
		movlw redLED
		movwf PORTB

        call message            ; prints out a message if DEBUG is 1
		call check_init ; wait for INIT message from WRT54GL
		bsf PORTB,7
loop    call receive_delay            ; wait for a char		
		call add_green				  ;set greenLED on
		call process_input			  ;make sure that forward and backward aren't both high! or that greenLED and redLED aren't both high! or that left and right aren't both high!
        call send               ; send the char
        goto loop

process_input
; Make sure that Forward & Backward cannot be ON at the same time
; Make sure that Left & Right cannot be ON at the same time
; Output result to PORTB
	MOVWF temp
	BTFSC temp,0 ;//Execute next line if temp,0 is HIGH
		BCF temp,1
    BTFSC temp,2 ;//Execute next line if temp,2 is HIGH
		BCF temp,3
    BTFSC temp,6 ;//Execute next line if temp,6 is HIGH
		BCF temp,7
	MOVF temp,0
    andlw b'00001111'
	movwf PORTA
	movf temp,0
	andlw b'11110000'
	movwf PORTB
	movf temp,0
	return

add_green
	movwf temp
	btfss temp,7  ;If greenLED is LOW execute next line
		bsf temp,7
	movf temp,0
	return

;
; -------------------------------------------
; RECEIVE CHARACTER FROM RS232 AND STORE IN W
; -------------------------------------------
; This routine does not return until a character is received.
;
receive btfss PIR1,RCIF         ; (5) check for received data
        goto receive
data_received
        movf RCREG,W            ; save received data in W
        return


check_init
; waits to receive 'jbpro' from the router meaning that the software is up and running
; after the message is received, the greenLED is turned on and microcontroller can drive the car
	call receive_delay
	sublw 'j'
	btfss STATUS, Z
	   goto check_init
	call receive_delay
	sublw 'b'
	btfss STATUS, Z
	   goto check_init
	call receive_delay
	sublw 'p'
	btfss STATUS, Z
	   goto check_init
	call receive_delay
	sublw 'r'
	btfss STATUS, Z
	   goto check_init
	call receive_delay
	sublw 'o'
	btfss STATUS, Z
	   goto check_init

#if DEBUG
;prints message and goes in to an endless loop of flashing greenLED
	call message

Loop	
;	movlw	greenLED
	movlw 0xff
	movwf	PORTA			;set all bits on
	call	Delay			;this waits for a while!
	movlw	0x00
	movwf	PORTA
	call	Delay
	goto	Loop			;go back and do it again
#endif

return


receive_delay
			;299993 cycles
	movlw	0x5E
	movwf	d1
	movlw	0xEB
	movwf	d2
delay_0
	btfsc PIR1,RCIF ;check for serial data
		goto got_data ;if we do, goto got_data!
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	delay_0

	movlw 0x00
	return

got_data ;move data in to W
	btfsc PIR1,RCIF
	movf RCREG,W
return

#if DEBUG
Delay	movlw	d'250'			;delay 250 ms (4 MHz clock)
	movwf	temp
d11	movlw	0xC7
	movwf	d1
	movlw	0x01
	movwf	d2
Delay_0
	decfsz	d1, f
	goto	$+2
	decfsz	d2, f
	goto	Delay_0

	decfsz	temp	,f
	goto	d11
	retlw	0x00
#endif



;
; -------------------------------------------------------------
; SEND CHARACTER IN W VIA RS232 AND WAIT UNTIL FINISHED SENDING
; -------------------------------------------------------------
;
send    
#if DEBUG
movwf TXREG             ; send data in W

TransWt bsf STATUS,RP0          ; RAM PAGE 1
WtHere  btfss TXSTA,TRMT        ; (1) transmission is complete if hi
        goto WtHere

        bcf STATUS,RP0          ; RAM PAGE 0
#endif
        return
;
; -------
; MESSAGE
; -------
;
message 
#if DEBUG
		movlw  '1'
        call send
        movlw  '6'
        call send
        movlw  'F'
        call send
        movlw  '6'
        call send
        movlw  '2'
        call send
        movlw  '8'
        call send
        movlw  ' '
        call send
        movlw  'a'
        call send
        movlw  'l'
        call send
        movlw  'i'
        call send
        movlw  'v'
        call send
        movlw  'e'
        call send
        movlw  0x0D ; CR
        call send
        movlw  0x0A ; LF
        call send
#endif
        return

        END 