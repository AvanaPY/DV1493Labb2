	.data
counter:	.quad 0
GPIO:		.quad 0
	.text
	.global setup
	.global interrupt

interrupt: # in from rdi
	add $1, counter		# Increment counter

	mov $0, %edx		#
	mov counter, %rax	# This block of code
	mov $16, %rcx		# computes counter modulo 16
	div %rcx		# to limit the value between 0 and 15, inclusive
	mov %rdx, counter	# 

	movq $5, %r8		# Store for looping
	movq counter, %rcx	# Save value in rcx
_intLoop:
	# division babyy
	subq $1, %r8		# Looping and decrementing counter 
	cmp $0, %r8		# block of code
	je _intLoopDone		# 

	mov $0, %edx 		# reset beofre dividing
	movq %rcx, %rax		# move rcx to rax
	movq $2, %rcx 		# set what to divide with
	
	div %rcx 		# Divide, rax has result, rdx has the modulo
	movq %rax, %rcx		# save the answer in rcx 

	movq %r8, %rdi		# Move our counter to rdi 
				# This counter is also our pin number 
	cmp $0, %rdx
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
setHigh:
	movq GPIO, %rax		# compute memory offset
	addq $3, %rax

	movq $4, %rbx		# Compute base shift offset
	salq $3, %rbx
	addq $1, %rbx

	subq $1, %rdi		
_setHighShiftLoop:		# bit-shift in a loop according to formula
	cmp $0, %rdi
	je _setHighLoopDone
	salq $8, %rbx
	subq $1, %rdi
	jmp _setHighShiftLoop
_setHighLoopDone:
	orl %ebx, (%rax)	# Set pin 
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
	movq GPIO, %rax		# Compute memory offset
	addq $3, %rax

	movq $0xCF, %rbx	# Compute base shift offset
	
	subq $1, %rdi	
_setLowShiftLoop:		# bit-shift in a loop according to formula
	cmp $0, %rdi
	je _setLowLoopDone
	salq $8, %rbx
	subq $1, %rdi
	jmp _setLowShiftLoop
_setLowLoopDone:		# Final maths stuff
	not %rbx		
	andl %ebx, (%rax)	# Set pin
	ret	
