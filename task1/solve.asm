; === Адресное пространство программы ===
ORG 0000h       ; 0000h

MAIN:
    LXI SP, 0900h; выделение стека

    ; A = 5
    MVI A, 15
    STA VAR_A
    ; B = 7
    MVI A, 7
    STA VAR_B

    ; == ВЫЗОВЫ ФУНКЦИЙ ==

    CALL SUM ; -> A = 12

    CALL SUB ; -> A = -2

    CALL MUL ; -> A = 35

    CALL DIV ; -> A = 35

    ; поместить результаты из 0403h - 0406h в регистры A, B, C, D.

    LXI H, RESULT_SUM; HL = 0403h
    MOV A, M ; A = 0403h
    INX H
    MOV B, M ; B = 0404h
    INX H
    MOV C, M ; C = 0405h
    INX H
    MOV D, M ; D = 0406h

    HLT ; остановить выполнение

; === Адресное пространство функций ===
ORG 0200h

; суммировать и положить в 0403h
SUM:
    LXI H, VAR_A ; Loc(HL) = VAR_A
    MOV A, M ; A = VAR_A
    INX H ; Loc(HL)++
    ADD M ;A<-Loc(HL) + (A)
    STA RESULT_SUM ;RESULT_SUM(0403h) <- A

    RET
SUB:
    LXI H, VAR_A ; Loc(HL) = VAR_A
    MOV A, M ; A = VAR_A
    INX H ; Loc(HL)++
    SUB M ;A<-Loc(HL) + (A)
    STA RESULT_SUB ;RESULT_SUM(0403h) <- A

    RET
MUL:
    LXI H, VAR_A ; Loc(HL) = VAR_A
    MOV C, M ; A = VAR_A
    INX H ; Loc(HL)++
    MOV B, M ; B = VAR_B

    XRA A ; a = 0

    ; выход если множитель = 0
    MOV D, C
    INR D
    DCR D
    JZ MUL_DONE
MUL_LOOP:
    ; тело цикла
    ADD B
    ; c -= 1
    DCR C
    ; if c == 0 { goto loop }
    JNZ MUL_LOOP
MUL_DONE:
    STA RESULT_MUL
    RET

DIV:
    MVI C, 00H

    ; выход если делим на 0
    MOV D, B
    INR D
    DCR D
    JZ DIV_ERR
DIV_LOOP:
    CMP B
    JC DIV_DONE ; выход если carry = 1

    SUB B ; A = A - B
    INR C ; C = C + 1
    JMP DIV_LOOP
DIV_ERR:
    MVI C, 0FFH     ; возвращаем OFFH (код ошибки)
DIV_DONE:
    ; C = частное
    ; A = остаток
    ; остаток не нужен
    MOV A, C
    STA RESULT_DIV
    RET


; === Данные для функций ===
ORG 0400h

VAR_A: DS 1 ; -> 0400h
VAR_B: DS 1 ; -> 0401h
; -> 402h
RESULT_SUM: DS 1 ; -> 0403h
RESULT_SUB: DS 1 ; -> 0404h
RESULT_MUL: DS 1 ; -> 0405h
RESULT_DIV: DS 1 ; -> 0406h
