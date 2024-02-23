[org 0x0100]
jmp start

    sto: dw 320


    new_mess: db 'N E W    G A M E'  	;size=16
    inst: db 'I N S T R U C T I O N'  	;size=21

    i1: db 'Press left key to move left ' ;27 
    i2: db 'Press right key to move right '  ;29
    i3: db 'Choose appropriate mode for gameplay' ;36
    i4: db 'Break a complete line to gain bonus of 10' ;41
    i5: db 'Game will end in 5 min' ;22


    exit_mess: db 'E X I T'				;size=7
    tetris_mess: db 'T E T R I S'		;size=11
    time_mess: db 'T I M E : '  	;size=10
    score_mess: db 'S C O R E : '	;size=12
    Level: db 'C H O O S E    L E V E L ';25
    Level1: db 'E A S Y'  ; 7
    Level2: db 'M E D I U M' ; 11
    Level3: db 'H A R D'; 7
    mode: db 0
    score: dw 0				;size=3
    over_mess: db 'G A M E    O V E R'	;size=18
    time_min: dw 0
    time: dw 0
    music_length dw 1000
    music_data incbin "dungeon.imf"
    music_length1: dw 4408
    music_data1 incbin "camein.imf"
    music_length2: dw 18644
    music_data2 incbin "getthem.imf"
    time_sec: dw 0
    time_sec2: dw 0
    mess: db ':'
    sample_time: db '00:35'				;size=5
    shape_mess: db 'Incoming Shape' ;size=14
    current_shape: dw 1
    oldkbisr1: dd 0
    oldkbisr2: dd 0
    rowcheck: dw 1
    max: dw 4000
    movdownbool: dw 0


clrscr1: 
    push es
    push ax
    push di
    push cx
    mov ax, 0xb800
    mov es, ax 							
    mov di, 0 	
    mov cx,2000
    mov ah,0x03
    mov al,'-'						
    next1:
    mov [es:di], ax		
    add di, 2 							
    sub cx,1 						
    jnz next1

    pop cx						
    pop di
    pop ax
    pop es
    ret

clrscr4: 
    push es
    push ax
    push di
    push cx
    mov ax, 0xb800
    mov es, ax 							
    mov di, 0 	
    mov cx,2000
    mov ah,0x47
    mov al,'-'						
    ne1:
    mov [es:di], ax		
    add di, 2 							
    sub cx,1 						
    jnz ne1

    pop cx						
    pop di
    pop ax
    pop es
    ret
sound3:
    push si
    push dx
    push ax
    push bx
    push di
    push cx

    mov si, 0
		
	next_note3:
		mov dx, 388h
		mov al, [si + music_data2 + 0]
		out dx, al
		mov dx, 389h
		mov al, [si + music_data2 + 1]
		out dx, al
		mov bx, [si + music_data2 + 2]
		add si, 4
	repeat_delay3:	
		mov cx, 1000 
	del3:
        mov ah, 1
		int 16h
		jnz .exit3
		loop del3
		
		dec bx
		jg repeat_delay3
		cmp si, [music_length2]
		jb next_note3
		
        .exit3:
        pop cx
        pop di
        pop bx
        pop ax
        pop dx
        pop si
		ret
clrscr3: 
    push es
    push ax
    push di
    push cx
    mov ax, 0xb800
    mov es, ax 							
    mov di, 0 	
    mov cx,2000
    mov ah,0x2F
    mov al,'-'						
    nt1:
    mov [es:di], ax		
    add di, 2 							
    sub cx,1 						
    jnz nt1

    pop cx						
    pop di
    pop ax
    pop es
    ret

skipku:
    pop ax
    jmp far [cs:oldkbisr2]

sound2:
    push si
    push dx
    push ax
    push bx
    push di
    push cx

    mov si, 0
		
	next_note1:
		mov dx, 388h
		mov al, [si + music_data1 + 0]
		out dx, al
		mov dx, 389h
		mov al, [si + music_data1 + 1]
		out dx, al
		mov bx, [si + music_data1 + 2]
		add si, 4
	repeat_delay1:	
		mov cx, 1000 
	del1:
        mov ah, 1
		int 16h
		jnz .exit
		loop del1
		
		dec bx
		jg repeat_delay1
		cmp si, [music_length1]
		jb next_note1
		
        .exit:
        pop cx
        pop di
        pop bx
        pop ax
        pop dx
        pop si
		ret

sound:
    push si
    push dx
    push ax
    push bx
    push di
    push cx

    mov si, 0
		
	next_note:
		mov dx, 388h
		mov al, [si + music_data + 0]
		out dx, al
		mov dx, 389h
		mov al, [si + music_data + 1]
		out dx, al
		mov bx, [si + music_data + 2]
		add si, 4
	repeat_delay:	
		mov cx, 1000 
		
        push cx
        mov cx,20
        l1:
        sub cx,1
        jnz l1
		dec bx
        pop cx
		jg repeat_delay
		cmp si, [music_length]
		jb next_note
		
        pop cx
        pop di
        pop bx
        pop ax
        pop dx
        pop si
		ret

scrolldown: 
    push bp 
    mov bp,sp 
    push ax 
    push cx 
    push si 
    push di 
    push es 
    push ds 

    mov di,3800
    mov si,3480

    mov ax,0xb800
    mov es,ax

    mov bx,17
    lp1: 
    mov cx,61
    lp2:
    mov ax, [es:si]
    mov [es:di],ax
    sub di,2
    sub si,2
    sub cx,1
    jnz lp2
    sub di,38
    sub si,38
    sub bx,1
    jnz lp1
    


    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop ax 
    pop bp 
    ret 
timer:
    push ax
    cmp word [cs:time_min],5
    je skipku

    cmp byte [cs:mode],1
    jne m2
    mov cx,10
    jmp main
    m2:
    cmp byte[cs:mode],2
    jne m3
    mov cx,8
    jmp main
    m3:
    cmp byte [cs:mode],3
    mov cx,5
    main:
    inc word [cs:time_sec2]		
    cmp word [cs:time_sec2],cx
    je donothing
    jmp skip3

    donothing:
    mov word [cs:time_sec2],0
    inc word [cs:time_sec]
    call sound

    cmp di,3680
    jg skip4
    
    mov ax,[current_shape]
    push ax
    call movdown
    mov bx,[current_shape]
    inc bx
    cmp bx,5
    jne sl
    mov bx,1
    sl:
    push bx
    call drawincomingshape
    jmp skip5
    
    skip4:
    mov di,80
    add word [score],5
    inc word [current_shape]
    cmp word [current_shape],5
    jl skip5

    mov word [current_shape],1

    skip5:
    cmp word [cs:time_sec],60
    jne skip3


    mov word [cs:time_sec],0
    inc word [cs:time_min]

    


    skip3:
    cmp word [cs:time_sec],9
    push 774
    push word [cs:time_min]
    call printnum	
    mov ax,mess
    push ax
    push 1
    push 778
    call printscreen
    cmp word [cs:time_sec],9
    ja sk
    push 782
    push word [cs:time]
    call printnum
    push 784 
    push word [cs:time_sec]
    call printnum
    jmp d
    sk:
    push 782 
    push word [cs:time_sec]
    call printnum
    d:
    push di
    mov di,3498
    push word [score]
    call printnbr
    pop di

    
    mov al, 0x20
    out 0x20, al						; end of interrupt
    pop ax
    iret

drawincomingshape:
    push bp
    mov bp,sp
    push di 
    mov di,2056
    cmp word[bp+4],1
    jne s1
    push di
    call draw_TBackground
    pop di
    push 0x2A00
    call draw_sq
    jmp e
    s1:
    cmp word[bp+4],2
    jne s2
    push di
    call draw_sqBackground
    pop di
    push 0x2A00
    call draw_rect
    jmp e
    s2:
    cmp word[bp+4],3
    jne s3
    push di
    call draw_rectBackground
    pop di
    push 0x2A00
    call draw_L
    jmp e
    s3:
    cmp word[bp+4],4
    jne e
    push di
    call draw_LBackground
    pop di
    push 0x2A00
    call draw_T
    e:
    pop di
    pop bp
    ret 2

printnum:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    mov ax, 0xb800
    mov es, ax						; point es to video base
    mov ax, [bp+4]					; load number in ax
    mov bx, 10						; use base 10 for division
    mov cx, 0						; initialize count of digits
    nextdigit: mov dx, 0			; zero upper half of dividend
    div bx							; divide by 10
    add dl, 0x30					 ; convert digit into ascii value
    push dx							; save ascii value on stack
    inc cx							; increment count of values
    cmp ax, 0						; is the quotient zero
    jnz nextdigit					; if no divide it again
    mov di, [bp+6]					; point di to 70th column
    nextpos: pop dx					; remove a digit from the stack
    mov dh,0x0E					; use normal attribute
    mov [es:di], dx					; print char on screen
    add di, 2						; move to next screen location
    loop nextpos					; repeat for all digits on stack
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 4

delay:
    push cx
    push bx
    push si
    push dx
    mov si,0
    mov dx,7
    mov cx,0xffff
    mov bx,0

    ;loop47:
    ;mov bx,0
    loop15:
    add bx,1
    cmp bx,cx
    jne loop15
    ;sub dx,1
    ;jnz loop47

    pop dx
    pop si
    pop bx
    pop cx
    ret

clrscr: 
    push es
    push ax
    push di
    push cx
    mov ax, 0xb800
    mov es, ax 							
    mov di, 0 	
    mov cx,2000
    mov ah,0x19
    mov al,'.'						
    next:
    mov [es:di], ax		
    add di, 2 							
    sub cx,1 						
    jnz next 
    pop cx						
    pop di
    pop ax
    pop es
    ret

partition:
    push es
    ;push di
    push ax
    push cx
    push si
    push bx

    mov ax,0xb800
    mov es,ax
    mov di,122
    mov ax,0x1F7C
    mov cx,25

    loop1:
    mov [es:di],ax
    add di,160
    sub cx,1
    jnz loop1

    mov di,454
    mov cx,7
    mov si,time_mess
    mov ah,0x0E
    loop2:
    lodsb 
    stosw
    sub cx,1
    jnz loop2


    mov di,3172
    mov si,score_mess
    mov cx,9
    loop4:
    lodsb
    stosw
    sub cx,1
    jnz loop4


    mov di,1566
    mov cx,14
    mov si,shape_mess
    loop6:
    lodsb
    stosw
    sub cx,1
    jnz loop6


    mov di,0
    mov ax,0x1F7C
    mov cx,25
    loop36:
    mov [es:di],ax
    add di,160
    loop loop36
    mov di,3840
    mov cx,80
    mov ah,0x47
    mov al,'/'
    rep stosw
    mov di,540
    pop bx
    pop si
    pop cx
    pop ax
    ;pop di
    pop es
    ret

printscreen: 

    push bp
    mov bp,sp
    push es
    push ax
    push si
    push cx
    push di
    mov ax, 0Xb800
    mov es, ax
    mov si,[bp+8]
    mov cx,[bp+6]

    mov ah,0x0E
    mov di,[bp+4]
    nextchar:
    mov al ,[si]
    mov [es: di],ax
    add di,2
    add si,1
    loop nextchar
    pop di 
    pop cx
    pop si
    pop ax
    pop es
    pop bp
    ret 6

printnbr:
    push bp 
    mov bp, sp 
    push es 
    push ax 
    push bx 
    push cx 
    push dx 
    mov ax, 0xb800 
    mov es, ax ; point es to video base 
    mov ax, [bp+4] ; load number in ax 
    mov bx, 10 ; use base 10 for division 
    mov cx, 0 ; initialize count of digits 
    nextd: mov dx, 0 ; zero upper half of dividend 
    div bx ; divide by 10 
    add dl, 0x30 ; convert digit into ascii value 
    push dx ; save ascii value on stack 
    inc cx ; increment count of values 
    cmp ax, 0 ; is the quotient zero 
    jnz nextd ; if no divide it again 
    nextp: pop dx ; remove a digit from the stack 
    mov dh, 0x0E ; use normal attribute 
    mov [es:di], dx ; print char on screen 
    add di, 2 ; move to next screen location 
    loop nextp ; repeat for all digits on stack

    pop dx 
    pop cx 
    pop bx 
    pop ax 
    pop es 
    pop bp 
    ret 2 
printstr: 

    push bp
    mov bp,sp
    push es
    push ax
    push si
    push cx

    mov ax, 0Xb800
    mov es, ax
    mov si,[bp+6]
    mov cx,[bp+4]

    mov ah,0x0E

    n2:
    mov al ,[si]
    mov [es: di],ax
    add di,2
    add si,1
    loop n2

    pop cx
    pop si
    pop ax
    pop es
    pop bp
    ret 4

draw_L:

    push bp
    mov bp,sp
    push ax

    mov ax,[bp+4]
    push ax
    call draw_sq
    add di,320
    sub di,10
    push ax
    call draw_rect

    pop ax
    mov sp,bp
    pop bp
    ret 2
draw_LBackground:

    push bp
    mov bp,sp
    push ax
    mov ah,0x19
    mov al,'.'
    push ax
    call draw_sqBackground
    add di,320
    sub di,10
    call draw_rectBackground

    pop ax
    mov sp,bp
    pop bp
    ret 
draw_T:
    push bp
    mov bp,sp
    push ax

    mov ax,[bp+4]
    push ax
    call draw_L

    sub di,30
    push word [bp+4]
    call draw_sq

    pop ax
    mov sp,bp
    pop bp
    ret 2
draw_TBackground:
    push bp
    mov bp,sp
    push ax
    mov ah,0x19
    mov al,'.'
    push ax
    call draw_LBackground

    sub di,30
    push ax
    call draw_sqBackground

    pop ax
    mov sp,bp
    pop bp
    ret
draw_rect:
    push bp
    mov bp,sp
    push cx
    push si
    push ax
    push bx

    mov ax,[bp+4]
    push ax
    call draw_sq
    push ax
    call draw_sq

    pop bx
    pop ax
    pop si
    pop cx
    mov sp,bp
    pop bp
    ret 2
draw_rectBackground:
    push bp
    mov bp,sp
    push cx
    push si
    push ax
    push bx
    mov ah,0x19
    mov al,'.'
    push ax
    call draw_sqBackground
    push ax
    call draw_sqBackground

    pop bx
    pop ax
    pop si
    pop cx
    mov sp,bp
    pop bp
    ret
draw_sq:
    push bp
    mov bp,sp
    push cx
    push si
    push ax
    push bx

    mov ax,0xb800
    mov es,ax

    mov ax,[bp+4]
    mov al,0x20
    mov si,2
    mov bx,0
    mov cx,5

    loop13:
    mov [es:di],ax
    add di,2
    loop loop13

    add di,160
    sub di,10
    mov cx,5

    mov al,'_'
    loop14:
    mov [es:di],ax
    add di,2
    loop loop14

    mov al,'|'
    sub di,2
    mov [es:di],ax

    sub di,160
    mov [es:di],ax

    sub di,10
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    add di,12
    sub di,160

    pop bx
    pop ax
    pop si
    pop cx
    mov sp,bp
    pop bp
    ret 2
draw_sqBackground:
    push bp
    mov bp,sp
    push cx
    push si
    push ax
    push bx

    mov ax,0xb800
    mov es,ax
    mov ah,0x19
    mov al,'.'
    mov si,2
    mov bx,0
    mov cx,5

    loopl88:
    mov [es:di],ax
    add di,2
    loop loopl88

    add di,160
    sub di,10
    mov cx,5

    loop166:
    mov [es:di],ax
    add di,2
    loop loop166
    sub di,2
    mov [es:di],ax

    sub di,160
    mov [es:di],ax

    sub di,10
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    add di,12
    sub di,160

    pop bx
    pop ax
    pop si
    pop cx
    mov sp,bp
    pop bp
    ret 
movdown:
    push bp
    mov bp,sp
    push ax
    push cx

    mov ax,0xb800
    mov es,ax

    cmp word [max],640
    jg donothing1
    call exit3

    donothing1
    cmp word [bp+4],1		;square
    jne nextch1
    jmp comp_sq

    outofsq:
    add word [score],5
    sub di,10
    mov ax,0x4720
    push ax
    call draw_sq
    cmp word [max],di
    jl donothing2
    mov word [max],di
    donothing2:
    mov di,540
    inc word [current_shape]
    cmp word [current_shape],5
    jne nothing
    mov word [current_shape],1
    nothing:
    jmp skip2

    comp_sq:
    mov si,di
    add si,320
    sub si,2
    mov cx,6
    loop37:
    mov ax,[es:si]
    cmp ah,0x47
    je outofsq
    sub si,2
    loop loop37


    sub di,10
    add di,160
    mov ax,0x5720
    push ax
    call draw_sq
    sub di,162
    mov ah,0x19
    mov al,'.'
    mov cx,6
    loop30:
    mov [es:di],ax
    sub di,2
    loop loop30
    add di,14
    add di,160
    jmp skip2

    nextch1: cmp word [bp+4], 2			;rectangle
    je comp_rect
    jmp nextch2

    outofrect:
    add word [score],5
    sub di,20
    mov ax,0x4720
    push ax
    call draw_rect
    add word [max],1
    mov di,540
    inc word [current_shape]
    cmp word [current_shape],5
    jne nothing2
    mov word [current_shape],1
    nothing2:
    jmp skip2


    comp_rect:
    mov si,di
    add si,320
    sub si,2
    mov cx,11
    loop38:
    mov ax,[es:si]
    cmp ah,0x47
    je outofrect
    sub si,2
    loop loop38

    sub di,20
    add di,160
    mov ax,0x5720
    push ax
    call draw_rect
    sub di,160
    mov ah,0x19
    mov cx,11
    sub di,2
    mov ah,0x19
    mov al,'.'
    loop29:
    mov [es:di],ax
    sub di,2
    loop loop29
    add di,24
    add di,160
    jmp skip2

    nextch2: cmp word [bp+4],3		;L
    je comp_L
    jmp nextch3

    outofL:
    add word [score],5
    sub di,20
    sub di,320
    mov ax,0x4720
    push ax
    call draw_L
    add word [max],2
    mov di,540
    inc word [current_shape]
    cmp word [current_shape],5
    jne nothing3
    mov word [current_shape],1
    nothing3:
    jmp skip2

    comp_L:
    mov si,di
    add si,320
    sub si,2
    mov cx,11
    loop39:
    mov ax,[es:si]
    cmp ah,0x47
    je outofL
    sub si,2
    loop loop39


    sub di,20
    sub di,160
    mov ax,0x5720
    push ax
    call draw_L
    sub di,162
    mov cx,5
    mov ah,0x19
    mov al,'.'
    loop31:
    mov [es:di],ax
    sub di,2
    loop loop31
    sub di,320
    mov cx,6
    loop32:
    mov [es:di],ax
    sub di,2
    loop loop32
    add di,480
    add di,24
    jmp skip2

    nextch3: cmp word [bp+4],4		;T
    ;jne skip2
    jmp comp_T

    outofT:
    add word [score],5
    sub di,320
    mov ax,0x4720
    push ax
    call draw_T
    add word [max],2
    mov di,540
    inc word [current_shape]
    cmp word [current_shape],5
    jne nothing4
    mov word [current_shape],1
    nothing4:
    jmp skip2

    comp_T:
    mov si,di
    add si,320
    add si,20
    sub si,2
    mov cx,16
    loop40:
    mov ax,[es:si]
    cmp ah,0x47
    je outofT
    sub si,2
    loop loop40


    sub di,160
    mov ax,0x5720
    push ax
    call draw_T

    mov ah,0x19
    mov al,'.'
    sub di,164
    mov cx,5
    loop33:
    mov [es:di],ax
    sub di,2
    loop loop33

    add di,24
    mov cx,5
    loop34:
    mov [es:di],ax
    add di,2
    loop loop34

    sub di,22
    sub di,320
    mov cx,6
    loop35:
    mov [es:di],ax
    add di,2
    loop loop35
    sub di,10
    add di,480

    skip2:
    mov si,3680
    mov cx,57
    loop45:
    sub cx,1
    jz comp
    add si,2
    mov ax,[es:si]
    cmp ah,0x47
    je loop45
    mov word [rowcheck],0

    comp:
    cmp word [rowcheck],1
    je scroll
    jmp skip6
    
    scroll:
    add word [cs:score],10
    mov cx,12
    push di
    mov di,3522
    loop46:
    mov ax,0xCE20
    push ax
    call draw_sq
    sub cx,1
    jnz loop46
    pop di
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call scrolldown


    skip6:
    mov word [rowcheck],1
    pop cx
    pop ax
    mov sp,bp
    pop bp
    ret 2







movleft:
    push bp
    mov bp,sp
    push ax
    push cx
    push dx

    cmp word [movdownbool],0
    je donothing3
    jmp skip

    donothing3:
    mov dx,0xb800
    mov es,dx


    cmp word [bp+4],1		;square
    jne nextchar1
    mov si,di
    sub si,14
    mov ax,[es:si]
    cmp al,0x7C
    jne skip_draw_left_sq
    jmp skip

    skip_draw_left_sq:
    sub di,12
    mov ax,0x5720
    push ax
    call draw_sq
    mov ah,0x19
    mov al,'.'
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    sub di,160
    jmp skip

    nextchar1:
    cmp word [bp+4],2		;rectangle
    jne nextchar2
    mov si,di
    sub si,24
    mov ax,[es:si]
    cmp al,0x7C
    jne skip_draw_left_rect
    jmp skip

    skip_draw_left_rect:
    sub di,22
    mov ax,0x5720
    push ax
    call draw_rect
    mov ah,0x19
    mov al,'.'
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    sub di,160

    jmp skip


    nextchar2:
    cmp word [bp+4],3		;L
    jne nextchar3

    mov si,di
    sub si,24
    mov ax,[es:si]
    cmp al,0x7C
    jne skip_draw_left_L
    jmp skip

    skip_draw_left_L:
    sub di,170
    sub di,12
    sub di,160
    mov ax,0x5720
    push ax
    call draw_L
    mov ah,0x19
    mov al,'.'
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    sub di,480
    sub di,10
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    add di,170

    jmp skip

    nextchar3
    cmp word [bp+4],4		;T
    jne skip

    mov si,di
    sub si,14
    mov ax,[es:si]
    cmp al,0x7C
    jne skip_draw_left_T
    jmp skip

    skip_draw_left_T:
    sub di,322
    mov ax,0x5720
    push ax
    call draw_T

    add di,10
    sub di,160
    mov ah,0x19
    mov al,'.'
    mov [es:di],ax
    sub di,160
    mov [es:di],ax
    add di,330
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    sub di,180


    skip:
    pop dx
    pop cx
    pop ax
    mov sp,bp
    pop bp
    ret 2

movright:
    push bp
    mov bp,sp
    push ax
    push cx
    push dx

    cmp word [movdownbool],0
    je donothing4
    jmp skip1

    donothing4:
    mov dx,0xb800
    mov es,dx


    cmp word [bp+4],1		;square
    jne nchar1
    mov ax,[es:di]
    cmp al,0x7C
    jne skip_draw_right_sq
    jmp skip1
    skip_draw_right_sq:
    sub di,8
    mov ax,0x5720
    push ax
    call draw_sq
    sub di,14
    mov ah,0x19
    mov al,'.'
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    sub di,160
    add di,14
    jmp skip1


    nchar1:
    cmp word [bp+4],2		;rectangle
    jne nchar2
    mov ax,[es:di]
    cmp al,0x7C
    jne skip_draw_right_rect
    jmp skip1
    skip_draw_right_rect:
    sub di,18
    mov ax,0x5720
    push ax
    call draw_rect
    sub di,24
    mov ah,0x19
    mov al,'.'
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    sub di,160
    add di,24
    jmp skip1


    nchar2:
    cmp word [bp+4],3		;L
    jne nchar3
    mov ax,[es:di]
    cmp al,0x7C
    jne skip_draw_right_L
    jmp skip1
    skip_draw_right_L:
    sub di,18
    sub di,320
    mov ax,0x5720
    push ax
    call draw_L
    sub di,24
    sub di,320
    mov ah,0x19
    mov al,'.'
    mov cx,4
    loop26:
    mov [es:di],ax
    add di,160
    loop loop26
    sub di,320
    add di,24
    jmp skip1

    nchar3
    cmp word [bp+4],4		;T
    jne skip1
    mov si,di
    add si,20
    mov ax,[es:si]
    cmp al,0x7C
    jne skip_draw_right_T
    jmp skip1
    
    skip_draw_right_T:
    sub di,318
    mov ax,0x5720
    push ax
    call draw_T
    sub di,164
    mov ah,0x19
    mov al,'.'
    mov [es:di],ax
    sub di,160
    mov [es:di],ax
    sub di,10
    add di,320
    mov [es:di],ax
    add di,160
    mov [es:di],ax
    add di,14
    sub di,160


    skip1:
    pop dx
    pop cx
    pop ax
    mov sp,bp
    pop bp
    ret 2

kbisr:
    push ax
    push es
    mov ax, 0xb800
    mov es, ax	 					   	; point es to video memory
    in al, 0x60							 ; read a char from keyboard port
    cmp al, 0x4b						; is the key left shift
    jne nextcmp1						; no, try next comparison
    mov ax,[current_shape]
    push ax
    call movleft
    jmp nomatch							 ; leave interrupt routine
    nextcmp1: cmp al, 0x4d				; is the key right shift
    jne nomatch							; no, leave interrupt routine
    mov ax,[current_shape]
    push ax
    call movright

    nomatch:						
    pop es
    pop ax
    jmp far [cs:oldkbisr1] ; call the original ISR

startscreen:
    push ax
    push es
    mov ax,0xb800
    mov es,ax

    mov ah,0x0E
    mov di,870
    mov cx,11
    mov si,tetris_mess
    loop11:
    lodsb
    stosw
    call delay
    loop loop11

    sub di,36
    add di,648
    mov si,new_mess
    mov cx,16
    loop22:
    lodsb
    stosw
    call delay
    loop loop22


    sub di,30
    add di,646
    mov si,exit_mess
    mov cx,7
    loop44:
    lodsb
    stosw
    call delay
    loop loop44
    pop es
    pop ax
    ret 

instructionscreen:
    push ax
    push es
    mov ax,0xb800
    mov es,ax

    mov ah,0x0E
    mov di,860
    mov cx,21
    mov si,inst
    loopn1:
    lodsb
    stosw
    call delay
    loop loopn1
    

    mov ah,0x0E
    mov di,1280
    mov cx,27
    mov si,i1
    loopn2:
    lodsb
    stosw
    call delay
    loop loopn2

    mov ah,0x0E
    mov di,1600
    mov cx,29
    mov si,i2
    loopn3:
    lodsb
    stosw
    call delay
    loop loopn3


    mov ah,0x0E
    mov di,1920
    mov cx,36
    mov si,i3
    loopn4:
    lodsb
    stosw
    call delay
    loop loopn4

    mov ah,0x0E
    mov di,2240
    mov cx,41
    mov si,i4
    loopn5:
    lodsb
    stosw
    call delay
    loop loopn5


    mov ah,0x0E
    mov di,2560
    mov cx,22
    mov si,i5
    loopn6:
    lodsb
    stosw
    call delay
    loop loopn6

    pop es
    pop ax
    ret 

Levelscreen:
    push ax
    push es
    mov ax,0xb800
    mov es,ax

    mov ah,0x0E

    mov di,700
    mov cx,24
    mov si,Level
    lo1:
    lodsb
    stosw
    call delay
    loop lo1

    mov di,1356
    mov cx,7
    mov si,Level1
    lo11:
    lodsb
    stosw
    call delay
    loop lo11

    mov di,1832
    mov si,Level2
    mov cx,11
    lo22:
    lodsb
    stosw
    call delay
    loop lo22


    mov di,2316
    mov si,Level3
    mov cx,7
    lo44:
    lodsb
    stosw
    call delay
    loop lo44
    pop es
    pop ax
    ret 

endscreen:
    push ax
    push es
    mov ax,0xb800
    mov es,ax

    mov ah,0x0E
    mov di,860
    mov cx,18
    mov si,over_mess
    loop21:
    lodsb
    stosw
    call delay
    loop loop21

    sub di,36
    add di,644
    mov si,time_mess
    mov cx,10
    loop222:
    lodsb
    stosw
    call delay
    loop loop222
    

    push di
    push word [cs:time_min]
    call printnum	
    mov ax,mess
    push ax
    push 1
    add di,2
    push di
    call printscreen
    cmp word [cs:time_sec],9
    ja sm
    add di,2
    push di
    push word [cs:time]
    call printnum
    add di,2
    push di
    push word [cs:time_sec]
    call printnum
    jmp d1
    sm:
    add di,2
    push di
    push word [cs:time_sec]
    call printnum
    d1:
    mov ah,0x0E
    sub di,30
    add di,640
    mov si,score_mess

    mov cx,12
    loop444:
    lodsb
    stosw
    call delay
    loop loop444

    mov ah,0x0E
    push word [score]
    call printnbr
    pop es
    pop ax
    ret

clrscr2: 
    push es
    push ax
    push di
    push cx
    mov ax, 0xb800
    mov es, ax 							
    mov di, 0 	
    mov cx,2000
    mov ah,0x72
    mov al,':'
    next2:
    mov [es:di], ax		
    add di, 2 							
    sub cx,1 						
    jnz next2

    pop cx						
    pop di
    pop ax
    pop es
    ret



exit3:

    call clrscr2
    call endscreen
    call sound2
    xor ax,ax
    mov es,ax
    mov ax,[oldkbisr1]
    cli
    mov word [es:9*4],ax
    mov ax,[oldkbisr1+2]
    mov word [es:9*4+2],ax
    sti
    xor ax,ax
    mov es,ax
    mov ax,[oldkbisr2]
    cli
    mov word [es:8*4],ax
    mov ax,[oldkbisr2+2]
    mov word [es:9*4+2],ax
    sti
    mov ax,0x4c00
    int 21h
start:
    call clrscr1
    call startscreen
    call sound2
    xor ax,ax
    mov ah,0
    int 16h
    cmp al,27
    je exit3
    call clrscr4
    call instructionscreen
    call sound3
    xor ax,ax
    mov ah,0
    int 16h
    call clrscr3
    call Levelscreen
    lm:
    xor ax,ax
    mov ah,0
    int 16h
    cmp al,0x31
    jb lm
    cmp al,0x33
    ja lm

    sub al,0x30
    mov [cs:mode],al
    call clrscr
    call partition

    xor ax,ax
    mov es,ax
    mov ax,[es:9*4]
    mov word [oldkbisr1],ax
    mov ax,[es:9*4+2]
    mov word [oldkbisr1+2],ax
    xor ax,ax
    mov es,ax
    mov ax,[es:8*4]
    mov word [oldkbisr2],ax
    mov ax,[es:8*4+2]
    mov word [oldkbisr2+2],ax


    cli
    mov word [es:9*4],kbisr
    mov word [es:9*4+2],cs
    sti

    xor ax, ax
    mov es, ax							; point es to IVT base
    cli									; disable interrupts
    mov word [es:8*4], timer			; store offset at n*4
    mov [es:8*4+2], cs					; store segment at n*4+2
    sti

    loopm:

    cmp word [time_min],5
    je end
    jmp loopm
    end:
    mov word [movdownbool],1
    call exit3
