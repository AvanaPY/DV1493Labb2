	.data
counter:	.quad 0
GPIO:		.quad 0
	.text
	.global setup
	.global interrupt

interrupt:
	call dump_gpio
	ret

setup:
	movq $counter, %rax
	addq $0x11, %rax		# gpio is exactly 0x11 steps from counter
	movq %rax, GPIO

	movq $3, %rax
	movq GPIO, %rbx

	movb $'1', (%rbx, %rax, 1)
	
	addq $1, %rax
	movb $'0', (%rbx, %rax, 1)
	
	addq $1, %rax
	movb $'1', (%rbx, %rax, 1)
	
	addq $1, %rax
	movb $'0', (%rbx, %rax, 1)


	movq $0x2, %rax
	sal $6, %rax
	sal $6, %rax
break:	
	movq %rbx, %rcx
	orq %rax, %rcx
	movb $1, (%rbx)	
	
	ret

################
#
# Sets a GPIO pin to low
#
# Arguments:
#	%rdi - pin number
#
################
setLow:
	movq GPIO, %rax
	addq $3, %rdi
	movb $'1', (%rax, %rdi, 1)
	ret

################
#
# Sets a GPIO pin to high
#
# Arguments:
#	%rdi - pin number
#
################
setHigh:
	ret
