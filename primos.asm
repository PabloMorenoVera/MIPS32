.data
	Frase: .asciiz "Los 100 primeros números primos son: "
	Espacio: .asciiz ", "

.text
	li $a0, 1
loop: addiu $a0, $a0, 1

	jal Test_Prime

	lw $s0, 12($sp)
	bne $s0, 100, loop
	
	li $v0, 4
	la $a0, Frase
	syscall
	
Imprimir: lw $a0, 4($sp)
	lw $ra, 8($sp)
	addiu $sp, $sp, 32
	
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, Espacio
	syscall
	
	addiu $t1, $t1, 1 
	bne $t1, 100, Imprimir
	
	li $v0, 10
	syscall
	
Test_Prime: move $v0, $a0

Division: subu $v0, $v0, 1
	beq $v0, 1, Primo
	div $v1, $a0, $v0
	mfhi $t0
	bnez $t0, Division
	jr $ra
	
Primo: addiu $s0, $s0, 1
	subu $sp, $sp, 32
	sw $a0, 4($sp)
	sw $ra, 8($sp)
	sw $s0, 12($sp)
	jr $ra
	
	
