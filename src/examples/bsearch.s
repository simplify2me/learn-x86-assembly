/*
* Binary search implementation.
*
* Output: 
*	If element is found in the list, then the index is returned in exit status.
*	If element is not found in the list, then 255 is returned in exit status.
*
*/

.include "../common/constants.s";

.section .data

	// Data items
	DATA_ITEMS:
		.long 3,15,27,34,49,56,62,73,88,99,101;

	// Number of data elements
	ITEMS_LENGTH:
		.long (ITEMS_LENGTH - DATA_ITEMS) / 4;

	// low, mid and high pointers
	LOW:
		.long -1;
	MID:
		.long -1;
	HIGH:
		.long -1;

	// Key to find in data items
	SEARCH_KEY:
		.long 62;

.section .text
.globl _start
_start:

	// Pointer to move through data items
	movl $0, %edi;

	// Initalize low, mid and high pointers
	movl $0, LOW;
	movl ITEMS_LENGTH, %eax;
	decl %eax;	// Indexes start from 0
	movl %eax, HIGH;

_start_loop:

	// Key not found; low > high
	movl HIGH, %ebx;
	cmpl %ebx, LOW;
	jg _exit;

	// Find midpoint
	pushl LOW;
	pushl HIGH;
	call midpoint;
	movl %eax, MID;
	
	// Compare element mid point to search key
	movl MID, %edi;
	movl DATA_ITEMS(, %edi, 4), %eax;
	cmpl SEARCH_KEY, %eax;	// Compare %eax with search key
	je _key_found;

	// Recalculate low, mid, high and repeat
	jl _move_right;
	jg _move_left;

_key_found:
	movl MID, %ebx;
	movl $SYS_EXIT, %eax;
	int $LINUX_SYSCALL;


/*
* Move high pointer to one location less than current mid point.
*/
_move_left:
	movl MID, %eax;
	movl %eax, HIGH;
	decl HIGH;
	jmp _start_loop;

/*
* Move low pointer to one location more than current mid point.
*/
_move_right:
	movl MID, %eax;
	movl %eax, LOW;
	incl LOW;
	jmp _start_loop;

_exit:
	movl $255, %ebx;
	movl $SYS_EXIT, %eax;
	int $LINUX_SYSCALL;

/*
* Given low and high, returns mid point.
*/
.type midpoint, @function
midpoint:
	pushl %ebp;
	movl %esp, %ebp;	

	movl $0, %edx;
	movl F_PARAM_1(%ebp), %eax;
	addl F_PARAM_2(%ebp), %eax;
	movl $2, %ecx;
	idivl %ecx;
	
	movl %ebp, %esp;
	popl %ebp;
	ret;

