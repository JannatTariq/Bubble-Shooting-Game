[org 0x0100]

start:
 call clrscr
 xor ax, ax 
 mov es, ax 
 mov ax, [es:9*4] 
 mov [oldisr], ax  
 mov ax, [es:9*4+2] 
 mov [oldisr+2], ax 
 cli  
 mov word [es:9*4], kbisr 
 mov [es:9*4+2], cs 
 sti 
 xor ax, ax 
 mov es, ax 
 cli 
 mov word [es:8*4], clock
 mov [es:8*4+2], cs 
 sti 

 call up_date1
 call up_date2
 call up_date3
 call up_date4


l2:
 call sleep
 call sleep
 call clrscr
 mov si,[c1]
 push si
 mov si,[c2]
 push si
 mov si,[c3]
 push si
 mov si,[c4]
 push si
 push ax
 push bx
 push cx
 push dx

 call floating
 sub ax,160;		     	;floating ko control kar raha 
 cmp ax,158
 jnz u1
 call up_date1
u1:
  sub bx,160
  cmp bx,158
  jnz u2
  call up_date2
u2:
  sub cx,160
  cmp cx,158
  jnz u3
  call up_date3
u3:
  sub dx,160
  cmp dx,158
  jnz u4
  call up_date4
u4:
 push 0               		; push x position 
 push 0                       	; push y position 
 push 0x31                    	;push attribute 
 mov di, msg1
 push di 
 call printstr 

 push 65                     	; push x position 
 push 0                       	; push y position 
 push 0x31                   	; push attribute 
 mov di, msg2
 push di                     	; push address of message 
 call printstr                	; call the printstr subroutine
 
 push 0
 push 75
 mov di,[points]
 push di
 call printnum
 call sleep
 jmp l2
 mov ax, [oldisr]  
 mov bx, [oldisr+2] 
 cli 
 mov [es:9*4], ax 
 mov [es:9*4+2], bx
 sti 
 mov ax,0x4C00
 int 0x21

floating:
 push bp
 mov bp,sp
 push ax
 push bx
 push cx
 mov cx,[colour2]
 push cx
 mov bx,[bp+12]                 ;alphabet
 push bx
 mov ax,[bp+10]			;right most column ja raha hae 
 sub ax,22        		;axis control kar raha hae yani ke agar mei 80 doon to wo right side se darmian ke kareeb a jae ga
 push ax                        ;location
 call draw
 mov cx,[colour1]
 push cx
 mov bx,[bp+14]                 ;alphabet
 push bx
 mov ax,[bp+8]
 sub ax,62
 push ax
 call draw
 mov cx,[colour3]
 push cx
 mov bx,[bp+16]                 ;alphabet
 push bx
 mov ax,[bp+6]
 sub ax,102
 push ax
 call draw
 mov cx,[colour4]
 push cx
 mov bx,[bp+18]                 ;alphabet
 push bx
 mov ax,[bp+4]
 sub ax,142
 push ax
 call draw
 pop cx
 pop bx
 pop ax
 pop bp
 ret 16

end:
 call clrscr
 mov ax,30                      ; push x position
 push ax
 mov ax,10                      ; push y position 
 push ax
 push 0x31                      ; push attribute 
 mov di, msg2
 push di                        ; push address of message 
 call printstr                  ; call the printstr subroutine
 
 mov ax,10
 push ax
 mov ax,40
 push ax
 mov di,[points]
 push di
 call printnum
 
 mov ax,30                      ; push x position
 push ax
 mov ax,12                      ; push y position 
 push ax
 push 0x31                      ; push attribute 
 mov di, msg3
 push di                        ; push address of message 
 call printstr                  ; call the printstr subroutine
 
 mov ax,12
 push ax
 mov ax,48
 push ax
 mov di,[totalballoons]
 push di
 call printnum
 
 mov ax,30                      ; push x position
 push ax
 mov ax,14                      ; push y position 
 push ax
 push 0x31                      ; push attribute 
 mov di, msg4
 push di                        ; push address of message 
 call printstr                  ; call the printstr subroutine

 mov ax,27                      ; push x position
 push ax
 mov ax,7                       ; push y position 
 push ax
 push 0xAB                      ; push attribute 
 mov di, msg5
 push di                        ; push address of message 
 call printstr                  ; call the printstr subroutine
 mov ax, 0x4c00
 int 21h

draw:
 push bp
 mov bp,sp
 push dx
 push bx
 push ax
 push es
 push di
 push cx
 mov ax,0xB800
 mov es,ax
 mov di,[bp+4]			;x-axis
 mov bx,3

l1:
 mov cx,3
 mov ah,[bp+8]			
 rep stosw
 add di,154			;y-axis
 dec bx
 jne l1
 mov al,[bp+6]
 mov di,[bp+4]
 add di,162			;rectangle ke undar alphabets kahan place karne hae
 stosw
 pop cx
 pop di
 pop es
 pop ax
 pop bx
 pop dx
 pop bp
 ret 6

clrscr:
 push ax
 push es
 push di
 push cx
 mov ax, 0xb800
 mov es, ax			;Loading the video memory
 xor di,di
 mov ax,0x3320
 mov cx,2000
 cld
 rep stosw
 pop cx
 pop di
 pop es
 pop ax
 ret

up_date1:			;axis + random number a rahe
 push si
 mov ax,3998
 mov si,[c4]
 mov byte[colour2],0x10
 call updatechar
 mov [c4],si
 pop si
 ret

up_date2:
 push si
 mov bx,3998
 add bx,640
 add bx,320
 mov si,[c3]
 mov byte[colour1],0x40
 call updatechar 
 mov [c3],si
 pop si
 ret

up_date3:
 push si
 mov cx,3998
 add cx,640
 mov si,[c2]
 mov byte[colour3],0x50
 call updatechar
 mov [c2],si
 pop si
 ret

up_date4:
 push si
 mov dx,3998
 add dx,640
 add dx,640
 mov si,[c1]
 mov byte[colour4],0x60
 call updatechar
 mov [c1],si
 pop si
 ret

updatechar:			;numbers randomly generate ho rahe
 push dx
 push si
 pop dx
 add dl,2
 cmp dl,122
 jng fol
 mov dl,97

fol:
 push dx
 pop si
 pop dx
 ret

printnum: 
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx
 push dx 
 push di 
 mov di, 80 
 mov ax, [bp+8]
 mul di 
 mov di, ax 
 add di, [bp+6] 
 shl di, 1 
 add di, 8 
 mov ax, 0xb800 
 mov es, ax 
 mov ax, [bp+4]
 mov bx, 10 
 mov cx, 4 

nextdigit: 
 mov dx, 0 
 div bx 
 add dl, 0x30 
 cmp dl, 0x39 
 jbe bet 
 add dl, 7

bet: 
 mov dh, 0x31
 mov [es:di], dx 
 sub di, 2
 loop nextdigit 
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax 
 pop es 
 pop bp 
 ret 6

printstr: 
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push cx 
 push si 
 push di 
 push ds 
 mov ax, [bp+4] 
 push ax
 call strlen 
 cmp ax, 0 
 jz exit 
 mov cx, ax 
 mov ax, 0xb800 
 mov es, ax
 mov al, 80 
 mul byte [bp+8] 
 add ax, [bp+10]
 shl ax, 1 
 mov di,ax 
 mov si, [bp+4] 
 mov ah, [bp+6] 
 cld

nextchar: 
 lodsb
 stosw 
 loop nextchar 

exit:
 pop di 
 pop si 
 pop cx 
 pop ax 
 pop es 
 pop bp 
 ret 8

strlen:
 push bp 
 mov bp,sp 
 push es 
 push cx 
 push di 
 les di, [bp+4]  
 mov cx, 0xffff 
 xor al, al 
 repne scasb
 mov ax, 0xffff 
 sub ax, cx 
 dec ax 
 pop di 
 pop cx 
 pop es 
 pop bp 
 ret 4

kbisr:
 jmp isr

popballon1:
 add word[points],10
 mov byte[cs:colour4],0x33
 add word[totalballoons],1
 jmp terminateISR

popballon2:
 add word[points],10
 mov byte[cs:colour3],0x33 
 add word[totalballoons],1
 jmp terminateISR

popballon3:
 add word[points],10
 mov byte[cs:colour1],0x33
 add word[totalballoons],1
 jmp terminateISR

popballon4:
 add word[points],10
 mov byte[cs:colour2],0x33 
 add word[totalballoons],1
 jmp terminateISR

isr:
 push ax 
 push es 
 push bx
 push dx
 mov ax, 0xb800 
 mov es, ax
 in al, 0x60
 mov bx,-1

findKey:
 add bx,2
 cmp bx,53
 je terminateISR
 cmp al,[key+bx]
 jne findKey
 sub bx,1                         ;[key+bx] contain ascii of pressed button
 mov dl,[cs:c1]
 cmp dl,[cs:key+bx]
 je popballon1
 mov dl,[cs:c2]
 cmp dl,[cs:key+bx]
 je popballon2
 mov dl,[cs:c3]
 cmp dl,[cs:key+bx]
 je popballon3
 mov dl,[cs:c4]
 cmp dl,[cs:key+bx]
 je popballon4

terminateISR:
 pop dx
 pop bx
 pop es 
 pop ax 
 jmp far [cs:oldisr]

sleep:
 push cx
 mov cx, 0xFFFF
               
delay: 
 loop delay
 mov cx,0xFFFF
;l7:
 ;loop l7
 ;mov cx,0xFFFF

l8:
 loop l8
 pop cx
 ret

clock: 
 push ax 
 inc word [cs:tick]                       ; increment tick count 
 mov ax,[cs:tick]
 cmp ax,18
 jne prnt
 inc word [cs:seconds]
 cmp word[seconds],121
 jz end
 mov word[cs:tick],0

prnt:
 push word [cs:seconds] 
 call _printnum                            ; print tick count 
 mov al, 0x20 
 out 0x20, al                              ; end of interrupt 
 pop ax 
 iret 

_printnum: 
 push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 mov ax, 0xb800 
 mov es, ax 
 mov ax, [bp+4]
 mov bx, 10 
 mov cx, 0 

_nextdigit: 
 mov dx, 0
 div bx 
 add dl, 0x30 
 push dx
 inc cx 
 cmp ax, 0 
 jnz _nextdigit 
 mov di, 24

nextpos: 
 pop dx
 mov dh, 0x31
 mov [es:di], dx
 add di, 2
 loop nextpos
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax
 pop es 
 pop bp 
 ret 2 

seconds: dw 0
tick: dw 0 
oldisr: dd 0 
key: db 'l',0x26,'p',0x19,'r',0x13,'a',0x1E,'z',0x2C,
     db 'f',0x21,'i',0x17,'h',0x23,'q',0x10,'x',0x2D,
     db 'j',0x24,'b',0x30,'k',0x25,'w',0x11,'s',0x1F,
     db 'm',0x32,'g',0x22,'c',0x2E,'y',0x15,'t',0x14,
     db 'o',0x18,'e',0x12,'u',0x16,'d',0x20,'v',0x2F,'n',0x31
c1: db 'f'
c2: db 'j'
c3: db 'r'
c4: db 'z'
points: dw 0
msg1: db 'Time Left:',0
msg2: db 'Live Score:',0 
msg3: db 'Total Balloons Pop:',0
msg4: db 'Game Over!!!' ,0
msg5: db 'Balloon Popping Game' ,0
colour1: db 0x0
colour2: db 0x0
colour3: db 0x0
colour4: db 0x0
totalballoons: dw 0