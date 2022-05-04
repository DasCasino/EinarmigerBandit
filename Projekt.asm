
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
push p1
push p2
call init
pop p2
pop p1
DJNZ R0,LOOP; reduziere R0 und springe nach oben (LOOP) falls nicht Null

displayNum:
clr P2.0
setb P2.0
clr P2.1
setb P2.1
clr P2.2
setb P2.2
clr P2.3
setb P2.3
mov R5, #0f0h
djnz R5, displaynum ;;make program stop without loop??

;;Ab hier kommt der zufallsgenerator

EQU	ZUF8R, 0x20		;ein byte
jmp init
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

;--------scuffed conversion :)------------
        cjne A,#01h, keine1
        mov P3, #11111001b
        ret
keine1:
        cjne A,#02h, keine2
        mov P3, #10100100b
        ret
keine2:  cjne A,#03h, keine3
        mov P3, #10110000b
        ret
keine3: cjne A,#04h, keine4
        mov P3, #10110000b
        ret
keine4: cjne A,#05h, keine5
        mov P3, #10011001b
        ret
keine5:
        cjne A,#06h, keine6
        mov P3, #10010010b
        ret
keine6: cjne A,#07h, keine7
        mov P3, #10000010b
        ret
keine7: mov P3, #10000000b
        ret ;von vorn!
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
