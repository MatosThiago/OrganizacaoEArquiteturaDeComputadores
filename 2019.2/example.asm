.data

	array: .word 1, 2, 3, 4, 5
	
.text

main:
	li $t0, 0
	
print:
	beq $t0, 16, end
	lw $a0, array($t0)
	li $v0, 1
	syscall
	addi $t0, $t0, 4
	j print
	
end:
	li $v0, 10
	syscall