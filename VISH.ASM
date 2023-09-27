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
        lea bx, mens1
        lea si, nota1
        mov cl, 3d
exibir: mov al, [bx]
        cmp al, '#'
        jz teclar
        call video
        inc bx
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
codigo ends
    end programa