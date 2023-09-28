pilha	segment stack
	db	128 dup(?)	;inicia
pilha	ends

dados	segment
mens1	db	'Digite um numero (para finalizar tecle ENTER):#'
mens2	db	'Deixe de ser burro digite um numero!#'
numeros db	128 dup(?)
livre   dw	0	;pode ser que aki esse 0 n seja pra colocar 0, ent pode dar pau
nota1	db	0
nota2	db	0
nota3	db	0
dados ends

codigo	segment
	assume	ss:pilha, cs:codigo, ds:dados, es:dados
teste	proc	far
	push	ds
	xor	ax,ax
	push	ax
	mov	ax,dados
	mov	ds,ax
	mov	es,ax	;ds e es segmento de dados com valor dados
	call	limpa
	mov	dx,0
	call	pos
	lea	bx, mens1
	lea	si, numeros
	mov	cl,3d
bola2:	mov	al,[bx]
	cmp	al,'#'
	jz	bola1
	call	video; exibe a mensagem 1 por caracter
	inc	bx
	jmp	bola2
bola1:  call tec ;chama rotina do teclado
        cmp al,0dh
        jz fim ; finaliza o programa
        cmp al,30h
        jl bola3
        cmp al,39h
        jg bola3
        mov [si],al
        call video
        call converteAscii	;primeira alteração
        inc si
        dec cl
        cmp [cl],0		;se cl == 0 vai pra parte de adicionar a nota
        jz mudaNota1		;segunda alteração 
        jmp bola1
mudaNota1: lea si, nota1	
	cmp [si],0
	jnz mudaNota2		;se nota1 não for 0, vai pro loop da nota2
	lea di,livre		;n sei se tem q tratar o di antes ent pode dar pau aki
	mov [si],[di]
	mov cl,3d
	mov [di],0
	call limpa
	call pos
	jmp bola1
mudaNota2: lea si, nota2	
	cmp [si],0
	jnz mudaNota3		;se nota2 não for 0, vai pro loop da nota3
	lea di,livre		;n sei se tem q tratar o di antes ent pode dar pau aki
	mov [si],[di]
	mov cl,3d
	mov [di],0
	call limpa
	call pos
	jmp bola1
mudaNota3: lea si,nota3
	lea di,livre
	mov [si],[di]	;temos as 3 notas agora
	mov [di],0
	call limpa	;daremos prosseguimento ao codigo de forma normal, agora faremos a soma
	call pos
	jmp calcula
calcula:
	lea di,livre	;vamos deixar di fixo em livre, que é a variavel onde haverão os calculos
	lea si,nota1
	clc
	add [di],[si]
	clc
	lea si,nota2
	add [di],[si]
	clc
	lea si,nota3
	add [di],[si]	;agr em livre temos a soma das 3 notas
	
	mov ax,3d		
	div [di]	;di continua apontando para livre
	mov [si],[ah]	;duas coisas 1)si continua apontando para nota3, ideia é que o conteudo esteja
			;sendo colocado em nota3 2)aqui estamos colocando o resto dentro de nota3
			;a ideia eh que aki ja temos o valor da divisão e o resto, então 
			;agr precisamos voltar os valores para ascii
	mov cl,0
botaNaPilha:		;aki a gente vai colocar na pilha os valores na ordem em que eles vão ser
			;printados (por ser pilha ordem inversa no caso)
	mov AX,10d
	div [di]
	push ah
	inc cl	
	cmp al,0	;se o quociente for 0, significa que essa foi a última divisão possível
	jz vamosPrintar
	jmp botaNaPilha
vamosPrintar:
	cmp cl,0
	jz AntesDoFim	;os prints tao em al, so codar pensando em colocar os valores em al e chamar 
			;o video
	pop al
	clc
	sum [al],30	;somando 30 pra voltar pra o valor em ascii antes do print
	call video
	dec cl
	jmp vamosPrintar
AntesDoFim:
	lea si,nota3	;vamos pegar agora o resto da nossa primeira divisão para tratar ele
	cmp nota3,1	;vai pular pra solução 0 se menor, 1 se igual e 2 se maior
	jl caso0
	jz caso1
	jg caso2
caso0:			;printa '.' e um número decimal equivalente ao resto (0 se 0, 3 se 1, 7 se 2)
	mov al,'.'
	call video
	mov al,30h
	call video
	jmp fim
caso1:
	mov al,'.'
	call video
	mov al,33h
	call video
	jmp fim
caso2:
	mov al,'.'
	call video
	mov al,37h
	call video
	jmp fim
bola3: lea di,mens2
       mov al,0dh
       call video
       mov al,0ah
       call video
bola4: mov al,[di]
       cmp al,'#'
       jz bola5
       call video
	inc	di
	jmp	bola4
bola5:	mov	al,0dh
	call	video
	mov	al,0ah
	call	video
	jmp	bola1
fim:	ret
teste	endp

video	proc	near
	push	si
	push	bx
	push	di
	push	cx
	mov	bx,0
	mov	ah,14
	int	10h
	pop	cx
	pop	di
	pop	bx
	pop	si
	ret
video	endp

;dl,dh posiciona o cursor
pos proc near
    push AX
    push BX
    push cx
    xor BX,BX
    mov AH,2
    int 10h
    pop cx
    pop bx
    pop ax
    ret
pos endp

tec	proc	near
	push	di
	push	bx
	push	si
	push	cx
	mov	ah,0
	int	16h
	pop	cx
	pop	si
	pop	bx
	pop	di
	ret
tec	endp

converteAscii proc near
      push AX
      push BX
      push CX
      push DX
      push DI
      clc			;limpando carry
      lea di,livre		;usando di pq o si ta com o valor que o usuário acabou de inserir
      mul [di],0ah		;a cada vez q tem um novo número tem que multiplicar o existente por 10
      clc
      sub [si],30		;subtraindo por 30 pra pegar o binario
      clc
      sum [di],[si]
      pop DI
      pop DX
      pop CX
      pop BX
      pop AX
      ret	
converteAscii endp

limpa proc near
      push AX
      push BX
      push CX
      push DX
      xor al,al
      xor cx,cx
      mov dh,24
      mov dl,79
      mov bh,07h
      mov ah,06
      int 10h
      pop DX
      pop CX
      pop BX
      pop AX
      ret
limpa endp

codigo	ends
	end	teste	
