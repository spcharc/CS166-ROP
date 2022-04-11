# =============================================================================
.global print_newline
.global print
.global print_u64
.global print_s64


# =============================================================================
.text
print_newline:
    # ()
    pushq $2561                        # 0x0a01 = byte 1, 10, 0, 0, .....

    movq %rsp, %rdi
    callq print

    addq $8, %rsp
    retq

# =============================================================================
print:
    # (* data)

    # write(1, &data+1, data)
    movzbq (%rdi), %rdx
    leaq 1(%rdi), %rsi
    movq $1, %rdi
    movq $1, %rax
    syscall
    retq

# =============================================================================
print_u64:
    # (number)

    movq %rsp, %rsi
    subq $24, %rsp

    callq conv_u64

    movq %rax, %rdi
    callq print

    addq $24, %rsp
    retq

# =============================================================================
print_s64:
    # (number)
    movq %rsp, %rsi
    subq $24, %rsp

    callq conv_s64

    movq %rax, %rdi
    callq print

    addq $24, %rsp
    retq

# =============================================================================
conv_u64:
    # (number, end of buffer[24]) -> ptr suitable for print()
    # 24 bytes is safe for 64bit integer
    # return: data ready to call print

    movq %rdi, %rax                    # prepare to divide
    movq $10, %rcx                     # for each iteration, divide by 10
    xorq %r8, %r8
func_conv_u64_loop_start:
    decq %rsi
    xorq %rdx, %rdx
    divq %rcx
    addb $48, %dl                      # remainder + 48
    movb %dl, (%rsi)
    incb %r8b
    testq %rax, %rax
    jnz func_conv_u64_loop_start

    decq %rsi
    movb %r8b, (%rsi)                  # store length info
    movq %rsi, %rax
    retq

# =============================================================================
conv_s64:
    # (number, end of buffer[24]) -> ptr suitable for print()
    # 24 bytes is safe for 64bit integer
    # return: data ready to call print
    testq %rdi, %rdi
    jns conv_u64

    subq $8, %rsp

    neg %rdi

    callq conv_u64

    movb (%rax), %dl                   # get counter
    movb $45, (%rax)                   # add neg sign
    incb %dl                           # inc counter
    decq %rax                          # mov ptr
    movb %dl, (%rax)                   # put counter back

    addq $8, %rsp
    retq
