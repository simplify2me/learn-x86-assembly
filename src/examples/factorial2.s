/*
* Find the factorial of a given number using iterative approach.
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
		.long 4;

.section .text
.globl _start
_start:
	
	// Setup parameters to call factorial function
	pushl DATA;
	call factorial;

	// Report result
	movl %eax, %ebx;
	movl $SYS_EXIT, %eax;
	int $LINUX_SYSCALL;

/*
* Find factorial of a given number.
*/
.type factorial, @function
factorial:
	pushl %ebp;
	movl %esp, %ebp;

	// Initialize registers
	movl F_PARAM_1(%ebp), %eax;
	movl %eax, %ebx;
	
	// Loop to find factorial
_start_loop:
	cmpl $1, %ebx;
	je _end_loop;
	decl %ebx;
	imull %ebx, %eax;
	jmp _start_loop;

	// Exit loop and return result
_end_loop:
	movl %ebp, %esp;
	popl %ebp;
	ret;
