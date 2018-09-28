.data

raiz: 	.word 8  a0 a1
a0: 	.word 3  a2 a3
a1: 	.word 10 0  a4
a2: 	.word 1  0  0
a3: 	.word 6  a5 a6
a4: 	.word 14 a7 0
a5: 	.word 4  0  0
a6: 	.word 7  0  0
a7: 	.word 13 0  0

space:	.asciiz " "
line:	.asciiz "\n"

.text

li $v0, 0	# v0 = size_rec(raiz)
la $a0, raiz
jal size_rec

move $a0, $v0	# print(v0)
li $v0, 1
syscall

li $v0, 0	# insere_rec(raiz, 15)
la $a0, raiz
li $a1, 15
jal insere_rec

la $a0, space	# print(" ")
li $v0, 4
syscall

li $v0, 0	# v0 = size_rec(raiz)
la $a0, raiz
jal size_rec

move $a0, $v0	# print(v0)
li $v0, 1
syscall

la $a0, line	# print("\n")
li $v0, 4
syscall

li $v0, 0	# v0 = busca_rec(raiz, 15)
la $a0, raiz
li $a1, 15
jal busca_rec

lw $a0, 0($v0)	# print(v0->dado)
li $v0, 1
syscall

li $v0, 10
syscall

insere_rec:
	addi $sp, $sp, -8	# Aloca espaço na pilha para um item
	sw $ra, 4($sp)		# Armazena endereço de retorno
	sw $a0, 0($sp)		# Salva valor de a0
	
	bne $a0, $zero, ir	# Se a0 (raiz) != 0 (NULL), pule para ir
	add $v0, $zero, $gp	# Copia para v0 o endereço contido em gp
	addi $gp, $gp, 12	# Aloca espaço para o novo nó (raiz = malloc(sizeof(nodo)))
	sw $a1, 0($v0)		# raiz->dado = valor
	sw $zero, 4($v0)	# raiz->esq = NULL
	sw $zero, 8($v0)	# raiz->dir = NULL
	sw $v0, ($a2)		# Faz com que o nó anterior aponte para o nó criado
	j ir_return		# Pule para ir_return
	
	ir:
	lw $t0, 0($a0)		# Carrega a primeira word de a0 (dado) em t0
	slt $t1, $a1, $t0	# Se a1 (valor) < t0 (raiz->dado), t1 = 1
	beq $t1, $zero, ir_dir	# Se t1 = 0 (valor > raiz->dado), pule para ir_dir
	
	la $a2, 4($a0)		# Carrega o endereço da segunda word de a0 (ponteiro para raiz->esq)
	lw $a0, 4($a0)		# Carrega a segunda word de a0 (raiz->esq) em a0
	jal insere_rec		# Chama insere_rec a esquerda
	j ir_return		# Pule para ir_return
	
	ir_dir:
	la $a2, 8($a0)		# Carrega o endereço da terceira word de a0 (ponteiro para raiz->dir)
	lw $a0, 8($a0)		# Carrega a terceira word de a0 (raiz->dir) em a0
	jal insere_rec		# Chama insere_rec a direita
	
	ir_return:
	lw $a0, 0($sp)		# Restaura valor de a0
	lw $ra, 4($sp)		# Carrega endereço de retorno
	addi $sp, $sp, 8	# Retira espaço na pilha para um item
	jr $ra			# Retorna para chamadora

busca_rec:
	addi $sp, $sp, -4	# Aloca espaço na pilha para um item
	sw $ra, 0($sp)		# Armazena endereço de retorno
	
	bne $a0, $zero, br	# Se a0 (raiz) != 0 (NULL), pule para br
	li $v0, 0		# Carrega 0 em v0 (return NULL)
	j br_return		# Pule para br_return
	
	br:
	lw $t0, 0($a0)		# Carrega a primeira word de a0 (dado) em t0
	bne $a1, $t0, br_aux	# Se a1 (valor) != t0 (raiz->dado), pule para br_aux
	la $v0, ($a0)		# Carrega o endereço presente em a0 em v0 (return raiz)
	
	addi $sp, $sp, 4	# Retira espaço na pilha para um item
	jr $ra			# Retorna para chamadora
	
	br_aux:
	slt $t1, $a1, $t0	# Se a1 (valor) < t0 (raiz->dado), t1 = 1
	beq $t1, $zero, br_dir	# Se t1 = 0 (valor > raiz->dado), pule para br_dir
	
	lw $a0, 4($a0)		# Carrega a segunda word de a0 (raiz->esq) em a0
	jal busca_rec		# Chama busca_rec a esquerda
	j br_return		# Pule para br_return
	
	br_dir:
	lw $a0, 8($a0)		# Carrega a terceira word de a0 (raiz->dir) em a0
	jal busca_rec		# Chama busca_rec a direita
	
	br_return:
	lw $ra, 0($sp)		# Carrega endereço de retorno
	addi $sp, $sp, 4	# Retira espaço na pilha para um item
	jr $ra			# Retorna para chamadora

size_rec:
	addi $sp, $sp, -8	# Aloca espaço na pilha para um item
	sw $ra, 4($sp)		# Armazena endereço de retorno
	sw $a0, 0($sp)		# Salva valor de a0
	
	bne $a0, $zero, sr	# Se a0 (raiz) != 0 (NULL), pule para sr
	addi $v0, $v0, 0	# Adiciona 0 a v0 pois o nó não existe
	j sr_return		# Pule para sr_return
	
	sr:
	addi $v0, $v0, 1	# Adiciona 1 a v0 pois o nó existe
	lw $a0, 4($a0)		# Carrega a segunda word de a0 (raiz->esq) em a0
	jal size_rec		# Chama size_rec a esquerda
	lw $a0, 0($sp)		# Restaura valor de a0
	lw $a0, 8($a0)		# Carrega a terceira word de a0 (raiz->dir) em a0
	jal size_rec		# Chama size_rec a direita
	
	sr_return:
	lw $a0, 0($sp)		# Restaura valor de a0
	lw $ra, 4($sp)		# Carrega endereço de retorno
	addi $sp, $sp, 8	# Retira espaço na pilha para um item
	jr $ra			# Retorna para chamadora
	