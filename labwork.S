  # labwork.S
  # Written 2015 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1 2015-2016.
  # The macros PUSH and POP are in the public domain.

.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm

.global hexasc
.global delay
.global time2string
  # You can add your own code here
  #

hexasc:
	# IF INPUT IN A0 LESS THAN 10
	slti $t0,$a0,0xA
	# INPUT A0 LARGER THAN 10, CALL LETTERCHAR
	beq $t0, 0x0, letterchar
	nop
	# INPUT A0 LESS OR EQUAL TO 10, CALL NUMBERCHAR
	bne $t0, 0x0, numberchar
	nop
numberchar:
	# ADD 0x30 TO A0 FOR ASCII REPRESENTATION OF NUMBER
	addi $v0,$a0,0x30
	#JUMP BACK
	jr $ra
	nop
letterchar:
	# ADD 0x37 TO A0 FOR ASCII REPRESENTATION OF LETTER
	addi $v0,$a0,0x37
	#JUMP BACK
	jr $ra
	nop
    
    
delay:
 	#A0 CONTAINS TARGET MS
 	#T3 CONTAINS ITERATIONS PER MS
 	#T1 CONTAINS THE CURRENT MS
 	#T2 CONTAINS THE CURRENT ITERATION 
 	
 	#RESET T1 AND T2
 	#li $t1, 0x0
 	move $t1,$a0
 	li $t2, 0x0
 	
 	#INITIALIZE T3 TO 0xFF ITERATIONS PER MS
 	li $t3,0xFF
 	
 	#JUMP TO MSDONE
 	j msdone
	
 	nop
 
 msdone:
 	#0x1 or 0x0 ?
 	slti $t5,$t1,0x1
 
 	# CURRENT MS NOT EQUAL TO TARGET MS PER DELAY, KEEP ITERATING
 	bne $t5, 0x1, msdelay
 	nop
 	# CURRENT MS EQUAL TO TARGET MS, PROCEED
 	#JUMP OUT OF DELAY LOOP
 	jr $ra
 	nop
 msdelay:
 	
 	# CURRENT ITERATION NOT EQUAL TO TARGET ITERATIONS PER MS, KEEP ITERATING
 	bne $t2, $t3, forwarddelay
 	nop
 	# CURRENT ITERATION EQUAL TO TARGET ITERATION, PROCEED
 	
 	# WE NOW ADD A MS TO THE COUNT T1
 	addi $t1,$t1, -1
 	#subi $t1,$t1,0x1
 	# RESET CURRENT ITERATION TO 0
 	li $t2,0x0
 	
 	#JUMP TO MSDONE
 	j msdone
 	nop
 	
forwarddelay:
	#ADD TO ITERATION COUNT (T2)
	addi $t2,$t2,0x1
	#JUMP TO MSDELAY
	j msdelay
	nop
    
time2string:

	#SAVE THE ORIGINAL RETURN ADDRESS FOR LATER USE
	PUSH $ra

	#DIGIT 1
	#PUSH ALL REGISTERS USED BY HEXASC, THIS WILL PRESERVE THEM
	PUSH $v0
	PUSH $t0
	PUSH $a0
	
	#MASK BITS FROM A1
	andi $a0,$a1,0xF000
	#SHIFT BITS TO THE RIGHT
	srl $a0,$a0,0xC
	#CONVERT TO ASCII CHARACTER
	jal hexasc
	nop
	
	#RESTORE A0 AND T0 BUT NOT V0 SINCE IT HAS TO BE STORED FIRST
	POP $a0
	POP $t0
	
	#STORE ASCII
	sb $v0,($a0)
	
	#RESTORE V0
	POP $v0

	#DIGIT 2
	#PUSH ALL REGISTERS USED BY HEXASC, THIS WILL PRESERVE THEM
	PUSH $v0
	PUSH $t0
	PUSH $a0
	
	#MASK BITS FROM A1
	andi $a0,$a1,0xF00
	#SHIFT BITS TO THE RIGHT
	srl $a0,$a0,0x8
	#CONVERT TO ASCII CHARACTER
	jal hexasc
	nop
	
	#RESTORE A0 AND T0 BUT NOT V0 SINCE IT HAS TO BE STORED FIRST
	POP $a0
	POP $t0
	
	#STORE ASCII
	sb $v0,0x1($a0)
	
	#RESTORE V0
	POP $v0
	
	# LOAD COLON CAHRACTER IN T0
	li $t0,0x3a
	#STORE ASCII
	sb $t0,0x2($a0)
	
	#DIGIT 3
	#PUSH ALL REGISTERS USED BY HEXASC, THIS WILL PRESERVE THEM
	PUSH $v0
	PUSH $t0
	PUSH $a0
	
	#MASK BITS FROM A1
	andi $a0,$a1,0xF0
	#SHIFT BITS TO THE RIGHT
	srl $a0,$a0,0x4
	#CONVERT TO ASCII CHARACTER
	jal hexasc
	nop
	
	#RESTORE A0 AND T0 BUT NOT V0 SINCE IT HAS TO BE STORED FIRST
	POP $a0
	POP $t0
	
	#STORE ASCII
	sb $v0,0x3($a0)
	
	#RESTORE V0
	POP $v0
	
	#DIGIT 4
	#PUSH ALL REGISTERS USED BY HEXASC, THIS WILL PRESERVE THEM
	PUSH $v0
	PUSH $t0
	PUSH $a0
	
	#MASK BITS FROM A1
	andi $a0,$a1,0xF

	#CONVERT TO ASCII CHARACTER
	jal hexasc
	nop
	
	#RESTORE A0 AND T0 BUT NOT V0 SINCE IT HAS TO BE STORED FIRST
	POP $a0
	POP $t0
	
	#STORE ASCII
	sb $v0,0x4($a0)
	
	#RESTORE V0
	POP $v0
	
	#LOAD NULL ASCII IN T0
	li $t0,0x00
	#STORE ASCII
	sb $t0,0x5($a0)
	
	#RESTORE ORIGINAL RETURN ADDRESS
	POP $ra
	#JUMP TO ORIGINAL RETURN ADDRESS
	jr $ra
	nop