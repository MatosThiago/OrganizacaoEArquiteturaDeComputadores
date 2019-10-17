.data

	file: .asciiz "example.asm"
	file_data: .asciiz "example_data.mif"
	file_text: .asciiz "example_text.mif"
	
	output_data: .ascii "DEPTH = 16384;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
	size_output_data:
	output_text: .ascii "DEPTH = 4096;\nWIDTH = 32;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n"
	size_output_text:
	output_end: .ascii "\n\nEND;\n"
	
	input_buffer: .asciiz ""

.text

main:

	jal read_input
	jal write_output
	
	li $v0, 10
	syscall

#############################################################################################################
# Le o Codigo Fonte do arquivo "example.asm" e salva o conteudo lido em (.data) input_buffer

read_input:

	# Salvando os Registradores que serão usados
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $v0, 12($sp)
	sw $t0, 16($sp)

	# Abre o Arquivo
	la $a0, file
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	move $t0, $v0 # Salva o 'file descriptor' em $t0
	
	# Le o Arquivo
	move $a0, $t0
	la $a1, input_buffer
	li $a2, 1048576
	li $v0, 14
	syscall
	
	# Imprime o Conteudo do Arquivo
	# la $a0, input_buffer
	# li $v0, 4
	# syscall
	
	# Fecha o Arquivo
	move $a0, $t0
	li $v0, 16
	syscall
	
	# Recuperando os Registradores usados
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $v0, 12($sp)
	lw $t0, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra
	
#############################################################################################################

#############################################################################################################
# Escreve o Codigo Objeto nos arquivos "example_data.mif" e "example_text.mif"

write_output:

	# Salvando os Registradores que serão usados
	addi $sp, $sp, -32
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $v0, 12($sp)
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	sw $t2, 24($sp)
	sw $t3, 28($sp)

	# Abre o Arquivo (data)
	la $a0, file_data
	li $a1, 1
	li $a2, 0
	li $v0, 13
	syscall
	move $s0, $v0 # Salva o 'file descriptor' em $s0 (data)
	
	# Abre o Arquivo (text)
	la $a0, file_text
	li $a1, 1
	li $a2, 0
	li $v0, 13
	syscall
	move $s1, $v0 # Salva o 'file descriptor' em $s1 (text)
	
	# Escreve o Cabecalho no Arquivo (data)
	move $a0, $s0
	la $a1, output_data
	la $t2, size_output_data
	subu $a2, $t2, $a1 # $a2 contem o numero de caracteres para escrita (via subtracao de enderecos)
	li $v0, 15
	syscall
	
	# Escreve o Cabecalho no Arquivo (text)
	move $a0, $s1
	la $a1, output_text
	la $t3, size_output_text
	subu $a2, $t3, $a1 # $a2 contem o numero de caracteres para escrita (via subtracao de enderecos)
	li $v0, 15
	syscall
	
	# Chama a funcao que gera o Codigo Objeto a ser escrito
	move $a0, $s0 # Passa 'file descriptor' do arquivo "example_data.mif" como argumento em $a0
	move $a1, $s1 # Passa 'file descriptor' do arquivo "example_text.mif" como argumento em $a1
	jal assemble
	
	# Escreve End no Arquivo (data)
	move $a0, $s0
	la $a1, output_end
	li $a2, 7
	li $v0, 15
	syscall
	
	# Escreve End no Arquivo (text)
	move $a0, $s1
	la $a1, output_end
	li $a2, 7
	li $v0, 15
	syscall
	
	# Fecha o Arquivo (data)
	move $a0, $s0
	li $v0, 16
	syscall
	
	# Fecha o Arquivo (text)
	move $a0, $s1
	li $v0, 16
	syscall
	
	# Recuperando os Registradores usados
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $v0, 12($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	lw $t2, 24($sp)
	lw $t3, 28($sp)
	addi $sp, $sp, 32
	
	jr $ra
	
#############################################################################################################

#############################################################################################################
# Gera o Codigo Objeto a ser escrito

assemble: # ($a0 contem 'file descriptor' de "example_data.mif", $a1 contem 'file descriptor' de "example_text.mif")
	
	# Salvando os Registradores que serão usados
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $v0, 12($sp)
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	
	move $s0, $a0 # Salva o 'file descriptor' de "example_data.mif" em $s0
	move $s1, $a1 # Salva o 'file descriptor' de "example_text.mif" em $s1
	
	##########################################################
	# Teste							 #
	#							 #
	# Escreve o Codigo no Arquivo (data)			 #
	move $a0, $s0						 #
	la $a1, input_buffer					 #
	li $a2, 183						 #
	li $v0, 15						 #
	syscall						 	 #
	#							 #
	# Escreve o Codigo no Arquivo (text)			 #
	move $a0, $s1						 #
	la $a1, input_buffer					 #
	li $a2, 183						 #
	li $v0, 15						 #
	syscall						 	 #
	##########################################################
	
	# Recuperando os Registradores usados
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $v0, 12($sp)
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	addi $sp, $sp, 24
	
	jr $ra

#############################################################################################################

