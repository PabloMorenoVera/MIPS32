.data

	cadena: .asciiz "El resultado de la suma es: "

.text

	li $v0, 5		#Indico el read en el syscall
	syscall			# Leo del teclado el entero

	move $t0, $v0		#Guardo el entero leido

	syscall			#Leo el entero del teclado

	move $t1, $v0		#Guardo el entero leido

	li $v0, 4
	la $a0, cadena		#Imprimo la variable cadena.
	syscall

	add $a0, $t0, $t1	#Sumo los enteros.
	li $v0, 1		#Indico el imprimir en pantalla
	syscall			#Imprimo el resultado

	li $v0, 10
	syscall			#Fin del programa
