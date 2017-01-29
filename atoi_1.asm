.data
	cadena: .space 1024
	fin_frase: .asciiz "\n"
	resultado: .asciiz "El resultado es: "
	no_numero: .asciiz "Has introducido un caracter no representable"
	
.text
main: li $v0, 8
	la $a0, cadena
	li $a1, 1024
	syscall					#Leo  la cadena
	
	move $t0, $a0				#Guardo mi cadena en $t0
	lb $t2, fin_frase			#Asigno el fin de linea a $t2
	li $t3, 0				#nicializo mi registro del bucle
	li $t4, 0				#Inicializo mi registro de contar
	li $t6, 10				#Creo mi registro para multiplicar por 10

bucle: lb $t1, cadena($t3)			#Saco el caracter
	beq $t1, $t2, fin_linea
	addi $t3, $t3, 1			#Aumento el contador
	
	subi $t5, $t1, 48			#Convierto la letra en su entero
	subi $t5, $t5, 48
	
	bltz $t5, no_digito			
	bgt $t5, 9, no_digito			#Comparo si son digitos [0-9]
	
	add $t4, $t4, $t5			#Aumento el valor del contador con el entero.
	
	mult $t4, $t6				#Aumento mi registro que cuenta
	mflo $t4				#Dejo el t4 el resultado de la multiplicación	
		
	bne $t1, $t2, bucle			#Comparo para saber si he llegado al fin de linea
	addi $t4, $t4, 38			#Aumento el valor del \n restado antes de salir
	
fin_linea: div $t4, $t4, 10
	li $v0, 4
	la $a0, resultado
	syscall					#Escribo la frase resulado
	
	li $v0, 1
	move $a0, $t4
	syscall					#Escribo el resultado
	
	li $v0, 10
	syscall					#Termino el programa
	
no_digito: li $v0, 4
	la $a0, no_numero
	syscall
	
	li $v0, 10
	syscall
