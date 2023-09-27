pilha segment stack
    db 9 dup(?) ; inicia
pilha ends

dados segment
mens1 db "Digite a primeira nota: #"
mens2 db "Digite a segunda nota: #"
mens3 db "Digite a terceira nota: #"
mensE db "Você não digitou um número!#"

nota1 db 3 dup(?)
nota2 db 3 dup(?)
nota3 db 3 dup(?)
nota1b db 1 dup(?)
nota2b db 1 dup(?)
nota3b db 1 dup(?)
total dw 1 dup(?)
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
        xor dx,dx
        call pos
        mov ch, 3d ;Diferencia entre as três notas

notas:  cmp ch, 3d
        jz verN1
        cmp ch, 2d
        jz verN2
        cmp ch, 1d
        jz verN3
        cmp ch, 0d
        jz converter
verN1:  lea bx, mens1
        lea si, nota1
        
        mov cl, 3d
        jmp exibir
        jmp verN2

verN2: lea bx, mens2
        lea si, nota2
        mov cl, 3d
        call exibir
        jmp verN3

verN3: lea bx, mens3
        lea si, nota3
        mov cl, 3d
        call exibir
        call

converter: call AsctoBin

exibir: mov al, [bx]
        cmp al, '#'
        jz teclar
        call video
        inc bx
        cmp cl, 0
        jz notas
        jmp exibir
fim:    ret
teclar: call teclado
        cmp al,0dh
        jz fim ;Se tiver apertado enter, é o fim do programa
        cmp al,30h
        jl errado
        cmp al,39h
        jg errado
        mov [si], al
        call video
        inc si
        dec cl
        jz fim
        jmp teclar

errado: lea di, mensE
        mov al,0dh
        call video
        mov al,0ah
        call video

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
        push di
        push bx
        push si
        push cx
        mov ah, 0
        int 16h
        pop cx
        pop si
        pop bx
        pop di
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

AscToBin proc near
            push ax
            push bx
            push cx
            push dx
            mov bl, 100
            lea si, nota1
            lea di, nota1b
            mov dl, 0
            mov [di], dl
            mov cl, 3
            clc
subtrair1:  xor ax, ax
            mov ax, [si]
            sub ax, 30h
            mul bl
            add dl, al
            mov [di], dl
            mov  ax, bl
            mov  bl, 10
            div bl
            mov bl, al
            pop dx
            pop cx
            pop bx
            pop ax
            inc si
            dec cl
            jz ret
            jmp subtrair1
            mov bl, 100
            lea si, nota2
            lea di, nota2b
            mov dl, 0
            mov [di], dl
            mov cl, 3
            clc
subtrair2:  xor ax, ax
            mov ax, [si]
            sub ax, 30h
            mul bl
            add dl, al
            mov [di], dl
            mov  ax, bl
            mov  bl, 10
            div bl
            mov bl, al
            pop dx
            pop cx
            pop bx
            pop ax
            inc si
            dec cl
            jz ret
            jmp subtrair2
            mov bl, 100
            lea si, nota3
            lea di, nota3b
            mov dl, 0
            mov [di], dl
            mov cl, 3
            clc
subtrair3:  xor ax, ax
            mov ax, [si]
            sub ax, 30h
            mul bl
            add dl, al
            mov [di], dl
            mov  ax, bl
            mov  bl, 10
            div bl
            mov bl, al
            pop dx
            pop cx
            pop bx
            pop ax
            inc si
            dec cl
            jz ret
            jmp subtrair3
codigo ends
    end programa