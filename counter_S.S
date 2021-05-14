	.data
counter:	.quad 0
GPIO:		.quad 0
	.text
	.global setup
	.global interrupt

interrupt:
	add $1, counter
	ret

setup:
	movq $0x404061, %rax
	xor %rbx, %rbx
	movb (%rax), %bl
	movb 1(%rax), %bl
	movb 2(%rax), %bl
	movb 3(%rax), %bl
	movq %rax, GPIO
	movq $1, 3(%rax)
	ret
