CSEG At 0H
;This project requires three virtual hardware components: a multiplexed led display, simple led display and simple keypad
;main loop, detects is bit P0.0 is set (can be controlled via simple keypad)
mov R1, #08h ;starting points
Start:
setb P0.0
call convertpoints
MAINLOOP: 
jnb P0.0, displayNum
mov P3, #10111111b ;display line on display
clr P2.0
clr P2.1
clr P2.2
clr P2.3
setb P2.0
setb P2.1
setb P2.2
setb P2.3
push p2

call init
pop p2
jmp MAINLOOP

displayNum: ;generate random numbers, save number codes to register
mov R3, #03h
loop:
push A
mov b, #02h
div ab
mov a,b
inc a
call convert
mov R4, P3;save display code to register
clr P2.0
setb P2.0

pop a
call ANF
push A
mov b, #02h
div ab
mov a,b
inc a
call convert
mov R5,P3;save display code to register
clr P2.1
setb P2.1

pop a
call ANF
push A
mov b, #02h
div ab
mov a,b
inc a
call convert
mov R6,P3;save display code to register
clr P2.2
setb P2.2

pop a
call ANF
push A
mov b, #02h
div ab
mov a,b
inc a

call convert
mov R7,P3;save display code to register
clr P2.3
setb P2.3

pop a
call anf
djnz R3, loop

;compare numbers to check if they are the same
mov A,R7
mov B,R6
cjne A,B,nowin
mov A,R5
cjne A,B,nowin
mov A,R4
cjne A,B,nowin

win: ;display numbers for short time, then show lines like at start, increment points
mov R0,#0fh
inc R1
loop2:
call refresh
djnz R0,loop2
cjne R1,#0ah, bridgeToStart

maxPoints: ;if ten points are reached, a dot is displayed and the game ends
mov P1, #01111111b
call refresh
jmp maxpoints

nowin: ;display numbers for short time, then show lines like at start, decrement points
mov R0,#0fh
dec R1
call convertpoints
push a
mov a,r1
jz ende
pop a
loop1:
call refresh
djnz R0,loop1
bridgeToStart:
jmp start
 


;refreshes the display so numbers dont disappear, using display codes stored in register
refresh:
mov P3, R4
clr P2.0
setb P2.0

mov P3, R5
clr P2.1
setb P2.1

mov P3, R6
clr P2.2
setb P2.2

mov P3, R7
clr P2.3
setb P2.3
ret

ende:;is called when no points are left
mov P3, #10111111b ;display line on display
clr P2.0
clr P2.1
clr P2.2
clr P2.3
setb P2.0
setb P2.1
setb P2.2
setb P2.3
jmp ende

;timer für displaysteuerung wie be Eieruhr
convert:;write number to display to p3
mov DPTR, #table
push a ;save akku to stack
movc a,@a+dptr
mov p3,a
pop a
ret

convertPoints:;write number to display to p1
mov DPTR, #table
push a ;save akku to stack
mov a,R1
movc a,@a+dptr
mov p1,a
pop a
ret
;;Ab hier kommt der zufallsgenerator

EQU	ZUF8R, 0x20		;ein byte
ORG 100H

;-----------MAIN-----------------------------------
init:
         MOV	R0, #2fh   ;Speichere die Zahlenreihe oberhalb 30h
ANF:
;-----------GENERIER EINE ZUFALLSZAHL----------
	 
	 call ZUFALL         ;Zufallszahl A bestimmen zwischen 00h und ffh
;----------- CASE-ANWEISUNG-------------------------
         mov R2,#00h        ;Zähler initialisieren mit 0 
neu:	 add A,#020h        ;die Zufallszahl plus 32 
         inc R2            ;Zähler um 1 erhöhen
	 jnc neu           ;falls schon Überlauf, dann weiter - sonst  addiere 32
	 
	mov A, R2          ;schreib Zahl in A


ret

;--------------------------------------------------

; ------ Zufallszahlengenerator-----------------
ZUFALL:	mov	A, ZUF8R   ; initialisiere A mit ZUF8R
	jnz	ZUB
	cpl	A
	mov	ZUF8R, A
ZUB:	anl	a, #10111000b
	mov	C, P
	mov	A, ZUF8R
	rlc	A
	mov	ZUF8R, A
	ret
	
org 300h
table:
db 11000000b
db 11111001b, 10100100b, 10110000b
db 10011001b, 10010010b, 10000010b
db 11111000b, 10000000b, 10010000b

end
