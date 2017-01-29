.data
	cadena: .asciiz "Hola mundo!"
	
.text

	li $v0, 4
	la $a0, cadena		#Guardo cadena para la llamada al sistema.
	syscall			#Imprimo cadena por el terminal.
	
	li $v0, 10
	syscall			#Termina el programa.