pilha segment stack
    db 128 dup(?) 
pilha ends

dados segment
mens1 db "Digite a primeirissima nota (entre 00,0 e 10,0): #"
mens2 db "Digite a segundissima nota (entre 00,0 e 10,0): #"
mens3 db "Digite a terceirissima nota (entre 00,0 e 10,0): #"
mensMe db "Esta eh sua media: #"
mensA db "Bem vindo ao ceu: voce foi aprovado!!#"
mensF db "Voce tem uma chance!! Para ser aprovado na prova final precisa tirar #"
mensR db "Boa noticia: nos veremos periodo que vem! Mas o ruim eh que voce nao passou...#"
mensE db "Voce nao digitou um numero!#"
mensEUm db "Voce nao pode digitar mais do que 1 nesse algarismo das dezenas!#"

nota1 db 3 dup(?)
nota2 db 3 dup(?)
nota3 db 3 dup(?)
nota1b db 1 dup(?)
nota2b db 1 dup(?)
nota3b db 1 dup(?)
mediab db 1 dup(?)
media db 3 dup(?)
precisab db 1 dup(?)
precisa db 3 dup(?)

dados ends

codigo segment
    assume cs:codigo, ss:pilha, ds:dados, es:dados 


programa proc far
        push ds
        xor ax,ax
        push ax
        mov ax,dados
        mov ds,ax
        mov es,ax
        call limpar
        cmp dl, 0ah
        je fim
        xor dx,dx
        call pos
        mov ch, 3d ;Diferencia entre as três notas

notas:  call QuebraLn
        clc
        cmp ch, 1d
        jz verN3
        clc
        cmp ch, 2d
        jz verN2
        clc
        cmp ch, 3d
        jz verN1
        clc
        jmp Transf
        ret
        
verN1:  lea bx, mens1
        lea si, nota1
        clc
        
        dec ch
        mov cl, 3d
        jmp exibir
        

verN2:  clc
        lea bx, mens2
        lea si, nota2
        clc

        dec ch
        mov cl, 3d
        jmp exibir

verN3:  clc
        lea bx, mens3
        lea si, nota3
        clc

        dec ch
        mov cl, 3d
        jmp exibir
        

exibir: mov al, [bx]
        cmp al, '#'
        jz teclar
        call video
        inc bx
        cmp cl, 0
        jz notas
        jmp exibir
fim:    jmp fimP
teclar: call teclado
        cmp al,0dh
        jz fim ;Se tiver apertado enter, é o fim do programa 
        cmp al,30h
        jl errado
        cmp al,39h
        jg errado
        cmp cl, 3
        je Um

colocar:
        mov [si], al
        call video
        inc si
        dec cl
        jz notas
        cmp cl, 1
        jne teclar
        mov al, 2ch
        call video
        jmp teclar

Um:
        cmp al, 31h
        jg erraUm
        jne colocar
        mov [si], al
        call video
        inc si
        mov al, 30h
        mov [si], al
        call video
        mov al, 2ch
        call video
        inc si
        mov al, 30h
        mov [si], al
        call video
        jmp notas

erraUm: lea di, mensEUm
        clc
        mov al,0ah
        call video
        mov al, 0dh
        call video
        jmp mensErr

errado: lea di, mensE
        clc
        mov al,0ah
        call video
        mov al, 0dh
        call video
mensErr:       
        mov al,[di]
        cmp al, '#'
        jz correcEr
        call video
        inc di
        jmp mensErr

correcEr: 
        inc ch
        jmp notas

Transf:
        call QuebraLn
        lea si, nota1
        clc
        lea di, nota1b
        clc
        call AscToBin
        lea si, nota2
        clc
        lea di, nota2b
        clc
        call AscToBin
        lea si, nota3
        clc
        lea di, nota3b
        clc
        call AscToBin
        lea di, mediab
        clc
        call mediar
        lea si, media
        clc
        lea di, mediab
        clc
        call BinToAsc


        xor ax, ax
        lea bx, mensMe
        clc
        call mostMens

numMe:  lea si, media
        clc
        xor cx, cx
        mov cl, 3
mostrarM:       mov al, [si]
                call video
                cmp cl, 2
                jne continue
                mov al, 2ch
                call video
continue:       inc si
                dec cl
                jnz mostrarM

        call QuebraLn

        lea di, mediab
        clc
        mov al, [di]
        cmp al, 69
        jg Great
        cmp al, 40
        jge Kinda
        
        lea bx, mensR
        clc
        call mostMens
        jmp fimP

Great:  
        lea bx, mensA
        clc
        call mostMens
        jmp fimP

Kinda:  
        lea bx, mensF
        clc
        call mostMens

        xor bx, bx ;Cálculo do quanto precisa pra passar na Prova Final, segundo a fórmula antiga do professor Hamilton
        mov bl, 6
        mul bl
        mov bx, 500
        sub bx, ax
        mov ax, bx
        mov bl, 4
        div bl

        lea di, precisab
        clc
        mov [di], al

        lea di, precisab
        clc
        lea si, precisa
        clc
        call BinToAsc

        lea si, precisa
        clc
        xor cx, cx
        mov cl, 3
mostrarP:       mov al, [si]
                call video
                cmp cl, 2
                jne continu2
                mov al, 2ch
                call video
continu2:       inc si
                dec cl
                jnz mostrarP

 fimP:  call QuebraLn
        pop ax
        pop ds

        mov ax, 4c00h ; Usando "terminate" no DOS
        int 21h     
programa endp

limpar proc near
        push ax
        push bx
        push cx
        push dx
        xor al,al
        mov ah,06h
        xor cx,cx
        mov bh,07h
        mov dh,24
        mov dl,79
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
        ret
limpar endp

pos proc near
        push ax
        push bx
        push cx
        push dx
        xor ax,ax
        mov ah,02h
        xor bx,bx
        xor cx,cx
        xor dx,dx
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
        ret
pos endp

teclado proc near
        mov ah, 0
        int 16h
        ret
teclado endp

video proc near
        push si
        push di
        push bx
        push cx
        mov ah, 0eh
        xor bx, bx
        int 10h
        pop cx
        pop bx
        pop di
        pop si
        ret

video endp

QuebraLn proc near
        push ax

        mov al, 0dh
        call video

        mov al, 0ah
        call video

        pop ax
        ret
QuebraLn endp

mostMens proc near
        push ax
        push bx

go:     mov al, [bx]
        cmp al, '#'
        je fim5
        call video
        inc bx
        jmp go
fim5:   pop bx
        pop ax
        ret
mostMens endp

AscToBin proc near
            push ax
            push bx
            push cx
            push dx
            push si
            push di
            
            
            push si
            xor cx, cx
            xor bx, bx
            mov cl, 3
            clc
subtrair:  xor ax, ax
            mov al, [si]
            sub al, 30h
            mov [si], al
            inc si
            dec cl
            cmp cl, 0
            jne subtrair
            pop si

                clc
                push si
                mov bl, 0ah
                xor cx, cx
                xor dx, dx
                mov ch, 2
                mov cl, ch
                xor ax, ax
multip:         clc
                mov al, [si]
                mul bl
                mov [si], al
                dec cl
                jnz multip
                inc si
                dec ch
                mov cl, ch
                cmp ch, 0
                jne multip
                pop si
                
                push si
                xor ax, ax
                xor bx, bx
                clc
                mov bl, [si]
                mov al, bl
                xor cx, cx
                mov cl, 2
                clc
somar:          inc si
                mov al, [si]
                add bl, al
                dec cl
                jnz somar
                pop si

                mov al, bl
                mov [di], bl
                clc

                pop di
                pop si
                pop dx
                pop cx
                pop bx
                pop ax
                ret
AscToBin endp

mediar proc near
        push ax
        push bx
        push cx
        push dx

        xor ax, ax
        xor bx, bx
        xor dx, dx
        clc
        lea si, nota1b
        clc
        mov bl, [si]
        add ax, bx
        ;call video
        clc
        lea si, nota2b
        clc
        mov bl, [si]
        add ax, bx
        ;call video
        clc
        ;call video
        lea si, nota3b
        clc
        mov bl, [si]
        add ax, bx ; Somatório terminado, agora é dividir
        ;call video
        clc 
        xor dx, dx
        ;call video
        clc
        xor bx, bx
        mov bl, 03h
        ;call debug
        div bl
        clc
        ;mov al, ah
        mov [di], al 


        pop dx
        pop cx
        pop bx
        pop ax
        ret
mediar endp

BinToAsc proc near
                push ax
                push bx
                push cx
                push dx
                push si

                xor ax, ax
                mov al, [di]
                push si
                inc si
                inc si
                xor cx, cx
                xor bx, bx
                mov cl, 3
                mov bl, 0ah
                clc
dividir:        div bl
                mov [si], ah
                xor ah, ah
                ;call video
                dec si
                dec cl
                cmp cl, 00h
                jnz dividir
                pop si
                
                mov cl, 3
                xor bx, bx
                clc
                
adicionar:      xor ax, ax
                mov al, [si]
                add al, 30h
                mov [si], al
                ;mov al, ah
                ;call video
                inc si
                dec cl
                jnz adicionar
                

                pop si
                pop dx
                pop cx
                pop bx
                pop ax
                ret
fim3: ret

BinToAsc endp
                
codigo ends
    end programa