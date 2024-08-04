/*
* Common directives.
*
*/

// System calls
.equ LINUX_SYSCALL, 0x80;
.equ SYS_EXIT, 1;
.equ SYS_READ, 3;
.equ SYS_WRITE,	4;
.equ SYS_OPEN, 5;
.equ SYS_CLOSE, 6;
.equ SYS_BRK, 45;

// Accessing command line arguments
.equ SYS_ARGC, 0;
.equ SYS_ARGV0, 4;
.equ SYS_ARGV1, 8;
.equ SYS_ARGV2, 12;
.equ SYS_ARGV3, 16;
.equ SYS_ARGV4, 20;

// Acccessing function parameters
.equ F_PARAM_1, 8;
.equ F_PARAM_2, 12;
.equ F_PARAM_3, 16;
.equ F_PARAM_4, 20;
.equ F_PARAM_5, 24;
.equ F_PARAM_6, 28;
.equ F_PARAM_7, 32;
.equ F_PARAM_8, 36;
.equ F_PARAM_9, 40;

// Accessing stack local variables
.equ ST_LOCAL_1, -4;
.equ ST_LOCAL_2, -8;
.equ ST_LOCAL_3, -12;
.equ ST_LOCAL_4, -16;
.equ ST_LOCAL_5, -20;

// File related
.equ O_RDONLY, 0;
.equ O_CREAT_WRONLY_TRUNC, 03101;
.equ O_FILE_PERM_666, 0666;
.equ EOF, 0;
.equ STDIN, 0;
.equ STDOUT, 1;
.equ STDERR, 2;
