.data

	cadena: .asciiz "El resultado de la suma es: "
	num1: .word 7
	num2: .word 4 

.text

	lw $t0, num1		#Cargo el número 1 en el registro.
	lw $t1, num2		#Cargo el número 1 en el registro.

	li $v0, 4
	la $a0, cadena		#Imprimo la variable cadena.
	syscall

	add $a0, $t0, $t1	#Sumo los enteros.
	li $v0, 1		#Indico el imprimir en pantalla
	syscall			#Imprimo el resultado

	li $v0, 10
	syscall			#Fin del programa