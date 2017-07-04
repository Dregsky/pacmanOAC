.data 
			  # SI,SI,F#,D#,SI,F#,D#,DO,DO,G ,MI,DO,G ,MI,SI,SI,F#,D#,SI,F#,D#,RE,D#,MI,FA,G ,G#,LA,A#,SI
	NOTAS_MUSICA: .word 71,83,78,75,83,78,75,72,84,79,76,84,79,76,71,83,78,75,83,78,75,75,76,77,77,78,79,79,80,81,83
	DURACAO_NOTA: .word 60,60,60,60,60,60,180,60,60,60,60,60,60,60,60,60,60,60,60,60,180,60,60,60,60,60,60,60,60,60,120 
.text

MUSICA_INICIAL:
	li $s1,31		# QUANTIDADE NOTAS
	la $s0,NOTAS_MUSICA
	la $s2,DURACAO_NOTA
	li $t0,0
	li $a2,1		# instrumento
	li $a3,75		# volume

loop_musica:	
	beq $t0,$s1, fim_musica
	lw $a0,0($s0)		# nota
	lw $a1,0($s2)		# duracao
	li $v0,33		# 33 da pausa a mais
	syscall 
	addi $s0,$s0,4		# proxima nota
	addi $s2,$s2,4		# proxima duração
	addi $t0,$t0,1
	j loop_musica
fim_musica:	
	li $v0,10
	syscall

