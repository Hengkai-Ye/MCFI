        .text
        .globl __patch_call
        .type __patch_call,@function
__patch_call:
        /* save %r11 */
        movq %r11, %fs:0x88
        /* pop the return address */
        popq %r11
        /* set continuation */
        movq %r11, %fs:0x20
        /* subtract the length of the direct call instruction */
        subl $0x5, %fs:0x20
        jmpq *%gs:0x100c8 /* online_patch */

        .globl __report_cfi_violation_for_return
        .type __report_cfi_violation_for_return, @function
__report_cfi_violation_for_return:
        movq %rcx, %rsi
        .globl __report_cfi_violation
        .type __report_cfi_violation, @function
__report_cfi_violation:
        andl $-16, %esp
        jmpq *%gs:0x100c0

        .globl __report_invalid_sandbox_escape
        .align 16, 0x90
        .type __report_invalid_sandbox_escape, @function
__report_invalid_sandbox_escape:
        hlt

        .global __call_dtor
        .align 16, 0x90
        .type __call_dtor,@function
__call_dtor:
        subl $8, %esp
        movl %edi, %eax
        movq %rsi, %rdi
try4:
        movq %gs:0x1000, %rdx
__mcfi_bary___call_dtor_invoke:
        cmpq %rdx, %gs:(%rax)
        jne check4
        .byte 0x66, 0x90 # 2-byte nop
        .byte 0x0f, 0x1f, 0x44, 0x00, 0x00 # 5-byte nop
        callq *%rax
__mcfi_icj_1___call_dtor_invoke:
        addl $8, %esp
        #ret
        popq %rcx
        movl %ecx, %ecx
try1:   movq %gs:0x1000, %rdi
__mcfi_bary___call_dtor:
        cmpq %rdi, %gs:(%rcx)
        jne check1
        jmpq *%rcx
check1:
        movq %gs:(%rcx), %rsi
        testb $0x1, %sil
        jz die1
        cmpl %esi, %edi
        jne try1
die1:
        leaq try1(%rip), %rdi
        jmp __report_cfi_violation_for_return@PLT

check4:
        movq %gs:(%rax), %rcx
        testb $0x1, %cl
        jz die4
        cmpl %edx, %ecx
        jne try4
die4:
        leaq try4(%rip), %rdi
        movq %rax, %rsi
        jmp __report_cfi_violation@PLT

        .global __call_exn_dtor
        .align 16, 0x90
        .type __call_exn_dtor,@function
__call_exn_dtor:
        subl $8, %esp
        movl %edi, %eax
        movq %rsi, %rdi
try5:
        movq %gs:0x1000, %rdx
__mcfi_bary___call_exn_dtor_invoke:
        cmpq %rdx, %gs:(%rax)
        jne check5
        .byte 0x66, 0x90 # 2-byte nop
        .byte 0x0f, 0x1f, 0x44, 0x00, 0x00 # 5-byte nop
        callq *%rax
__mcfi_icj_1___call_exn_dtor_invoke:
        addl $8, %esp
        #ret
        popq %rcx
        movl %ecx, %ecx
try2:   movq %gs:0x1000, %rdi
__mcfi_bary___call_exn_dtor:
        cmpq %rdi, %gs:(%rcx)
        jne check2
        jmpq *%rcx
check2:
        movq %gs:(%rcx), %rsi
        testb $0x1, %sil
        jz die2
        cmpl %esi, %edi
        jne try2
die2:
        leaq try2(%rip), %rdi
        jmp __report_cfi_violation_for_return@PLT

check5:
        movq %gs:(%rax), %rcx
        testb $0x1, %cl
        jz die5
        cmpl %edx, %ecx
        jne try5
die5:
        leaq try5(%rip), %rdi
        movq %rax, %rsi
        jmp __report_cfi_violation@PLT

        .global __call_thread_func
        .align 16, 0x90
        .type __call_thread_func,@function
__call_thread_func:
        subl $8, %esp
        movl %edi, %eax
        movq %rsi, %rdi
try6:
        movq %gs:0x1000, %rdx
__mcfi_bary___call_thread_func_invoke:
        cmpq %rdx, %gs:(%rax)
        jne check6
        .byte 0x66, 0x90 # 2-byte nop
        .byte 0x0f, 0x1f, 0x44, 0x00, 0x00 # 5-byte nop
        callq *%rax
__mcfi_icj_1___call_thread_func_invoke:
        addl $8, %esp
        #ret
        popq %rcx
        movl %ecx, %ecx
try3:   movq %gs:0x1000, %rdi
__mcfi_bary___call_thread_func:
        cmpq %rdi, %gs:(%rcx)
        jne check3
        jmpq *%rcx
check3:
        movq %gs:(%rcx), %rsi
        testb $0x1, %sil
        jz die3
        cmpl %esi, %edi
        jne try3
die3:
        leaq try3(%rip), %rdi
        jmp __report_cfi_violation_for_return@PLT

check6:
        movq %gs:(%rax), %rcx
        testb $0x1, %cl
        jz die6
        cmpl %edx, %ecx
        jne try6
die6:
        leaq try6(%rip), %rdi
        movq %rax, %rsi
        jmp __report_cfi_violation@PLT

        .section	.MCFIFuncInfo,"",@progbits
        .ascii "{ __call_dtor\nR __call_dtor\n}"
        .byte 0
        .ascii "{ __call_exn_dtor\nR __call_exn_dtor\n}"
        .byte 0
        .ascii "{ __call_thread_func\nR __call_thread_func\n}"
        .byte 0

        .section	.MCFIIndirectCalls,"",@progbits
        .ascii "__call_dtor_invoke#N#GblDtor"
        .byte 0
        .ascii "__call_exn_dtor_invoke#N#GblExnDtor"
        .byte 0
        .ascii "__call_thread_func_invoke#N#ThreadEntry"
        .byte 0
