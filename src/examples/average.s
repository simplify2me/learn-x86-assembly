/*
* Find the average from a given list of numbers.
*
* Note: Exit status values can range from 0 to 255, so using this
* approach you cannot report average > 255.
* 
*/

.include "../common/constants.s";

.section .data

	// Input list
	DATA:
		.long 23, 44, 14, 76, 54, 36, 98, 78, 90, 68;
	DATA_SIZE:
		.long (DATA_SIZE - DATA) / 4;

.section .text
.globl _start
_start:
	
	// Pass input list, size and call average function
	push $DATA;
	push DATA_SIZE;
	call average;

	// Report result through exit status
	movl %eax, %ebx;
	movl $SYS_EXIT, %eax;
	int $LINUX_SYSCALL;
	

.type average, @function
average:
	pushl %ebp;
	movl %esp, %ebp;

	movl $0, %edi;	// Index to current element in input
	movl F_PARAM_2(%ebp), %eax; // Pointer to input data
	movl F_PARAM_1(%ebp), %ebx;	// Size of input

	movl (%eax, %edi, 4), %ecx;
	decl %ebx;
	
_loop_start:
	cmpl $0, %ebx;
	je _calculate_avg;
	incl %edi;
	movl (%eax, %edi, 4), %edx;
	addl %edx, %ecx;
	decl %ebx;
	jmp _loop_start;

// %edx has the sum, calculate the average using input size;
_calculate_avg:
	movl %ecx, %eax;
	movl $0, %edx;	
	idivl F_PARAM_1(%ebp);
	
	// %eax has the quotient (average)
	movl %ebp, %esp;
	popl %ebp;
	ret;
	
