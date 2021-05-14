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
	movq $0xC000, %rbx
	orq %rax, %rbx
	movq $1, (%rbx)		
	#

	movq $0x2, %rbx
	sal $6, %rbx
	 	
	# Make GPIO pin 1 output
	movq %rbx, %rcx
	sal $6, %rcx
	orq %rax, %rcx
	movq $1, (%rcx)

	# Make GPIO pin 2 output
	movq %rbx, %rcx
	sal $4, %rcx
	orq %rax, %rcx
	movq $1, (%rcx)

	# Make GPIO pin 3 output
	movq %rbx, %rcx
	sal $2, %rcx
	orq %rax, %rcx
	movq $1, (%rcx)

	# Make GPIO pin 4 output
	movq %rbx, %rcx
	sal $0, %rcx
	orq %rax, %rcx
	movq $1, (%rcx)
	
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
