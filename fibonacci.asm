.data
	Frase: .asciiz "Intrduce un número: "

.text
	li $v0, 4
	la $a0, Frase
	syscall				#Pide el número de iteraciones.
	
	li $v0, 5
	syscall				#Recoge el valor de iteraciones "n".
	move $a0, $v0
	
	jal Fibonacci	
	
	li $v0, 1 			#Imprime el resultado.	
	syscall 			
	
	li $v0, 10 			#Termina el programa.
	syscall
	
Fibonacci: subu $sp, $sp, 32		#Fragmento de pila de 32 bytes.
	sw $ra, 20($sp)			#En el byte 20 de la pila guardo la dirección de la siguiente instrucción.
	sw $fp, 16($sp)			#En el byte 16 guardo el puntero del fragmento.
	addiu $fp, $sp, 28		#Actualiz el puntero del fragmento.
	sw $a0, 0($fp)			#Guardo el número "n".
	sw $s0, 4($fp)
	
	bgt $a0, 2, Fib_Recursivo	#Comparo para saber si he llegado al primer valor.
	li $v0, 1			#Guardo el valor de la llamada a Fib con n=1, que es 1.
	b Return_Fib			#Comienzo a computar el resto de valores hasta el n dado.
		
Fib_Recursivo: lw $a0, 0($fp)		# Cargo el valor de n
	subu $a0, $a0, 1		#Resto 1 al valor de n.
	jal Fibonacci			#Vuelvo a llamar a Fibonacci para guardar los datos del nuevo número.
		
Return_Fib: lw $ra, 20($sp)		#Cargo el valor de la instruccion anterior al jal.
	lw $fp, 16($sp)			#Cargo el puntero al valor de la pila anterior.
	addiu $sp, $sp, 32		#Resto el fragmento de la pila para liberarlo.
	jr $ra				#Hago el sato a la nueva instrucción.
