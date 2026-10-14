# Loop counter ram
DEFINE LC_ADDR 0x002
DEFINE DISP_START 0x4000
DEFINE DISP_POS_ADDR 0x003
# i = 16
# RAM[LC_ADDR] = 16
A = 16
D = A
A = LC_ADDR
*A = D

# RAM[DISP_POS_ADDR] = DISP_START
A = DISP_START
D = A
A = DISP_POS_ADDR
*A = D

#for i in 0..i
LOOP:
    # *DISP_POS_ADDR = -1
    A = DISP_POS_ADDR
    D = *A
    A = D
    *A = -1

    # pos += 20
    A = 0x020
    D = D + A
    A = DISP_POS_ADDR
    # RAM[DISP_POS_ADDR] = pos
    *A = D

    # i -= 1
    A = LC_ADDR
    D = *A
    D = D - 1
    *A = D

    # jmp > 0
    A = LOOP
    D; JGT
END:
