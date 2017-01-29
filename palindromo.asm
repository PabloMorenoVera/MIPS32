.data
	frase: .space 1024
	fin_frase: .asciiz "\n"
	si_palindromo: .asciiz "Es un palíndromo"
	no_palindromo: .asciiz "No es un palíndromo"
	
.text
	la $a0, frase
	li $v0, 8
	li $a1, 1024
	syscall				#Leo la frase
	
	lb $t0, frase			#Cargo en $t0 el valor de la primera letra.
	
	li $t3, 0			#Inicializo el bucle para buscar la ultima letra.
	lb $t4, fin_frase		#Guardo el valor que indica final de frase.
	
Encontrar_fin: lb $t2, frase($t3)		#Guardo para comparar.

		addi $t3, $t3, 1		#Actualizo el bucle.
		bne $t2, $t4, Encontrar_fin	#Comparo.
		
	addi $t3, $t3, -2		#Guardo el valor de la última letra en $t1, utilizo el -2 porque tengo un addi dentro del bucle entonces estaría en el \0 y tendría 
	lb $t1, frase($t3)		#que quitarme el \n también.
	
	li $t2, 0			#Pongo el contador a 0 para la 1ºpalabra.	
	
Iguales: lb $t0, frase($t2)
		lb $t1, frase($t3)
		
		bge $t2, $t3, palindromo	#Compruebo si he llegado al centro de la frase o me he pasado, entonces es palíndromo.	
		
		beq $t0, 32, Espacio1		#Si es un espacio paso al siguiente.
		beq $t1, 32, Espacio2		#Si es un espacio paso al siguiente.
		
		addi $t2, $t2, 1
		addi $t3, $t3, -1		#Actualizo los valores.
		
		beq $t0, $t1, Iguales		#Comparo si siguen siendo iguales.
		bne $t0, $t1, No_Pal		#Comparo, si no es palíndromo termino el programa.
		
Espacio1: addi, $t2, $t2, 1			#Si es un espacio lo salto.
		b Iguales
		
Espacio2: addi $t3, $t3, -1			#Si es un espacio lo salto.
		b Iguales						
	
No_Pal: li $v0, 4
		la $a0, no_palindromo
		syscall				#No son iguales, asi que no es palíndromo.
	
		li $v0, 10
		syscall				#Termino el programa.	
	
palindromo: li $v0, 4
		la $a0, si_palindromo
		syscall				#Son todas las letras iiguales, es palíndromo.
	
		li $v0, 10
		syscall				#Termino el programa.
		
