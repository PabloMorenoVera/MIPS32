.data

	Pide_Num: .asciiz "Introduce un número: "
	Fuera_Rango_Msg: .asciiz "Memoria reservada fuera de rango, saliendo del programa."
	Valor_Centinela_Msg: .asciiz "Introducido valor centinela, imprimiendo árbol del programa: \n"
	Newline: .asciiz "\n"
	End_Program: .asciiz "Terminando programa."

.text
	li $s2, 0
	
	move $a2, $s2
	li $a0, 0
	li $a1, 0		#Guardo los valores del nodo centinela.
	jal Create_Node
	move $s0, $v0		#Guardo la dirección del nodo raíz.
	
loop: li $v0, 4
	la $a0, Pide_Num
	syscall
	
	li $v0, 5
	syscall			#Lee el número del terminal.
	
	move $s1, $v0		#Guarda el valor introducido en $s1.
	beq $s1, $s2, Sentinel_Value	#Compruebo si es el valor centinela.
	
	move $a0, $s0
	move $a1, $s1		#Guardaa el valor($s1) y el nodo raíz($s0) para llamar a Insert_Node
	jal Insert_Node
	
	b loop
	
Sentinel_Value: lw $a0, 4($s0)
	jal Tree_Print
	
	lw $a0, 8($s0)
	jal Tree_Print
	
	li $v0, 4
	la $a0, End_Program
	syscall
	
	li $v0, 10
	syscall
	
Create_Node: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addiu $fp, $sp, 32		#Creo la pila para crear el nodo.
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2			#Guardo los vales en las variables estáticas porque si van a pisar al llamar a sbrk.
	
	li $v0, 9
	li $a0, 12
	syscall			#Reservo la memoria dinámica.
	 
	beqz $v0, Out_Range		#Compruebo si he reservado memoria fuera de rango.
	
	sw $s0, 0($v0)
	sw $s1, 4($v0)
	sw $s2, 8($v0)
	 
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Insert_Node: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addiu $fp, $sp, 32		#Creo la pila para crear el nodo.
	
	move $s0, $a0
	move $s1, $a1			#Guardo los valores del nodo raíz($s0) y el valor($s1).
	
	move $a0, $s1
	li $a1, 0
	li $a2, 0			#Guardo los campos: Valor, Izq y Der para llamar a crear el nodo.
	jal Create_Node
	move $s2, $v0			#Pongo la dirección del nodo creado en $s2.
	
Search_Node: lw $s3, 0($s0)		#Cargo el valor del nodo a comparar.
	ble $s3, $s1, Go_Left		#Si el valor introducido es menor o igual voy por la izquierda.
	b Go_Right			#Si es mayor, por la derecha.
	
Go_Left: lw $s4, 4($s0)			#Cargo la dirección Izq del nodo.
	beqz $s4, Add_Left		#Si es cero, añado el nuevo nodo ahí.
	move $s0, $s4			#Si no, vuelvo a comparar los valores cargando el siguiete nodo.
	b Search_Node
	
Add_Left: sw $s2, 4($s0)
	b End_Search_Node		#Añado por la Izquierda.
	
Go_Right: lw $s4, 8($s0)
	beqz $s4, Add_Right
	move $s0, $s4
	b Search_Node			#Busco por la Derecha.
	
Add_Right: sw $s2, 8($s0)
	b End_Search_Node		#Añadp por la Derecha.
	
End_Search_Node: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	addiu $sp, $sp, 32
	jr $ra				#Añadido el nodo nuevo, vuelvo.
	
Out_Range: li $v0, 4
	la $a0, Fuera_Rango_Msg
	syscall				#si la memoria dinámica está fuera de rango, termino el programa.
	
	li $v0, 10
	syscall
	
Tree_Print: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addiu $fp, $sp, 32		#Creo la pila.
	
	move $s0, $a0
	beqz $s0, End_Print_Tree	#Si el nodo es Null, retorno.
	
	lw $a0, 4($s0)
	jal Tree_Print
	
	li $v0, 1
	lw $a0, 0($s0)
	syscall
	
	li $v0, 4
	la $a0, Newline
	syscall
	
	lw $a0, 8($s0)
	jal Tree_Print
	
End_Print_Tree: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	addiu $sp, $sp, 32
	jr $ra				#He llegado al final de la rama.
		