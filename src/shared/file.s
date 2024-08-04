/*
* Library functions specific to file handling.
*/

.include "../common/constants.s";

.globl file_open;
.globl file_read;
.globl file_write;
.globl file_close;
.type file_open, @function;
.type file_read, @function;
.type file_write, @function;
.type file_close, @function;

/*
* Open a file.
* 
* Parameters:
*	3 -> File permissions
*	2 -> Mode (read, write, rw) to open
*	1 -> File name
*
*/
file_open:

	// Preserve base pointer & mark base pointer for
	// this function (stack frame).
	pushl %ebp;
	movl %esp, %ebp;

	// Prepare to open given file and setup system call
	movl $SYS_OPEN, %eax;
	movl F_PARAM_1(%ebp), %ebx;
	movl F_PARAM_2(%ebp), %ecx;
	movl F_PARAM_3(%ebp), %edx;
	int $LINUX_SYSCALL;

	// %eax will have file descriptor; return to caller
	movl %ebp, %esp;
	popl %ebp;
	ret;

/*
* Read from file.
* 
* Read from the given file handle. Buffer size indicates how much
* can be read from the file handle at a given time. Read data is
* stored in the buffer.
*
* Parameters:
*	3 -> Buffer size
*	2 -> Buffer
*	1 -> Open file handle
*
*/
file_read:
	
	// Preserve base pointer & mark base pointer for
	// this function (stack frame).
	pushl %ebp;
	movl %esp, %ebp;

	// Prepare to read from file and setup system call
	movl $SYS_READ, %eax;
	movl F_PARAM_1(%ebp), %ebx;
	movl F_PARAM_2(%ebp), %ecx;
	movl F_PARAM_3(%ebp), %edx;
	int $LINUX_SYSCALL;

	// %eax will have file descriptor; return to caller
	movl %ebp, %esp;
	popl %ebp;
	ret;

/*
* Write to a file.
* 
* Write data that is available in the buffer to the given file
* handle. Data that is available in buffer is indicated by the
* buffer size. 
*
* Parameters:
*	3 -> Buffer size
*	2 -> Buffer 
*	1 -> Open file handle
*
*/
file_write:

	// Preserve base pointer & mark base pointer for
	// this function (stack frame).
	pushl %ebp;
	movl %esp, %ebp;

	// Prepare to write to file and setup system call
	movl $SYS_WRITE, %eax;
	movl F_PARAM_1(%ebp), %ebx;
	movl F_PARAM_2(%ebp), %ecx;
	movl F_PARAM_3(%ebp), %edx;
	int $LINUX_SYSCALL;

	// %eax will have file descriptor; return to caller
	movl %ebp, %esp;
	popl %ebp;
	ret;
/*
* Close file.
*
* Parameters:
*	1 -> File handle to close
*/
file_close:
	
	// Preserve base pointer & mark base pointer for
	// this function (stack frame).
	pushl %ebp;
	movl %esp, %ebp;

	// Prepare to write to file and setup system call
	movl $SYS_CLOSE, %eax;
	movl F_PARAM_1(%ebp), %ebx;
	int $LINUX_SYSCALL;

	// %eax will have file descriptor; return to caller
	movl %ebp, %esp;
	popl %ebp;
	ret;
