.data

	cadena: .asciiz "Introduce un número: "
	multiplo: .asciiz "Multiplo de a: "
	fin_linea: .asciiz "\n"
	fin_iguales: .asciiz "Ya no hay mas múltiplos."
	fin_cero: .asciiz "El segundo número es 0."
	
.text

	li $v0, 4
	la $a0, cadena
	syscall				#Imprimo cadena
	
	li $v0, 5
	syscall				#Leo un número de la entrada
	move $t0, $v0			#Guardo el número en el registro
	
	li $v0, 4
	syscall				#Imprimo cadena
	
	li $v0, 5
	syscall				#Leo el siguiente número
	move $t1, $v0			#Guarda el número en el registro
	
	beq $t1, 0, igual_cero		#Si b es igual a 0, termino.
	
	li $t2, 1			#Inicializo el bucle
	
bucle: mult $t0, $t2			#Multiplico 'a' por el inmediato.
	
	li $v0, 4
	la $a0, multiplo
	syscall				#Imprimo multiplo.
	
	mflo $t3
	
	li $v0, 1			# Imprimo los multiplos.
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, fin_linea
	syscall
	
	add $t2, $t2, 1
	
	beq $t2, $t1, iguales		#Si 'a' = 'b', termino.
	ble $t0, $t1, bucle		#Si '(a*$t2)' < 'b', continuo.
	
igual_cero:  li $v0, 4		#B es igual a cero, asi que salgo.
		la $a0, fin_cero
		syscall
		
		li $v0, 10
		syscall
	
iguales: mul $t3, $t0, $t2		#Hago el último múltiplo: a*$t2 = b
		
		li $v0, 4
		la $a0, multiplo
		syscall				#Imprimo multiplo.
		
		li $v0, 1
		move $a0, $t3
		syscall				#Imprimo el múltiplo.
		
		li $v0, 4
		la $a0, fin_linea
		syscall				#Imprime el fin de línea.
		
		li $v0, 4			#Ya no hay más múltiplos.
		la $a0, fin_iguales
		syscall
		
		li $v0, 10
		syscall
