/*
* Find the factorial of a given number using recursive functions.
* Output is reported using exit status. After executing the program
* to check the output, run 'echo $?'. 
*
* Note: Exit status values can range from 0 to 255, so using this 
* approach you cannot report result of factorials > 5.
*
* Assumption: Input is >= 0
*/

.include "../common/constants.s";

.section .data
	DATA:
		.long 5;

.section .text
.globl _start
_start:
	pushl DATA;
	call factorial;

	movl %eax, %ebx;
	movl $SYS_EXIT, %eax;
	int $LINUX_SYSCALL;

/*
* Calculate factorial of a given number.
*
* Returns: Factorial of a given number in %eax register.
*/
.type factorial, @function
factorial:
	
	// preserve old ebp and save current stack pointer	
	pushl %ebp;
	movl %esp, %ebp;	
	
	// Base condition
	cmpl $1, F_PARAM_1(%ebp);	
	je _base_case;

	movl F_PARAM_1(%ebp), %ebx;
	decl %ebx;
	pushl %ebx;
	call factorial;

	// Return from current frame
	imull F_PARAM_1(%ebp), %eax;		
	jmp _end_factorial;

_base_case:
	movl $1, %eax;

_end_factorial:	
	movl %ebp, %esp;
	popl %ebp;
	ret;
