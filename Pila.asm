#Programa para el uso de un pila, Stack.
#En el registro $s0 se guardará la dirección del nodo raíz.
#En el registro $s1 se guardarán los valores que se vayan introduciendo por el terminal.

.data
	Mem_OR_Msg: .asciiz "Memoria reservada fuera de rango."
	AskF_Num: .asciiz "Introduce un número"
	NewLine: .asciiz "\n"
	Print_Stack: .asciiz "Imprimiendo la pila: "
	End_Program: .asciiz "Terminando Programa."
.text
	li $s2, 0
	
	move $a1, $s2
	li $a0, 0
	
	jal Create
	move $s0, $v0		#Guardo la dirección del nodo raíz en $s0.
	
loop: li $v0, 4
	la $a0, AskF_Num
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, $s2, Sentinel_Value
	
	move $a1, $v0
	move $a0, $s0
	jal Push

	b loop
	
Sentinel_Value: li $v0, 4
	la $a0, Print_Stack
	syscall
	
	move $a0, $s0
	jal Print
	
	li $v0, 4
	la $a0, End_Program
	syscall
	
	li $v0, 10
	syscall
	
Create: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	addiu $fp, $sp, 32
	
	move $s0, $a0			#Saco el valor de la dirección del nodo.
	move $s1, $a1			#Saco el valor del número introducido.
	
	li $v0, 9
	li $a0, 8
	syscall				#Reservo memoria dinámica.
	
	beqz $v0, Mem_Out_Range		#Compruebo si la memoria reservada está fuera de rango.
	
	sw $s1, 0($v0)
	sw $s0, 4($v0)
	
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Push: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	addiu $fp, $sp, 32
	
	move $s0, $a0
	move $s1, $a1			#Saco los valores: Nodo Raíz y Número Introducido.
	
	li $a0, 0
	move $a1, $s1			#Guardo en $a0 un valor en blanco para que me devuelva ahí la Dir del nodo que va a crear y en $a1 el valor nuevo.
	jal Create
	move $s4, $v0
	
Search_Top: lw $s3, 4($s0)
	beqz $s3, Add_Node
	move $s0, $s3
	b Search_Top
	
Add_Node: sw $s4, 4($s0)
	b End_Search_Top
	
End_Search_Top: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Print: 	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	addiu $fp, $sp, 32
	
	move $s0, $a0
	beqz $s0, End_Print
	
	li $v0, 1
	lw $a0, 0($s0)
	syscall
	
	li $v0, 4
	la $a0, NewLine
	syscall
	
	lw $a0, 4($s0)
	jal Print
	
End_Print: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Mem_Out_Range: li $v0, 4
	la $a0, Mem_OR_Msg
	syscall				#Si la memoria reservada está fuera de rango, termino el programa.
	
	li $v0, 10
	syscall
