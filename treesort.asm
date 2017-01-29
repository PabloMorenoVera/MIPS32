.data
	Pide_Num: .asciiz "Introduce un número: "
	Fuera_Rango_Msg: .asciiz "Memoria fuera de rango."
	Valor_Centinela_Msg: .asciiz "Introducido el valor centinela, tterminando programa."
.text

	li $s2, 0		#Guardo el valor centinela
	
	move $a0, $s2
	li $a1, 0
	li $a2, 0		#Guardo los valores del nodo raiz
	
	jal Create_Node		#Creo el nodo raiz
	move $s0, $v0		#Guardo en $s0 la dirección del nodo raiz
	
loop: li $v0, 4
	la $a0, Pide_Num
	syscall			#Introduce la frase "Pide_Num"
	
	li $v0, 5
	syscall			#Introduce un número
	
	move $s0, $v0
	beq $s0, $s2, Valor_Centinela	#Comprueba que el valro introducido no es el 0
	
	move $a0, $s0
	move $a1, $s2		#Mueve los valores a las variables $ax para llamar a subrutina
	jal Tree_Insert
	

Create_Node: subu $sp, $sp, 32	#Creo la pila
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)		#Guardo los valoresen la pila
	addu $fp, $sp, 32	#Actualizo el puntero a la pila
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2		#Guardo los campos: Valor, Izq y Der
	
	li $v0, 9
	li $a0, 12
	syscall			#Reservo la memoria dinámica
	
	move $s3, $v0		#Guardo en $s3 la dirección en la que está el nodo creado
	
	beqz $s3, Fuera_Rango	#Compruebo si la memoria reservada está fuera de rango
	
	sw $s0, 0($s3)
	sw $s1, 4($s3)
	sw $s2, 8($s3)		#Guardo los componentes del nodo
	
	move $v0, $s3		#Vuelvo a poner en $v0 la dirección del nodo raíz
	
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	addiu $sp, $sp, 32	#Cargo los valores de la pila para continuar
	jr $ra
	
Tree_Insert: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addiu $fp, $sp, 32	#Creo la pila y guard los valores
	
	move $s1, $a1
	move $s0, $a0		#Guardo en $s0 el valor del nodo
	li $a1, 0
	li $a2, 0		#Asigno los valores de izq y der
	jal Create_Node

Buscar_Nodo: lw $s3, 0($s1)		#Guardo en $s1 el valor del nodo raiz
	ble $s0, $s1, Go_Izq
	b Go_Der
	
Go_Izq: lw $s4, 4($s1)
	beqz $s4, Añadir_Izq
	move $s1, $s4
	b Buscar_Nodo
	
Añadir_Izq: sw $s2, 4($s1)
	b End_Buscar
	
Go_Der: lw $s4, 8($s3)
	beqz $s4, Añadir_Der
	move $s1, $s4
	b Go_Der
	
Añadir_Der: sw $s2, 8($s1)
	b End_Buscar
	
End_Buscar: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	addu $sp, $sp, 32
	jr $ra 
		 
Fuera_Rango: la $a0, Fuera_Rango_Msg
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
Valor_Centinela: la $a0, Valor_Centinela_Msg
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall

		
