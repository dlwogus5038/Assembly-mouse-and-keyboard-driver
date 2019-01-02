data segment
	mouse_x dw 0
	mouse_y dw 0
	mouse_c dw 0
	status dw 0
	str_x db 'x: ', '$'
	str_y db 'y: ', '$'
	str_n db 13, 10, '$'
	str_input db 'INPUT:', '$'
	count dw 0

data ends

code segment
assume cs: code ,ds: data
start:
	mov ax, data
	mov ds, ax
	mov ah, 01h
	mov cx, 2607h
	int 10h
	mov  ax,0013h
	int  10h

	call RESET_M
	call CLEAR
	call CURSOR_ZERO
	call SHOW
	
	call UPDATE

RESET_M PROC
	mov ax, 00h
	int 33h
	ret
RESET_M ENDP

CLEAR PROC ;Clear
	mov ax, 0600h
	mov bh, 07h
	mov cx, 0000h
	mov dx, 184fh
	int 10h
	ret
CLEAR ENDP

CLEAR_RED PROC ;Clear
	mov ax, 0600h
	mov bh, 04h
	mov cx, 0000h
	mov dx, 184fh
	int 10h
	ret
CLEAR_RED ENDP

CLEAR_BLUE PROC ;Clear
	mov ax, 0600h
	mov bh, 01h
	mov cx, 0000h
	mov dx, 184fh
	int 10h
	ret
CLEAR_BLUE ENDP

CLEAR_GREEN PROC ;Clear
	mov ax, 0600h
	mov bh, 02h
	mov cx, 0000h
	mov dx, 184fh
	int 10h
	ret
CLEAR_GREEN ENDP

CURSOR_ZERO PROC ;Setting Cursor to zero
	mov ah, 02h
	mov bh, 00h
	mov dl, 00h
	mov dh, 00h
	int 10h
	ret
CURSOR_ZERO ENDP

CURSOR_INPUT PROC ;Setting Cursor to Input Positon
	mov ah, 02h
	mov bh, 00h
	mov dl, 00h
	mov dh, 18h
	int 10h
	ret
CURSOR_INPUT ENDP

SHOW PROC ;Show Mouse Cursor
	mov ax, 01h
	int 33h
	ret
SHOW ENDP

HIDE PROC ;Hide Mouse Cursor
	mov ax, 02h
	int 33h
	ret
HIDE ENDP

PRINT_COOR PROC; print coordinate
	call CURSOR_ZERO
	mov ah, 09h
	mov dx, OFFSET str_x
	int 21h
	mov ax, mouse_x
	call DISP_AX
	mov ah, 09h
	mov dx, OFFSET str_n
	int 21h
	mov dx, OFFSET str_y
	int 21h
	mov ax, mouse_y
	call DISP_AX
	ret
PRINT_COOR ENDP

UPDATE PROC
	lp:
		mov ax, 03h
		int 33h
		mov mouse_c,bx
		mov mouse_x,cx
		mov mouse_y,dx	

		call PRINT_COOR

		cmp mouse_c, 0h
		jnz CLICKED
		cmp status, 0
		jz CLICKED
		mov status, 0
		call HIDE
		call CLEAR
		call SHOW
		jmp lp

		CLICKED:
		cmp mouse_c, 1h ;LEFT CLICKED
		jnz NL
		cmp status, 1
		jz NL
		mov status, 1
		call HIDE
		call CLEAR_GREEN
		call SHOW
		jmp lp

		NL:
		cmp mouse_c, 2h ;RIGHT CLICKED
		jnz NR
		cmp status, 2
		jz NR
		mov status, 2
		call HIDE
		call CLEAR_BLUE
		call SHOW
		jmp lp

		NR:
		cmp mouse_c, 3h
		jnz NB
		cmp status, 3
		jz NB
		mov status, 3
		call HIDE
		call CLEAR_RED
		call SHOW
		jmp lp

		NB:
		test mouse_c, 4h ;CENTER CLICKED
		jne stop

		jmp lp
	ret
UPDATE ENDP

DISP_AX PROC ;Integer to String
    mov  bx, 16
    mov  cx, 4
ABC:
    cwd
    div  bx
    push dx
    loop ABC
    mov  cx, 4
ASD:
    pop  dx
    cmp  dl, 10
    jb   A48
    add  dl, 7
A48:
    add  dl, 48
    mov  ah, 2
    int  21h         
    loop ASD
    ret
DISP_AX ENDP

stop:
	mov  ax,0003h
	int  10h
	call CLEAR
	call HIDE
	call CURSOR_ZERO
	mov ah, 4ch
	int 21h
	

code ends
end start