.data
	Insert_Value: .asciiz "Introduce un valor"
	NewLine: .asciiz "\n"
	End_Program: .asciiz "Terminando programa\n"
	Out_Range_Msg: .asciiz "Memoria dinámica fuera de rango.\n"
	Print_Stack: .asciiz "Imprimiendo pila: \n"
	End_Insert_Value: .asciiz "Introducción de valores terminado.\n"
	Delete_Value: .asciiz "Introduce el valor a eliminar: "
	Not_Found_Msg: .asciiz "Valor a eliminar no encontrado.\n"
	Node_Direction_Msg: .asciiz "El nodo eliminado tiene la dirección:  "
	Node_Value_Msg: .asciiz " con el valor: "
.text

	li $a0, 0
	li $a1, 0
	jal Push
	
loop: li $v0, 4
	la $a0, Insert_Value
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 0, End_loop
	
	move $a0, $s0
	move $a1, $v0
	
	jal Push
	move $s0, $v0
	
	b loop
	
End_loop: li $v0, 4
	la $a0, End_Insert_Value
	syscall
	
	li $v0, 4
	la $a0, Delete_Value
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $s0
	move $a1, $v0
	jal Remove
	
	beqz $v0, Not_Found_Value
	
	move $t0, $v0
	move $t1, $v1
	
	li $v0, 4
	la $a0, Node_Direction_Msg
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, Node_Value_Msg
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	li $v0, 4
	la $a0, NewLine
	syscall
	
Not_Found_Value: li $v0, 4
	la $a0, Print_Stack
	syscall
	
	move $a0, $s0
	jal Print
	
	la $a0, End_Program
	syscall
	
	li $v0, 10
	syscall

Push: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	addiu $fp, $sp, 32
	
	move $s0, $a0
	move $s1, $a1
	
	li $v0, 9
	li $a0, 8
	syscall
	
	beqz $v0, Out_Range 
	
	sw $s1, 0($v0)
	sw $s0, 4($v0)

	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Out_Range: li $v0, 4
	la $a0, Out_Range_Msg	
	syscall
	
	li $v0, 10
	syscall
	
Remove: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	addiu $fp, $sp, 32
	
	move $s0, $a0
	move $s1, $a1
	move $t1, $a0
	
Search_Value: beqz $s0, Not_Found
	lw $s2, 0($s0)
	beq $s1, $s2, Delete
	move $s3, $s0
	lw $s0, 4($s0)
	b Search_Value
	
Not_Found: li $v0, 4
	la $a0, Not_Found_Msg
	syscall
	li $v0, 0
	b Free_Stack
	
Delete: lw $t0, 4($s0)
	beq $t1, $s0, Delete_Top
	sw $t0, 4($s3)
	
	move $v0, $s0
	move $v1, $s1
	b Free_Stack
	
Free_Stack: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Delete_Top: lw $s0, 4($s0)
	move $v0, $s0
	move $v1, $s1
	
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Print: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	addiu $fp, $sp, 32
	
	beqz $a0, End_Print
	
	move $s0, $a0
	lw $a0, 0($s0)
	
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, NewLine
	syscall
	
	lw $a0, 4($s0)
	jal Print
	
End_Print: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	addiu $sp, $sp, 32
	jr $ra
