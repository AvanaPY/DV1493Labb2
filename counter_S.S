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
	# addq $0x11, %rax		# gpio is exactly 0x11 steps from counter
	# movq %rax, GPIO
	movq $0x601061, GPIO

	movq GPIO, %rbx

	movq $3, %rax
	salq $14, %rax
	orq %rbx, %rax # sets pin 0 to input

	# movq $0x2, %rax
	# salq $6, %rax
	# salq $6, %rax
	# orq %rbx, %rax # sets pin 1 to output

	# movq $0x2, %rax
	# salq $6, %rax
	# salq $4, %rax
	# orq %rbx, %rax # sets pin 2 to output

	# movq $0x2, %rax
	# salq $6, %rax
	# salq $2, %rax
	# orq %rbx, %rax # sets pin 3 to output

	# movq $0x2, %rax
	# salq $6, %rax
	# salq $0, %rax
	# orq %rbx, %rax # sets pin 4 to output

	addq $3, %rbx
	movq $0x3, %rax
	salq $4, %rax
	addq $1, %rax
	salq $0, %rax
	orq %rbx, %rax # sets pin 1 to ON
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
