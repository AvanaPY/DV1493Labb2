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
	movq $counter, %rax
	addq $0x11, %rax		# gpio is exactly 0x11 steps from counter
	movq %rax, GPIO
	


	# Make GPIO pin 0 input
	movq $3, %rbx
	salq $14, %rbx
	movq $1, (%rbx)		

	#
	ret
