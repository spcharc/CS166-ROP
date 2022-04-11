.global readline

.text
readline:
    # (pointer to buffer)
    # return: bytes read

    movq %rdi, %rsi                    # ptr
    xorq %r8, %r8                      # counter

    movq $1, %rdx                      # read:length=1
    xorq %rdi, %rdi                    # stdin

func_readline_loop_start:
    xorq %rax, %rax
    syscall

    testq %rax, %rax                   # stop when there is no more character
    jz func_readline_loop_end

    movzbq (%rsi), %r9                 # stop when '\n' is found
    cmpq $10, %r9
    jz func_readline_loop_end

    incq %r8
    incq %rsi
    jmp func_readline_loop_start

func_readline_loop_end:

    movq %r8, %rax
    retq
