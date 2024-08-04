/*
* Bubble sort. Sort list of elements in place.
*
* Note: Link this program with libc
*/

.include "../common/constants.s";

.section .data

	// Input list
	ITEMS:
		.long 34, 54, 23, 0, 33, -1, 67, 56, 87, 42, 63, 84, 101;

	// Input list size
	ITEMS_SIZE:
		.long (ITEMS_SIZE - ITEMS) / 4;

	// String formatter to display sorted output
	OUTPUT:
		.ascii "%d\n";

.section .text
.globl _start
_start:

	// Sort input list
	pushl $ITEMS;
	pushl ITEMS_SIZE;
	call bubble_sort;

	// Print the sorted list
	pushl $ITEMS;
	pushl ITEMS_SIZE;
	pushl $OUTPUT;
	call print_array;
	
	jmp _exit;	

/*
* Bubble sort implementation.
*
* Parameters:
*	2 -> Location (address) of the input list to sort	
*	1 -> Size of the input list
*
*/
.type bubble_sort, @function
bubble_sort:
	pushl %ebp;
	movl %esp, %ebp;

	// Initialize registers
	movl F_PARAM_2(%ebp), %eax;
	movl F_PARAM_1(%ebp), %ebx;
	
	// Initial pointers 
	movl $0, %esi;
	movl $1, %edi;

	// Local stack storage to keep track of swaps 
	// during a single pass. 
	subl $8, %esp;
	movl $0, ST_LOCAL_1(%ebp);

	// Used as tmp storage during swap operation 
	movl $0, ST_LOCAL_2(%ebp);

_bs_start_loop:
	
	// Break when you are done with a single pass
	cmpl %edi, %ebx;	
	je _next_pass;
	
	// Compare pair of numbers pointed by esi and edi
	movl (%eax, %esi, 4), %ecx;
	movl (%eax, %edi, 4), %edx;

	cmpl %ecx, %edx;
	jg _swap_items;

_continue:
	// Move the pointers to compare the next pair
	incl %esi;
	incl %edi;
	jmp _bs_start_loop;
	
/*
* If there were no swaps during the pass, then
* the list is sorted. Else, start the next pass.
*/
_next_pass:
	
	// No swap during pass
	cmpl $0, ST_LOCAL_1(%ebp);
	je _bs_end_loop;

	// Prepare for next pass
	movl $0, %esi;
	movl $1, %edi;
	movl $0, ST_LOCAL_1(%ebp);
	jmp _bs_start_loop;

_bs_end_loop:
	movl %ebp, %esp;
	popl %ebp;
	ret;

	

/*
* Swap two elements in a given list. Record that
* the swap has occurred.
*/
_swap_items:
	// %esi points to left element and %edi points to right element
	// %eax has the location of the list. Swap them
	movl (%eax, %esi, 4), %ecx;
	movl (%eax, %edi, 4), %edx;

	movl %ecx, ST_LOCAL_2(%ebp);
	movl %edx, %ecx;
	movl ST_LOCAL_2(%ebp), %edx;
	
	movl %ecx, (%eax, %esi, 4);
	movl %edx, (%eax, %edi, 4);

	// Record that a swap has occurred
	incl ST_LOCAL_1(%ebp);
	jmp _continue;
	
/*
* Print an array of integers.
*
* Parameters:
*	3 -> Location of the array
* 	2 -> Size of the array
*	1 -> Format string
*
*/
.type print_array, @function
print_array:
	pushl %ebp;
	movl %esp, %ebp;
	subl $8, %esp;

	// Store array location and size in local stack
	// in addition to storing them in registers.
	// They may be modified by printf
	movl F_PARAM_2(%ebp), %ecx;
	movl F_PARAM_3(%ebp), %eax;
	movl %ecx, ST_LOCAL_1(%ebp);
	movl %eax, ST_LOCAL_2(%ebp);

	movl $0, %edi;

_pr_start_loop:
	cmpl $0, %ecx;
	je _pr_exit_loop;

	pushl (%eax, %edi, 4);
	pushl F_PARAM_1(%ebp);
	call printf;

	// Restore ecx and eax
	decl ST_LOCAL_1(%ebp);
	movl ST_LOCAL_1(%ebp), %ecx;
	movl ST_LOCAL_2(%ebp), %eax;

	incl %edi;
	jmp _pr_start_loop;

_pr_exit_loop:
	movl %ebp, %esp;
	popl %ebp;
	ret;

_exit:
	movl $0, %ebx;
	movl $SYS_EXIT, %eax;
	int $LINUX_SYSCALL;
