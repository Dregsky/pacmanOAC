.data 

			  # SI,SI,F#,D#,SI,F#,D#,DO,DO,G ,MI,DO,G ,MI,SI,SI,F#,D#,SI,F#,D#,RE,D#,MI,FA,G ,G#,LA,A#,SI
	NOTAS_MUSICA: .word 71,83,66,63,71,66,63,72,72,67,64,72,67,64,71,83,66,63,71,66,63,62,63,64,65,67,68,69,71,71
	DURACAO_NOTA: .word 300,300,300,300,300,200,400,300,300,300,300,300,200,400,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200 

.text

MUSICA_INICIAL:
	li $s1,30
	la $s0,NOTAS_MUSICA
	la $s2,DURACAO_NOTA
	li $t0,0
	li $a2,5		# instrumento
	li $a3,75		# volume

loop_musica:	
	beq $t0,$s1, fim_musica
	lw $a0,0($s0)		# nota
	lw $a1,0($s2)		# duracao
	li $v0,31		# 33 da pausa a mais
	syscall
	move $a0,$a1
	jal STOP
	addi $s0,$s0,4		# proxima nota
	addi $s2,$s2,4		# proxima duração
	addi $t0,$t0,1
	j loop_musica
fim_musica:	
	li $v0,10
	syscall

STOP:
	li $t1,-1
LOOP_STOP:	
	addi $t1,$t1,1
	bne $t1,$a0,LOOP_STOP
	jr $ra