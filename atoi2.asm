.data
	cadena: .space 1024
	fin_linea: .asciiz "\n"
	resultado: .asciiz "El resultado es: "
	Num_negativo: .asciiz "-"
	
.text
main:
	li $v0, 8
	la $a0, cadena
	li $a1, 1024
	syscall					#Leo  la cadena
	
	move $t0, $a0				#Guardo mi cadena en $t0
	lb $t2, fin_linea			#Asigno el fin de linea a $t2
	li $t4, 0				#Inicializo mi registro de contar
	li $t6, 45				#Inicilizo mi registro con el signo "-" en ASCII, que es 45
	li $t3, 0				#nicializo mi registro de índice de letra de frase
#	li $t5, 10				#Creo mi registro para multiplicar por 10

	lb $t1, cadena($zero)
	
	beq $t1, $t6, negativo			#Compruebo si la frase es negativa
	
	li $t6, 1				#Guardo el signo de la frase "+" en $t6
	bne $t1, $t6, bucle			#Si no es negativa voy directamente al bucle
	
negativo:
	li $t3, 1				#Comienzo en el segundo caracter porque es negativo
	li $t6, -1				#Guardo el signo "-" de la frase en $t6

bucle:
	
	lb $t1, cadena($t3)			#Saco el caracter
	addi $t3, $t3, 1			#Aumento el contador
	
#	mult $t4, $t5 				#Aumento mi registro que cuenta
#	mtlo $t4				#Dejo el t4 el resultado de la multiplicación
	subi $t5, $t1, 48			#Convierto la letra en su entero
	add $t4, $t4, $t5			#Aumento el valor del contador con l entero.
		
	bne $t1, $t2, bucle			#Comparo para saber si he llegado al fin de linea
	
	mult $t4, $t6
	mtlo $t4
	
	li $v0, 4
	la $a0, resultado
	syscall					#Escribo la frase resulado
	
	li $v0, 1
	move $a0, $t4
	syscall					#Escribo el resultado
	
	li $v0, 10
	syscall					#Termino el programa
