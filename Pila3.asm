.data
	Out_Range_Msg: .asciiz "Memoria reservada fuera de rango.\n"
	Exit_Msg: .asciiz "Saliendo del programa.\n"
	Insert_Value: .asciiz "Intrduce un número: "
	Sentinel_Value_Msg: .asciiz "Valor 0 introducido, terminado modo push.\n"
	Delete_Msg: .asciiz "Introduce el valor que quieres borrar: "
	Not_Found_Msg: .asciiz "Valor a eliminar no encontrado.\n"
	Dir_Delete_Msg: .asciiz "La direccíon borrada es: "
	Value_Delete_Msg: .asciiz " con el valor: "
	NewLine: .asciiz "\n"
.text
main: li $a0, 0
	li $a1, 0
	jal Create
	
	move $s0, $v0
	
loop: li $v0, 4
	la $a0, Insert_Value
	syscall
	
	li $v0,  5
	syscall
	move $s1, $v0
	
	beqz $s1, Sentinel_Value
	
	move $a0, $s0
	move $a1, $s1
	jal Push
	b loop
	
Sentinel_Value: li $v0, 4
	la $a0, Sentinel_Value_Msg
	syscall
	
	li $v0, 4
	la $a0, Delete_Msg
	syscall
	
	li $v0, 5
	syscall
	
	move $s1, $v0
	
	move $a0, $s0
	move $a1, $s1
	jal Delete
	
	move $t0, $a0
	move $t1, $a1
	
	li $v0, 4
	la $a0, Dir_Delete_Msg
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, Value_Delete_Msg
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	li $v0, 4
	la $a0, NewLine
	syscall
	
	move $a0, $s0
	jal Print
	
	li $v0, 4
	la $a0, NewLine
	syscall
	
	b Exit

Create: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	addiu $fp, $sp, 28
	
	move $s0, $a0
	
	li $v0, 9
	li $a0, 8
	syscall
	
	beqz $v0, Out_Range
	
	li $t0, 0
	sw $s1, 0($v0)
	sw $t0, 4($v0)
	
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Push: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	addiu $fp, $sp, 28
	
	move $s0, $a0
	move $s1, $a1
	
	jal Create
	move $s2, $v0
	
Search: lw $t0, 4($s0)
	beqz $t0, Add
	lw $s0, 4($s0)
	b Search
	
Add: sw $s2, 4($s0)
	
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Delete: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	addiu $fp, $sp, 28
	
	move $s0, $a0
	move $s1, $a1
	
	lw $t0, 0($s0)
	beq $t0, $s1, Delete_First
	
Search_D: beqz $s0, Not_Found
	lw $t0, 4($s0)
	lw $t1, 0($t0)
	beq $t1, $s1, Delete_Node
	move $s0, $t0
	b Search_D
	
Delete_Node: move $a0, $t0
	move $a1, $s1
	lw $t2, 4($t0)
	sw $t2, 4($s0)
	b Free_Stack
	
Delete_First: move $a0, $s0
	move $a1, $s1
	lw $s0, 4($s0)
	b Free_Stack
	
Not_Found: li $v0, 4
	la $a0, Not_Found_Msg
	syscall
	b Free_Stack

Free_Stack: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	addiu $sp, $sp, 32
	jr $ra
	
Out_Range: li $v0, 4
	la $a0, Out_Range_Msg
	syscall
	b Exit
	
Exit: li $v0, 4
	la $a0, Exit_Msg
	syscall
	
	li $v0, 10
	syscall
	
Print: subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	addiu $fp, $sp, 28
	
	move $s0, $a0
	beqz $s0, Free_Stack2
	
	lw $s1, 0($s0)
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	lw $a0, 4($s0)
	jal Print
	
Free_Stack2: lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	addiu $sp, $sp, 32
	jr $ra

