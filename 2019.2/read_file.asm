.data

	file: .asciiz "example.asm"
	buffer: .asciiz ""

.text

# Open File
la $a0, file
li $a1, 0
li $a2, 0
li $v0, 13
syscall
move $s0, $v0 # saving file descripton in $s0

# Read from File
move $a0, $s0
la $a1, buffer
li $a2, 1048576
li $v0, 14
syscall

# Print Buffer
la $a0, buffer
li $v0, 4
syscall

# Close File
move $a0, $s0
li $v0, 16
syscall