.global main
.func main

main:

	BL _scanf
	MOV R1, R0		
	MOV R5, R0			
	
	BL _getchar
	MOV R1, R0
	MOV R8, R0		
	
	BL _scanf
	MOV R1, R0
	MOV R6, R0		

	BL _compare  
    MOV R1, R0
    BL _print_answer
	
	B main

_print_answer:
    MOV R4, LR
    LDR R0, =print_answer
    MOV R1, R1
    BL printf
    MOV PC, R4

_scanf:
    MOV R4, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R4              @ return

_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compare:
    MOV R4, LR
	CMP R1, #'+'
	BEQ _add
	BNE _sub
	MOV PC, R4

_add:
	MOV R4, LR
    MOV R0, #0
    MOV R0, R5
   	ADD R0, R6
	MOV PC, R4

_sub:
    CMP R8, #'-'
    BNE _mul
    MOV R0, #0
    MOV R0, R5
    SUB R0, R6
    MOV PC, R4

_mul:
    CMP R8, #'*'
    BNE _max
    MOV R0, #0
    MOV R0, R5
    MUL R0, R6
    MOV PC, R4

_max:
    CMP R8, #'M'
    BNE _exit
    MOV R0, #0
    MOV R0, R5
    CMP R5, R6
    BGT   _exit
    MOV R0, #0
    MOV R0, R6
    MOV PC, R4

_exit:
    MOV PC, R4


.data
format_str:	
.asciz	"%d"
read_char:  
 .asciz   "%c"
print_answer:  
.asciz   "= %d\n"
exit_str:	
.ascii	"Terminating program.\n"


