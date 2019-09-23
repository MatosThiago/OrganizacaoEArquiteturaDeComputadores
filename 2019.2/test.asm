.data

	str: .asciiz "Thiago Matos"
	aux: 
	
.text

la $t0, str
la $t1, aux
subu $t3, $t1, $t0