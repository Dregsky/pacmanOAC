.eqv VGA_BASE 0xFF000000
.eqv X 320
.eqv Y 240
.eqv XC 159
.eqv YC 119

.data 
ERRO_PONTO: .asciiz "Ponto fora do limite"
ERRO_POLIGONO: .asciiz "Número de vértices <= 3. Não forma um polígono."
map: .byte 0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,
              0xFF,0XF0,0xFF,0xFF,0XF0,0xFF,0xFF,0XF0,0xFF,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0xFF,0X9E,
              0X9E,0xFF,0XF0,0xFF,0XFA,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,0xFF,0XF0,0xFF,0XFA,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,0xFF,0XF0,0xFF,0X9E,
              0X9E,0xFF,0XF0,0xFF,0X9E,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0X9E,0xFF,0XF0,0xFF,0X9E,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0X9E,0xFF,0x00,0xFF,0X9E,
              0X9E,0xFF,0XF0,0xFF,0XFA,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,0xFF,0XF0,0xFF,0XFA,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,0xFF,0XF0,0xFF,0X9E,
              0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0xFF,0X9E,
              0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,,0xFF,0XF0,0xFF,0X9E,0xFF,0XF0,0xFF,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0xFF,0XF0,0xFF,0X9E,
              0X9E,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0xFF,0X9E,
              0X9E,0xFF,0xFF,0xFF,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,0xFF,0XF0,0xFF,0XFA,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,
              0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0X9E,0xFF,0XF0,0xFF,0X9E,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
              0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XFA,0xFF,0xFF,0xFF,0X9E,0xFF,0XF0,0xFF,0XFA,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0XC0,0X00,
              0X00,0xFF,0x00,0xFF,0xFF,0xFF,0xFF,0X9E,0xFF,0xFF,0xFF,0xFF,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0,0xFF,0XF0, 


.text
	jal MAPA
	li $v0,10
	syscall
	
MAPA:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	la $s0,map
	li $s1,0
	li $s2,118
	li $s3,158
while_mapa:
	beq $s2,$zero,exit_mapa	
	beq $s1,$s3,reseta_x
	move $a0,$s1
	move $a1,$s2
	lbu $a2,0($s0)
	jal PONTO
	addi $s1,$s1,1
	addi $s0,$s0,1
	j while_mapa
reseta_x:
	li $s1,0
	addi $s2,$s2,-1
	j while_mapa
exit_mapa:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

PONTO:
	addi, $sp,$sp,-24
	sw $ra,20($sp)
	sw $s4,16($sp)
	sw $s3,12($sp)
	sw $s2,8($sp)
	sw $s1,4($sp)
	sw $s0,0($sp)
	la $s0, XC
	la $s1, YC
	move $s3, $a0
	move $s4, $a1
	add $a0,$s0,$s3 # $a0 = xc+x
	add $a1,$s1,$s4 # $a1 = yc+y
	move $a2,$s2
	jal PIXEL # xc+x, yc-y
	add $a0,$s0,$s3 # $a0 = xc+x
	sub $a1,$s1,$s4 # $a1 = yc-y
	move $a2,$s2 # $a2 = cor
	jal PIXEL # xc+x, yc-y
	sub $a0,$s0,$s3 # $a0 = xc-x
	add $a1,$s1,$s4 # $a1 = yc+y
	move $a2,$s2 # $a2 = cor
	jal PIXEL # xc-x, yc+y
	sub $a0,$s0,$s3 # $a0 = xc-x
	sub $a1,$s1,$s4 # $a1 = yc-y
	move $a2,$s2 # $a2 = cor
	jal PIXEL # xc-x, yc-y
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	lw $s3,12($sp)
	lw $s4,16($sp)
	lw $ra,20($sp)
	addi $sp,$sp,24
	jr $ra
	
#$a0 = x, $a1 =y0xFF, $a2 = cor	
PIXEL: 	la $t0, VGA_BASE
	la $t2, X
	la $t3, Y
	slt $t4,$a0,$t2 # a0 < $t2(X)
	beqz $t4,ponto_fora_limite
	slt $t4,$a1,$t3 # a1 < $t3(Y)
	beqz $t4,ponto_fora_limite
	mul $t1, $a1, $t2 # $t1 = $a1(y) * 320; 
	add $t1, $t1, $a0 # $t1 = $t1($a1(y) * 320) + $a0(x); 
	add $t0, $t0, $t1 # $t0 = 0xFF000000 + y * 320 + x
	sb $a2, 0($t0) # salva $a2 (cor) no byte que $t0 corresponde.
	addi $v0,$zero,0
	jr $ra
ponto_fora_limite:
	addi $v0,$zero,4 # x ou y estão fora do limite
	la $a0, ERRO_PONTO
	syscall
	jr $ra
	
# argumentos $a0=x1, $a1=y1, $a2=x2, $a3=y2, $sp = cor 								
RETA: 	lw $s5, 0($sp)
	addi $sp, $sp, -28
	sw $ra, 0($sp)	
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	li $s4,1
	slt $t6,$a2,$a0 # $t6 = 1 se $a2(x2) < $a0(x1); $t6 = 0 se não.
	beqz $t6, else1 # $t6 = 0 vai para else
	move $t0, $a0 # $t0 = $a0(x1)
	move $t1, $a1 # $t1 = $a1(y1)
	move $a0,$a2 # $a0(x) = $a2(xf)
	move $a1, $a3 # $a1(y) = $a3(yf)
	move $s3, $t0 # $s3(xf) = $t0(x1)
	move $a3, $t1 # $a3(yf) = $t1
	j endif1 
else1:	move $s3, $a2 # $s3(xf) = $a2(x2) (x já é $a0 e y já é $a1)
endif1:	sub $t0,$s3,$a0 # $t0 = dx = x2-x1 (dx sempre maio que zero devido a inversao feita acima)
	beqz $t0,reta_vertical # dx = 0, ir para branch reta_vertical (x não varia)
	sub $t1,$a3,$a1 # $t1 = dy = y2-y1
	beqz $t1,reta_horizontal # dy = 0, ir para branch reta_horizontal (y não varia)
	slti $t2,$t1,0 # se dy < 0 então $t2 = 1.se dy >= 0 então $t2 = 0
	beqz $t2, dy_positivo # $t2 = 0 então dy >=00xFF, vai para label dy_positivo. Se dy < 0 continua na linha de baix0
	mul $t3, $t1,-1 # como dy < 0, multiplicamos por -1, para obter seu valor em modulo.
	slt $t2,$t3,$t0 # $t2 = 1 se |dy| < |dx|; se $t2 = 0. |dy| > |dx|
	beqz $t2, OCTANTE_TRES_SETE # se |dy| > |dx| vai para OCTANTE_TRES_SETE. se |dy| < |dx| continua na proxima linha (OCTANTE_QUATRO_OITO)
OCTANTE_QUATRO_OITO:
	sll $s1, $t1, 1 # $s1 = dy * 2	
	add $s0,$s1,$t0 # p = $s0 = 2 * dy + dx
	add $s2,$t1,$t0 # $s2 = dy + dx
	sll $s2,$s2,1 # p2 = $s2 = 2 * (dy + dx)
	move $a2,$s5
	jal PONTO
while_reta_quatro_oito:	
	slt $t0,$a0,$s3  # $t0 = 1 se $a0(x) < $s3(xf); $t0 = 0 se não.
	bnez $t0, continua_reta_quatro_oito # se $t0 = 1 continua (x < xf). se x = xf. verifica na proxima linha se y = yf 
	slt $t0,$a3,$a1  # $t0 = 1 se $a3(yf) < $a0(y) ; $t0 = 0 se não.
	beqz $t0, exit_reta # se $t0 = 00xFF, então y = yf ir para exit... se não y > yf, continua
continua_reta_quatro_oito:
	slti $t0,$s0,0 # $t0 = 1 se $t2(p) < 0 ; $t0 = 0 se não.
	beqz $t0,else_quatro_oito
	add $s0,$s0,$s2 # $s0(p) = $s0(p) + $s2(p2)(2*(dy+dx))
	addi $a0,$a0,1 # x++
	addi $a1,$a1,-1 # y--
	j endif_quatro_oito
else_quatro_oito:	
	add $s0,$s0,$s1 # $s0(p) = $s0(p) + $s1(p1=2*dy)
	addi $a0,$a0,1 # x++
endif_quatro_oito:
	move $a2,$s5
	jal PONTO
	j while_reta_quatro_oito
	
OCTANTE_TRES_SETE:
	sll $s1, $t0, 1 # $s1 = dx * 2	
	add $s0,$s1,$t1 # p = $s0 = dy + 2 * dx
	add $s2,$t1,$t0 # $s2 = dy + dx
	sll $s2,$s2,1 # p2 = $s2 = 2 * (dy + dx)
	move $a2,$s5
	jal PONTO
while_reta_tres_sete:	
	slt $t0,$a0,$s3  # $t0 = 1 se $a0(x) < $s3(xf); $t0 = 0 se não.
	bnez $t0, continua_reta_tres_sete # se $t0 = 1 continua (x < xf). se x = xf. verifica na proxima linha se y >= yf 
	slt $t0,$a3,$a1  # $t0 = 1 se $a3(yf) < $a0(y) ; $t0 = 0 se não.
	beqz $t0, exit_reta # se $t0 = 00xFF, então y = yf ir para exit... se não y > yf, continua
continua_reta_tres_sete:
	slti $t0,$s0,0 # $t0 = 1 se $s0(p) < 0 ; $t0 = 0 se não.
	beqz $t0,else_tres_sete
	add $s0,$s0,$s1 # $s0(p) = $s0(p) + $s1(p1)(2*dx)
	addi $a1,$a1,-1 # y--
	j endif_tres_sete
else_tres_sete:	
	add $s0,$s0,$s2 # $s0(p) = $s0(p) + $s2(p2=2*(dy+dx)))
	addi $a0,$a0,1 # x++
	addi $a1,$a1,-1 # y--
endif_tres_sete:
	move $a2,$s5
	jal PONTO
	j while_reta_tres_sete

dy_positivo:
	slt $t2,$t1,$t0 # $t2 = 1 se |dy| < |dx|; se $t2 = 0. |dy| > |dx|
	beqz $t2, OCTANTE_DOIS_SEIS # se |dy| > |dx| vai para OCTANTE_DOIS_SEIS. se |dy| < |dx| continua na proxima linha (OCTANTE_UM_CINCO)	
OCTANTE_UM_CINCO:
	sll $s1, $t1, 1 # $s1 = 2*dy
	sub $s0,$s1,$t0 # p = $s0 = 2 * dy - dx
	sub $s2,$t1,$t0 # $s2 = dy - dx
	sll $s2,$s2,1 # p2 = $s2 = 2 * (dy - dx)
	move $a2,$s5
	jal PONTO
while_reta_um_cinco:
	slt $t0,$a0,$s3  # $t0 = 1 se $a0(x) < $s3(xf); $t0 = 0 se não.
	bnez $t0, continua_reta_um_cinco # se $t0 = 1 continua (x < xf). se x = xf. verifica na proxima linha se y = yf 
	slt $t0,$a1,$a3  # $t0 = 1 se $a0(y) < $a3(yf); $t0 = 0 se não.
	beqz $t0, exit_reta # se $t0 = 00xFF, então y = yf ir para exit... se não y < yf, continua
continua_reta_um_cinco:
	slti $t0,$s0,0 # $t0 = 1 se $t2(p) < 0 ; $t0 = 0 se não.
	beqz $t0,else_um_cinco
	add $s0,$s0,$s1 # $s0(p) = $s0(p) + $s1(p1=2*dy)
	addi $a0,$a0,1 # x++
	j endif_um_cinco
else_um_cinco:	
	add $s0,$s0,$s2 # $s0(p) = $s0(p) + $s2(p2=2*(dy-dx)))
	addi $a0,$a0,1 # x++
	addi $a1,$a1,1 # y++
endif_um_cinco:
	move $a2,$s5
	jal PONTO
	j while_reta_um_cinco
	
OCTANTE_DOIS_SEIS:
	sll $s1, $t0, 1 # $s1 = 2*dx
	mul $s1, $s1, -1 # $s0 = -2*dx	
	add $s0,$s1,$t1 # p = $s0 = dy - 2*dx
	sub $s2,$t1,$t0 # $s2 = dy - dx
	sll $s2,$s2,1 # p2 = $s2 = 2 * (dy - dx)
	move $a2,$s5
	jal PONTO
while_reta_dois_seis:	
	slt $t0,$a0,$s3  # $t0 = 1 se $a0(x) < $s3(xf); $t0 = 0 se não.
	bnez $t0, continua_reta_dois_seis # se $t0 = 1 continua (x < xf). se x = xf. verifica na proxima linha se y = yf 
	slt $t0,$a1,$a3  # $t0 = 1 se $a0(y) < $a3(yf); $t0 = 0 se não.
	beqz $t0, exit_reta # se $t0 = 00xFF, então y = yf ir para exit... se não y < yf, continua
continua_reta_dois_seis:
	slti $t0,$s0,0 # $t0 = 1 se $t2(p) < 0 ; $t0 = 0 se não.
	beqz $t0,else_dois_seis
	add $s0,$s0,$s2 # $s0(p) = $s0(p) + $s1(p2 = 2*(dy-dx))
	addi $a0,$a0,1 # x++
	addi $a1,$a1,1 # y++
	j endif_dois_seis
else_dois_seis:	
	add $s0,$s0,$s1 # $s0(p) = $s0(p) + $s1(p1=-2*dx)
	addi $a1,$a1,1 # y++
endif_dois_seis:
	move $a2,$s5
	jal PONTO
	j while_reta_dois_seis
	
		
#reta_vertical
reta_vertical:	
	li $s4,1
	slt $t1,$a1,$a3 
	beq $t1,1,ponto_vertical
	li $s4,-1 	 
ponto_vertical:	
	move $a2,$s5
	jal PONTO
while_vertical:
	sle $t0,$a1,$a3  # $t0 = 1 se $a1(y1) <= $a3(yf); $t0 = 0 se não.
	sle $t1,$a3,$a1	# $t1 = 1 se $a3(yf) <= $a1(y1); $t1 = 0 se não.
	beq $t0,$t1 exit_reta # se $t0 = $t1, ou seja, $a1 = $a3 ir para exit...
	add $a1,$a1,$s4
	move $a2,$s5 
	jal PONTO
	j while_vertical
#fim_reta_vertical
#reta_horizontal	
reta_horizontal:	
	sub $t1,$s3,$a0 # $t1 = dx = x2-x1
	move $a2,$s5
	jal PONTO
while_horizontal:
	sle $t0,$a0,$s3  # $t0 = 1 se $a0(x1) <= $t4(xf); $t0 = 0 se não.
	sle $t1,$s3,$a0	# $t1 = 1 se $t3(xf) <= $a1(x1); $t1 = 0 se não.
	beq $t0,$t1 exit_reta # se $t0 = $t1, ou seja, $a0 = $t3(x2) ir para exit...
	addi $a0,$a0,1
	move $a2,$s5 
	jal PONTO
	j while_horizontal	
#fim_reta_horizontal		
exit_reta:
	add $v0,$zero,$zero
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr $ra
	
#argumentos $a0 = num_vertices, $a1 = cor, $sp + num_vertices*8 = pares x,y dos vertices
POLIGONO:
	slti $t0,$a0,3
	bnez $t0,erro_num_vertices #poligono têm de ter pelo menos 3 vertices
	move $t0,$sp # guarda o valor de $sp em $t00xFF, para poder recuperar os vertices
	addi $sp,$sp,-20
	sw $ra,16($sp)
	sw $s0,12($sp)
	sw $s1,8($sp)
	sw $s2,4($sp)
	sw $s3,0($sp)
	move $s0,$t0 # $s0 carrega agora o valor de $sp de antes do precedimento POLIGONO ser chamado 
	move $s1,$a0 # guarda $a0(num_vertices) em $s1
	move $s2,$a1 # guarda a cor($a1) em $s2
	addi $s3,$zero,1 # $s3 = 0
	lw $a0,0($s0) # carrega  xInicial
	lw $a1,4($s0) # carrega yInicial
	addi $s0,$s0,8 # atualiza o topo da pilha para depois dos valores já lidos (xInicial e yInicial)
	addi $sp,$sp,-12 # empilha uma word para colocar a cor(necessario no procedimento reta)
	sw $s2,0($sp) # guarda a cor na memoria (utilizado no procedimento reta)
	sw $a0,4($sp) # guarda o valor do xInicial
	sw $a1,8($sp) # guarda o valor do yInicial	
for_poligono:
	slt $t0,$s3,$s1 # $t0 = 1 se $s3 < $s1; $t0 = 0, se não
	beqz $t0, ultima_reta_poligono
	lw $a2,0($s0) # le o proximo x
	lw $a3,4($s0) # le o proximo y
	jal RETA # reta entre os dois primeiros pontos
	lw $a0,0($s0) # faz o ponto destino ser o de origem
	lw $a1,4($s0) # faz o ponto destino ser o de origem
	addi $s0,$s0,8 # atualiza o topo para depois dos valores ja lidos (xOrigemNovo, yOrigemNovo) 
	addi $s3,$s3,1
	j for_poligono # volta para o for_poligono
ultima_reta_poligono:
	lw $a2,4($sp) # lendo ponto inicial x
	lw $a3,8($sp) # lendo ponto inicial y
	jal RETA
	lw $s2,0($sp)
	addi $sp,$sp,12
exit_poligono:
	lw $s3,0($sp)
	lw $s2,4($sp)
	lw $s1,8($sp)
	lw $s0,12($sp)
	lw $ra,16($sp)
	addi $sp,$sp,20
	addi $v0,$zero,0
	jr $ra
	
erro_num_vertices:
	addi $v0,$zero,4 #indica erro, poligono não tem vertices minimos
	la $a0, ERRO_POLIGONO
	syscall
	jr $ra
