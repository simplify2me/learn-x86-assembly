/*
* Primitive Memory Manager.
* 	- A basic memory manager to illustrate the concepts of what
* 	goes underneath dynamic memory management.
*	- This is a first fit memory manager, meaning, when there is
* 	a request to allocate more memory, if it finds a free space it
* 	simply allocates it on it's first sight.
*
*	Users 8 bytes in front of the allocated memory region for
*	bookkeeping. First 4 bytes is used to track if the memory 
* 	block is available and the second 4 bytes is used to track
* 	the size of the memory region this header is attached to.
*/

.include "../common/constants.s";

.section .data

	// Address where heap starts
	HEAP_START:
		.long 0;

	// Address where heap ends (system break)
	BRK:
		.long 0;

.section .text
.equ HEADER_SIZE, 8;
.equ M_AVAIL_OFFSET, 0;
.equ M_SIZE_OFFSET, 4;
.equ AVAILABLE, 0;
.equ NOT_AVAILABLE, 1;


/*
* Initialize memory manager. This function MUST be called
* before allocating / de-allocating memory using this lib.
*/
.globl mm_init;
.type mm_init, @function;
mm_init:
	pushl %ebp;
	movl %esp, %ebp;
	
	movl $SYS_BRK, %eax;
	movl $0, %ebx;
	int $LINUX_SYSCALL;

	// Register current heap start and end
	movl %eax, HEAP_START;
	movl %eax, BRK;
	
	movl %ebp, %esp;
	popl %ebp;
	ret;

/*
* Allocate memory. 
*
* Parameters:	
*	1 -> Size (bytes) of memory required
*
* Returns - address of allocated memory, 0 otherwise
*/
.globl mm_alloc;
.type mm_alloc, @function;
mm_alloc:
	pushl %ebp;
	movl %esp, %ebp;	

	// Holds requested memory size
	movl F_PARAM_1(%ebp), %ebx;	
	// Holds heap start location
	movl HEAP_START, %ecx; 
	// Holds heap end location
	movl BRK, %edx;

_start:
	// IF no mem is available, request from os
	cmpl %ecx, %edx;
	je _request_from_os;

	// Check if mem region is available	
	cmpl $NOT_AVAILABLE, M_AVAIL_OFFSET(%ecx);	
	je _next_block;

	// Check if mem region is of requested size
	cmpl M_SIZE_OFFSET(%ecx), %ebx;
	jg _next_block;

	// Memory block is available and can accomodate
	// requested size; use it
	movl $NOT_AVAILABLE, M_AVAIL_OFFSET(%ecx);
	addl $HEADER_SIZE, %ecx;
	movl %ecx, %eax;
	movl %ebp, %esp;
	popl %ebp;
	ret;

/*
* Request more memory from OS. Way to request more memory
* is to set the target memory (BRK) to whatever needed
* and issue SYS_BRK.
*/
_request_from_os:

	// Store registers before syscall
	pushl %ebx;
	pushl %ecx;
	pushl %edx;

	addl $HEADER_SIZE, %ebx;
	addl %edx, %ebx;

	movl $SYS_BRK, %eax;
	int $LINUX_SYSCALL;

	// On Error
	cmpl $0, %eax;
	je _allocation_error;

	popl %edx;
	popl %ecx;
	popl %ebx;

	// On Success record the new break
	// eax has the new BRK fro sys call
	movl %eax, BRK;	
	
	// Mark memory block as used, update header
	movl $NOT_AVAILABLE, M_AVAIL_OFFSET(%ecx);
	movl %ebx, M_SIZE_OFFSET(%ecx);

	// Return memory block
	movl %ecx, %eax;
	addl $HEADER_SIZE, %eax;
	movl %ebp, %esp;
	popl %ebp;
	ret;
	

/*
* Advance to the next memory block and inspect.
*/
_next_block:
	movl M_SIZE_OFFSET(%ecx), %eax;
	addl $HEADER_SIZE, %eax;
	addl %eax, %ecx;
	jmp _start;


_allocation_error:
	movl $0, %eax;
	movl %ebp, %esp;
	popl %ebp;
	ret;

/*
* Deallocate memory.
*/
.globl mm_free;
.type mm_free, @function;
mm_free:
	pushl %ebp;
	movl %esp, %ebp;

	movl F_PARAM_1(%ebp), %eax;
	subl $HEADER_SIZE, %eax;
	movl $AVAILABLE, M_AVAIL_OFFSET(%eax);

	movl %ebp, %esp;
	popl %ebp;
	ret;
