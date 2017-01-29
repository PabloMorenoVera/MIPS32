.data
	Frase: .asciiz "Intrduce un número: "

.text
	li $v0, 4
	la $a0, Frase
	syscall				#Pide el número de iteraciones.
	
	li $v0, 5
	syscall				#Recoge el valor de iteraciones "n".
	
	move $a0, $v0
	
	jal Fibonacci
	
	move $a0, $v0
	
	li $v0, 1 			#Imprime el resultado.	
	syscall 			
	
	li $v0, 10 			#Termina el programa.
	syscall
	
Fibonacci: ble $a0, 2, Caso_Base
	subu $sp, $sp, 32
	sw $ra, 20($sp)
	sw $s0, 8($sp)
	sw $a0, 0($sp)
	
	subu $a0, $a0, 1 
	jal Fibonacci
	
	move $s0, $v0
	
	subu $a0, $a0, 1
	jal Fibonacci
	
	addu $v0, $s0, $v0
	
	lw $ra, 20($sp)
	lw $s0, 8($sp)
	lw $a0, 0($sp)
	addiu $sp, $sp, 32
	jr $ra

Caso_Base: addiu $v0, $zero, 1
	jr $ra