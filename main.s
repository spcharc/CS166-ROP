.global _start

.section .rodata
str1:
    .byte 32
    .ascii "CS166 project. Input something:\n"
str2:
    .byte 11
    .ascii "You typed: "
str3:
    .byte 18
    .ascii " characters long.\n"
str4:  # used by "you_should_never_call_this()"
    .byte 37
    .ascii "You should never call this function!\n"

# =============================================================================
.text
_start:
    subq $8, %rsp                      # align the stack for function calls

    callq func

    movq $60, %rax
    xorq %rdi, %rdi
    syscall

func:
    subq $40, %rsp  # allocate 40 bytes

    leaq str1(%rip), %rdi
    callq print

    leaq 1(%rsp), %rdi
    callq readline
    movb %al, (%rsp)

    movq %rax, %rdi
    callq print_u64
    leaq str3(%rip), %rdi
    callq print

    leaq str2(%rip), %rdi
    callq print

    movq %rsp, %rdi
    callq print
    callq print_newline

    addq $40, %rsp
    retq


you_should_never_call_this:
    leaq str4(%rip), %rdi
    jmp print
