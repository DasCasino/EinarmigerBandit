CSEG At 0H
TOP: 

;main loop, detects is bit P0.0 is set
LOOP: 
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
jmp loop

displayNum:
mov R4, A
clr P2.0
setb P2.0
call ANF
mov R5, A
clr P2.1
setb P2.1
call ANF
mov R6, A
clr P2.2
setb P2.2
call ANF
mov R7, A
clr P2.3
setb P2.3

;refreshes the display so numbers dont disappear
refresh:
mov A, R4
call convert
clr P2.0
setb P2.0
mov A, R5
call convert
clr P2.1
setb P2.1
mov A, R6
call convert
clr P2.2
setb P2.2
mov A, R7
call convert
clr P2.3
setb P2.3
jmp refresh

;TODO vergleich einfügen, gewinn anzeigen
;TODO animation mehrerer Zahlen, dann auf zahl festlegen
;TODO wertebereich verändern, damit gewinn wahrscheinlicher wird
;Bei sehr viel Langeweile: Punktesystem einfügen
convert:
mov DPTR, #table
push a ;save akku to stack
movc a,@a+dptr
mov p3,a
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

call convert ;only call if needed
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
