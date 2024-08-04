/*
* File copy utility.
*
* Exercise for user:
* 	- Error handling on read / write failure is not done.
*	- Explore how to report errors during read and write operations.
*/

.include "../common/constants.s";

.section .data

	// Storage to store source and target file descriptors.
	SOURCE_FD:
		.long -1;
	TARGET_FD:
		.long -1;
	
	// Counter to store number of times buffer read is done
	COUNT:
		.long 0;

	// Usage hint
	USAGE: 
		.ascii "\n Usage: ./fcopy source_file target_file\n\n";
	USAGE_SIZE:
		.long USAGE_SIZE - USAGE;

.section .bss

	// Buffer to be used for file read and write.
	.equ BUFFER_SIZE, 500;
	.lcomm BUFFER, BUFFER_SIZE;

.section .text
.globl _start
_start:
	
	// Input validation
	movl %esp, %ebp;
	movl SYS_ARGC(%ebp), %eax;

	cmpl $3, %eax;
	jne _show_usage_and_exit;

	// Open source file in read only mode
	pushl $O_FILE_PERM_666;
	pushl $O_RDONLY;
	pushl SYS_ARGV1(%ebp);
	call file_open;
	movl %eax, SOURCE_FD;

	// Open target file in write mode. If file is not present
	// create it with permissions 0666
	pushl $O_FILE_PERM_666;
	pushl $O_CREAT_WRONLY_TRUNC;
	pushl SYS_ARGV2(%ebp);
	call file_open;
	movl %eax, TARGET_FD;
	
	// Read from source and write to target file
_start_loop:
	pushl $BUFFER_SIZE;
	pushl $BUFFER;
	pushl SOURCE_FD;
	call file_read;

	// Exit if EOF is reached
	cmpl $EOF, %eax;
	jle _exit;	// If 0, end of file is ready, < 0 indicates failure	

	pushl %eax; // Whatever # of bytes read into buffer, write to target 
	pushl $BUFFER;
	pushl TARGET_FD;
	call file_write;
	jmp _start_loop;

_show_usage_and_exit:
	pushl USAGE_SIZE;
	pushl $USAGE;
	pushl $STDOUT;
	call file_write;
	
	movl $SYS_EXIT, %eax;
	movl $1, %ebx;
	int $LINUX_SYSCALL;
	
_exit:
	// Close source and target file descriptors
	pushl TARGET_FD;
	call file_close;
	pushl SOURCE_FD;
	call file_close;

	// Exit and report buffer read count as exit status.
	movl $SYS_EXIT, %eax;
	movl COUNT, %ebx;
	int $LINUX_SYSCALL;
