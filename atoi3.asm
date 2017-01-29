.data
	cadena: .space 1024
	fin_linea: .asciiz "\n"
	resultado: .asciiz "El resultado es: "
	
.text
main: li $v0, 8
	la $a0, cadena
	li $a1, 1024
	syscall					#Leo  la cadena
	
	move $t0, $a0				#Guardo mi cadena en $t0
	lb $t2, fin_linea			#Asigno el fin de linea a $t2
	li $t3, 0				#nicializo mi registro del bucle
	li $t4, 0				#Inicializo mi registro de contar
	li $t6, 10				#Creo mi registro para multiplicar por 10

bucle: lb $t1, cadena($t3)			#Saco el caracter
	addi $t3, $t3, 1			#Aumento el contador
	
	subi $t5, $t1, 48			#Convierto la letra en su entero
		
	bltz $t5, no_digito			#Compruebo que está por encima del 0
	bgt $t5, 9, no_digito			#Compruebo que está por encima del 9
		
	add $t4, $t4, $t5			#Aumento el valor del contador con el entero.
		
	mult $t4, $t6 				
	mflo $t4				#Multiplico para guardar el siguiente valor en la siguiente posicion		
		
	bne $t1, $t2, bucle			#Comparo para saber si he llegado al fin de linea
	
	addi $t4, $t4, 38			#Aumento el valor del \n restado antes de salir
	
no_digito: beqz $t5, digito_0
	
	div $t4, $t6
	mflo $t4				#Quito el último cero del número
	
digito_0: li $v0, 4
	la $a0, resultado
	syscall					#Escribo la frase resulado
	
	li $v0, 1
	move $a0, $t4
	syscall					#Escribo el resultado
	
	li $v0, 10
	syscall					#Termino el programa
