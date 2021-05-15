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
	
	movq $1, %rdi
	call setHigh

	movq $2, %rdi
	call setHigh

	movq $1, %rdi
	call setLow
	ret
################
#
# Sets a GPIO pin to low 
#
# Arguments:
#	%rdi - pin number
#
################
setHigh:
	movq GPIO, %rax
	addq $3, %rax

	movq $4, %rbx
	salq $3, %rbx
	addq $1, %rbx

	subq $1, %rdi
_setHighShiftLoop:
	cmp $0, %rdi
	je _setHighLoopDone
	salq $8, %rbx
	subq $1, %rdi
	jmp _setHighShiftLoop
_setHighLoopDone:
	orl %ebx, (%rax)
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

	addq $3, %rax
	movq $0xCF, %rbx
	
	subq $1, %rdi
_setLowShiftLoop:
	cmp $0, %rdi
	je _setLowLoopDone
	salq $8, %rbx
	subq $1, %rdi
	jmp _setLowShiftLoop
_setLowLoopDone:
	not %rbx
	andl %ebx, (%rax)
	ret
