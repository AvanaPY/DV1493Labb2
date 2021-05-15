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
	movq $0x601061, GPIO

	movq GPIO, %rbx

	movw $3, %ax
	salw $14, %ax
	orw %ax, (%rbx) # moves 11000000 00000000 into GPIO 0 (input and it is on)

	movw $2, %ax
	salw $12, %ax
	orw %ax, (%rbx) # moves 00100000 00000000 into GPIO 1 (output and it is on)

	movw $2, %ax
	salw $10, %ax
	orw %ax, (%rbx) # moves 00001000 00000000 into GPIO 2 (output and it is on)

	movw $2, %ax
	salw $8, %ax
	orw %ax, (%rbx) # moves 00000010 00000000 into GPIO 3 (output and it is on)

	movw $2, %ax
	salw $6, %ax
	orw %ax, (%rbx) # moves 00000000 10000000 into GPIO 4 (output and it is on)

	ret

					# sum   11101010 10000000 = ea, 80 (in hex)

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
