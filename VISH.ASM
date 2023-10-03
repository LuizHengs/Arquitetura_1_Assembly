pilha segment stack
    db 9 dup(?) ; inicia
pilha ends

dados segment
mens1 db "Digite a primeiraS nota: #"
mens2 db "Digite a segunda nota: #"
mens3 db "Digite a terceira nota: #"
mensE db "Voce nao digitou um numero!#"

nota1 db 3 dup(?)
nota2 db 3 dup(?)
nota3 db 3 dup(?)
nota1b db 1 dup(?)
nota2b db 1 dup(?)
nota3b db 1 dup(?)
mediab db 1 dup(?)
media db 3 dup(?)
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

notas:  call QuebraLn
        clc
        cmp ch, 1d
        jz verN3
        cmp ch, 2d
        jz verN2
        cmp ch, 3d
        jz verN1
        call Transf
        
verN1:  lea bx, mens1
        lea si, nota1
        
        dec ch
        mov cl, 3d
        jmp exibir
        

verN2:  clc
        lea bx, mens2
        lea si, nota2
        dec ch
        mov cl, 3d
        jmp exibir

verN3:  clc
        lea bx, mens3
        lea si, nota3
        dec ch
        mov cl, 3d
        jmp exibir
        

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
        jz notas
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

QuebraLn proc near
        push ax

        mov al, 0dh
        call video

        mov al, 0ah
        call video

        pop ax
        ret
QuebraLn endp

Transf proc near
        push ax
        push bx
        push cx
        push dx

        lea si, nota1
        mov al, [si]
        call video
        inc si
        mov al, [si]
        call video 
        inc si
        mov al, [si]
        call video 
        lea si, nota1
        lea di, nota1b
        call AscToBin
        lea si, nota2
        mov al, [si]
        call video
        inc si
        mov al, [si]
        call video 
        inc si
        mov al, [si]
        call video
        lea si, nota2
        lea di, nota2b
        call AscToBin
        lea si, nota3
        lea di, nota3b
        call AscToBin
        lea di, mediab
        call mediar
        lea si, media
        call BinToAsc
        lea si, media
        mov al, [si]
        call video

        pop dx
        pop cx
        pop bx
        pop ax
        
Transf endp

AscToBin proc near
            push ax
            push bx
            push cx
            push dx
            
            ;lea di, nota1b
            ;mov dl, 0
            ;mov [di], dl
            inc si
            inc si
            mov cl, 3
            clc
subtrair:  xor ax, ax
            mov ax, [si]
            sub ax, 30h
            mov [si], ax
            dec si
            dec cl
            jz subtrair
            inc si

                clc
                mov bl, 0ah
                mov ch, 2
                mov cl, ch
multip:         mov ax, [si]
                mul bl
                xor ah, ah
                mov [si], al
                dec cl
                jnz multip
                dec si
                dec ch
                mov cl, ch
                cmp ch, 0
                jnz multip
                
                xor ax, ax
                clc
                mov cl, 3
somar:          mov bx, [si]
                add ax, bx
                inc si
                dec cl
                jne somar
                mov [di], ax

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
        clc
        lea si, nota1b
        mov dx, [si]
        add ax, dx
        clc
        lea si, nota2b
        mov dx, [si]
        add ax, dx
        lea si, nota3b
        mov dx, [si]
        add ax, dx ; Somatório terminado, agora é dividir
        xor dx, dx
        clc
        mov dl, 03h
        div dl
        xor ah, ah
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

                inc si
                inc si
                mov cl, 2
                mov bl, 0ah
                xor ax, ax
                clc
                mov ax, [di]
dividir:        xor ah, ah
                div bl
                cmp ah, 0
                jne adicionar
                mov ah, al
                jmp adicionar
adicionar:      add ah, 30
                mov [si], ah
                dec si
                dec cl
                jnz dividir

                pop dx
                pop cx
                pop bx
                pop ax
                ret
BinToAsc endp
                
codigo ends
    end programa