pilha	segment stack
	db	128 dup(?)	;inicia
pilha	ends

dados	segment
mens1	db	'Digite um numero (para finalizar tecle ENTER):#'
mens2	db	'Deixe de ser burro digite um numero!#'
numeros db	128 dup(?)
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
	mov	cl,128d
bola2:	mov	al,[bx]
	cmp	al,'#'
	jz	bola1
	call	video; exibe a mensagem 1 por caracter
	inc	bx
	jmp	bola2
bola1: call tec ;chama rotina do teclado
       cmp al,0dh
       jz fim ; finaliza o programa
       cmp al,30h
       jl bola3
       cmp al,39h
       jg bola3
       mov [si],al
       call video		
       inc si
       dec cl
       jz  fim
       jmp bola1

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
