	.data
counter:	.quad 0
GPIO:		.quad 0
	.text
	.global setup
	.global interrupt

interrupt: # in from rdi
	add $1, counter
	movq $4, %r8
	movq counter, %rax
_intLoop:
	# division babyy
	cmp $0, %r8
	je _intLoopDone

	mov $0, %edx # reset beofre dividing
	movq $2, %rcx # set what to divide with
	div %rcx # saves the output in %rax
	# %edx # rest

	movq %r8, %rdi

	cmp $0, %edx
	je _intNotOne

	call setHigh
	jmp _intLoop

_intNotOne:
	call setLow
	jmp _intLoop

_intLoopDone:
	ret

setup:
	movq $0x601061, GPIO

	movq GPIO, %rbx

	movw $3, %ax
	salw $14, %ax
	orw %ax, (%rbx) # moves 11000000 00000000 into GPIO (pin 0, input and it is not on)

	movw $2, %ax
	salw $12, %ax
	orw %ax, (%rbx) # moves 00100000 00000000 into GPIO (pin 1, output and it is not on)

	movw $2, %ax
	salw $10, %ax
	orw %ax, (%rbx) # moves 00001000 00000000 into GPIO (pin 2, output and it is not on)

	movw $2, %ax
	salw $8, %ax
	orw %ax, (%rbx) # moves 00000010 00000000 into GPIO (pin 3, output and it is not on)

	movw $2, %ax
	salw $6, %ax
	orw %ax, (%rbx) # moves 00000000 10000000 into GPIO (pin 4, output and it is not on)

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
