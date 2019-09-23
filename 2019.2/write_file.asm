.data
	
	output_data: .asciiz "example_exit_data.mif"
	# output_text: .asciiz "example_exit_text.mif"
	
	config_data: .ascii "DEPTH = 16384;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
	size_config_data: .ascii ""
	# config_text: .ascii "DEPTH = 4096;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
	# size_config_text: .ascii ""
	config_end: .ascii "END;\n"

.text

# Open File
la $a0, output_data
li $a1, 1
li $a2, 0
li $v0, 13
syscall
move $s0, $v0 # saving file descriptor in $s0

# Write to File (Config)
move $a0, $s0
la $a1, config_data
la $t0, size_config_data
subu $a2, $t0, $a1 # $a2 contains number of characters to write (by the counting of bytes in memory)
li $v0, 15
syscall

# Write to File (End)
move $a0, $s0
la $a1, config_end
li $a2, 5
li $v0, 15
syscall

# Close File
move $a0, $s0
li $v0, 16
syscall
