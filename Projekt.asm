CSEG At 0H
TOP: 
MOV R0,#0F0h
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
DJNZ R0,LOOP; reduziere R0 und springe nach oben (LOOP) falls nicht Null

displayNum:
mov R7, A
clr P2.0
setb P2.0
call ANF
mov R6, A
clr P2.1
setb P2.1
call ANF
mov R5, A
clr P2.2
setb P2.2
call ANF
mov R4, A
clr P2.3
setb P2.3


refresh:
mov A, R7
call convert
clr P2.0
setb P2.0
mov A, R6
call convert
clr P2.1
setb P2.1
mov A, R5
call convert
clr P2.2
setb P2.2
mov A, R4
call convert
clr P2.3
setb P2.3
jmp refresh

;TODO make this conversion better/not scuffed... (db table, bcd...)
;TODO vergleich einfügen, gewinn anzeigen
;TODO animation mehrerer Zahlen, dann auf zahl festlegen
;TODO wertebereich verändern, damit gewinn wahrscheinlicher wird
;Bei sehr viel Langeweile: Punktesystem einfügen
convert:
        cjne A,#01h, keine1c
        mov P3, #11111001b
        ret
keine1c:
        cjne A,#02h, keine2c
        mov P3, #10100100b
        ret
keine2c:  cjne A,#03h, keine3c
        mov P3, #10110000b
        ret
keine3c: cjne A,#04h, keine4c
        mov P3, #10011001b
        ret
keine4c: cjne A,#05h, keine5c
        mov P3, #10010010b
        ret
keine5c:
        cjne A,#06h, keine6c
        mov P3, #10000010b
        ret
keine6c: cjne A,#07h, keine7c
        mov P3, #11111000b
        ret
keine7c: mov P3, #10000000b
        ret ;von vorn!

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

call convert
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

end
