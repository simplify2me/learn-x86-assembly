/*
* Find length of a given string.
*
* Assumption: String ends with \0.
* Result is returned in exit status.
*/

.include "../common/constants.s";

.section .data
	NAME:
		.ascii "Hello World!\n";


.section .text
.globl _start
_start:

	// Pass string to strlen function
	pushl $NAME;
	call strlen;

	// Result
	movl %eax, %ebx;
	movl $SYS_EXIT, %eax;
	int $LINUX_SYSCALL;


/*
* String length function.
*
* Iterates through each byte and counts until \0 is encountered.
*/
.type strlen, @function
strlen:
	pushl %ebp;
	movl %esp, %ebp;
	movl F_PARAM_1(%ebp), %eax;
	movl $0, %edi;
	movl $0, %ecx;
_loop:
	movb (%eax, %edi, 1), %bl;
	cmpb $0, %bl;
	je _exit;
	incl %ecx;
	incl %edi;
	jmp _loop;

_exit:
	movl %ecx, %eax;
	movl %ebp, %esp;
	popl %ebp;
	ret;
	
