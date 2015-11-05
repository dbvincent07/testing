.global main
.func main

main:

	BL _scanf
	MOV R5, R0			
	
	BL _getchar
	MOV R8, R0		
	
	BL _scanf
	MOV R6, R0		

	MOV R1, R8

    MOV R1, R0
	MOV R2, R5
	MOV R3, R6
    BL _compare
    MOV R1, R0
    BL _print_answer
	
	B main

_print_answer:
    PUSH {LR}
    LDR R0, =print_answer
    BL printf
    POP {PC}

_scanf:
    PUSH {LR}
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}

_getchar:
    PUSH {R7}
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    POP {R7}
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

_compare:
	PUSH {LR}
    
	CMP R1, #'+'
	BEQ _add
	
	CMP R1, #'-'
	BEQ _sub
	
	CMP R1, #'*'
	BEQ _mul
	
	CMP R1, #'m'
	BEQ _max
	
	POP {PC}        @MOV PC, LR

_add:
	PUSH {LR}
   	ADD R0, R2, R3
	POP {PC}

_sub:
    PUSH {LR}
   	SUB R0, R3, R2
	POP {PC}

_mul:
    PUSH {LR}
   	MUL R0, R2, R3
	POP {PC}

_max:
	PUSH {LR}
	CMP R2, R3
	MOVGE R0, R2
	MOVLT R0, R3
	POP {PC}


.data
format_str:	
.asciz	"%d"
read_char:  
 .asciz   "%c"
print_answer:  
.asciz   "= %d\n"
exit_str:	
.ascii	"Terminating program.\n"


