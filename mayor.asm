.data
	cadena1: .asciiz "Introduce un número: "
	cadenaF: .asciiz "El número mayor es: "
	
.text


	li $v0, 4
	la $a0, cadena1
	syscall				#Imprimo cadena
	
	li $v0, 5
	syscall				#Leo un número de la entrada
	move $t0, $v0			#Guardo el número en el registro
	
	li $v0, 4
	syscall				#Imprimo cadena
	
	li $v0, 5
	syscall				#Leo el siguiente número
	move $t1, $v0			#Guarda el número en el registro
	
	li $v0, 4
	la $a0, cadenaF
	syscall				#Imprimo cadenaF
	
	li $v0, 1			#Cambio el syscall para imprimir un entero
	bgt $t1, $t0, mayor2		#Comparo los enteros
	
	move $a0, $t0			#Si el primer entero es mayor lo imprimo
	syscall
	
	li $v0, 10
	syscall				#Salgo del programa
	
mayor2:		move $a0, $t1		#Si el segundo entero es mayor lo imprimo
		syscall
	
		li $v0, 10
		syscall			#Saglo del programa