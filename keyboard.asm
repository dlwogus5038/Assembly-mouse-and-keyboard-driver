;================================以下为程序代码
assume cs:code
code segment
 in al,60H
 mov cs:switch,al
 ;-------将键盘控制器发送的扫描码保存到switch变量里
 mov al, 20H
 out 20H, al
 ;-------以上两条令中断控制器可以再次相应中断
 iret
qzScan			db 0,020H,01EH,030H,02EH,012H,021H,022H,023H,017H,024H,025H,026H,032H,031H,018H,019H,010H,013H,01FH,014H,016H,02FH,011H,02DH,015H,02CH,029H,002H,003H,004H,005H,006H,007H,008H,009H,00AH,00BH,00CH,00DH
				db 039H,01AH,01BH,027H,028H,02BH,033H,034H,04AH,037H,035H,047H,048H,049H,04BH,04CH,04DH,04FH,050H,051H,052H,053H,04EH
qzSmallAscii	db 0,064H,061H,062H,063H,065H,066H,067H,068H,069H,06AH,06BH,06CH,06DH,06EH,06FH,070H,071H,072H,073H,074H,075H,076H,077H,078H,079H,07AH,060H,031H,032H,033H,034H,035H,036H,037H,038H,039H,030H,02DH,03DH
				db 020H,05BH,05DH,03BH,027H,05CH,02CH,02EH,02DH,02AH,02FH,037H,038H,039H,034H,035H,036H,031H,032H,033H,030H,02EH,02BH
qzBigAscii		db 0,044H,041H,042H,043H,045H,046H,047H,048H,049H,04AH,04BH,04CH,04DH,04EH,04FH,050H,051H,052H,053H,054H,055H,056H,057H,058H,059H,05AH,07EH,021H,040H,023H,024H,025H,05EH,026H,02AH,028H,029H,05FH,02BH
				db 020H,07BH,07DH,03AH,022H,07CH,03CH,03EH,02DH,02AH,03FH,037H,038H,039H,034H,035H,036H,031H,032H,033H,030H,02EH,02BH
scan_num dw 63
F112Scan db 0,03BH,03CH,03DH,03EH,03FH,040H,041H,042H,043H,044H,057H,058H
ctrlOut db 0,'(','C','t','r','l',')'
ctrlSi dw 7
altOut db 0,'(','A','l','t',')'
altSi dw 6
tabOut db 0,'(','T','a','b',')'
tabSi dw 6
homeOut db 0,'(','H','o','m','e',')'
homeSi dw 7
pgupOut db 0,'(','P','g','u','p',')'
pgupSi dw 7
pgdnOut db 0,'(','P','g','d','n',')'
pgdnSi dw 7
endOut db 0,'(','E','n','d',')'
endSi dw 6
pauseOut db 0,'(','P','a','u','s','e','/','B','r','e','a','k',')'
pauseSi dw 14
scrlkOut db 0,'(','S','c','r','l','k',')'
scrlkSi dw 8
enterOut db 0,'(','E','n','t','e','r',')'
enterSi dw 8
insertOut db 0,'(','I','n','s','e','r','t',')'
insertSi dw 9
deleteOut db 0,'(','D','e','l','e','t','e',')'
deleteSi dw 9
dnArrowOut db 0,'(','D','n','A','r','r','o','w',')'
dnArrowSi dw 10
upArrowOut db 0,'(','U','p','A','r','r','o','w',')'
upArrowSi dw 10
leftArrowOut db 0,'(','L','e','f','t','A','r','r','o','w',')'
leftArrowSi dw 12
rightArrowOut db 0,'(','R','i','g','h','t','A','r','r','o','w',')'
rightArrowSi dw 13
spacialSi dw 0
oldInt9_1 dw ?
oldInt9_2 dw ?
switch db ?
capsLockCheck db 0
shiftCheck db 0
isBig dw 0
temp_input db 0
capsLockNum dw 0
start:
	mov ax,0600h   
	mov bh,0ah     
	mov cx,0000h   
	mov dx,184fh    
	int 10h  
	mov ax,0
	mov ds,ax
	mov bx,9*4+2
	mov ax,[bx]
	mov cs:oldInt9_1,ax
	mov ax,code
	mov [bx],ax
	mov bx,9*4
	mov ax,[bx]
	mov cs:oldInt9_2,ax
	mov word ptr [bx],0
 ;-------保存并设置新的 INT 9 中断入口
	mov ax,0B800H
	mov ds,ax
 ;-------显存段地址
	mov bx,0
	jmp compare
 ;-------写现存时的偏移地址

 FKey1:
 inc si
 cmp si,13
 jz afterFKey
 cmp ah,F112Scan[si]
 jz FKeyCheck
 jmp FKey1

FKeyCheck:
 cmp si,10
 jl FKey2
 mov di,si
 sub di,10
 add di,48
 jmp FKey3

FKey2:
 mov byte ptr [bx],'('
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 mov byte ptr [bx],'F'
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 mov di,si
 add di,48
 mov byte ptr [bx],di
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 mov byte ptr [bx],')'
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 jmp toCompare3

FKey3:
 mov byte ptr [bx],'('
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 mov byte ptr [bx],'F'
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 mov byte ptr [bx],'1'
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 mov byte ptr [bx],di
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 mov byte ptr [bx],')'
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 jmp toCompare3

toCompare3:
 jmp toCompare2

spacialKey:
 mov si,0
 jmp FKey1

afterFKey:
 mov si,0
 mov di,ctrlSi	;ctrl
 mov spacialSi,di
 mov bp,offset ctrlOut
 cmp ah,01DH
 jz spacialKeyOut
 mov di,altSi	;alt
 mov spacialSi,di
 mov bp,offset altOut
 cmp ah,038H
 jz spacialKeyOut
 mov di,tabSi	;tab
 mov spacialSi,di
 mov bp,offset tabOut
 cmp ah,0FH
 jz spacialKeyOut
 mov di,scrlkSi	;scrlk
 mov spacialSi,di
 mov bp,offset scrlkOut
 cmp ah,046H
 jz spacialKeyOut
 mov di,enterSi	;enter
 mov spacialSi,di
 mov bp,offset enterOut
 cmp ah,01CH
 jz spacialKeyOut
 jmp default

spacialKeyOut:
 inc si
 cmp si,spacialSi
 jz toCompare2
 inc bp
 mov dl,[bp]
 mov byte ptr [bx],dl
 inc bx
 mov byte ptr [bx],00001111B
 inc bx
 jmp spacialKeyOut

toCompare2:
 mov cs:switch,0
 jmp compare

checkExtend2:
	mov di,homeSi	;home
	mov spacialSi,di
	mov bp,offset homeOut
	cmp ah,047H
	jz spacialKeyOut
	mov di,pgupSi	;pgup
	mov spacialSi,di
	mov bp,offset pgupOut
	cmp ah,049H
	jz spacialKeyOut
	mov di,endSi	;end
	mov spacialSi,di
	mov bp,offset endOut
	cmp ah,04FH
	jz spacialKeyOut
	mov di,pgdnSi	;pgdn
	mov spacialSi,di
	mov bp,offset pgdnOut
	cmp ah,051H
	jz spacialKeyOut
	mov di,insertSi	;insert
	mov spacialSi,di
	mov bp,offset insertOut
	cmp ah,052H
	jz toSpacialKeyOut
	mov di,deleteSi	;delete
	mov spacialSi,di
	mov bp,offset deleteOut
	cmp ah,053H
	jz toSpacialKeyOut
	jmp compare

toSpacialKeyOut:
	jmp spacialKeyOut

checkExtend1:
	mov ah,cs:switch
	mov si,0
	mov di,dnArrowSi	;dnarrow
	mov spacialSi,di
	mov bp,offset dnArrowOut
	cmp ah,050H
	jz toSpacialKeyOut
	mov di,upArrowSi	;upArrow
	mov spacialSi,di
	mov bp,offset upArrowOut
	cmp ah,048H
	jz toSpacialKeyOut
	mov di,leftArrowSi	;leftArrow
	mov spacialSi,di
	mov bp,offset leftArrowOut
	cmp ah,04bH
	jz toSpacialKeyOut
	mov di,rightArrowSi	;rightArrow
	mov spacialSi,di
	mov bp,offset rightArrowOut
	cmp ah,04dH
	jz toSpacialKeyOut
	jmp checkExtend2

compare:
	mov ah,cs:switch
	mov si,0

	cmp ah,01H		;ESC
	jz exit
	jmp spacialKey

default:
	cmp ah, 0E0H
	jz checkExtend1

Check_back:
	cmp ah, 00EH	;backspace
	jz backspace

Check_caps:
	cmp ah,03AH	;capsLock
	jz caps1
	cmp ah,0BAH	;capsLock	
	jz caps2

Check_shift:
	cmp ah, 02AH	;Lshift
	jz shift1
	cmp ah, 0AAH	;Lshift
	jz shift2
	cmp ah, 036H	;Rshift
	jz shift1
	cmp ah, 0B6H	;Rshift
	jz shift2
	mov temp_input, ah

compare_alpha:
	mov al, capsLockCheck
	xor al, shiftCheck
	cmp al, 0
	jz QSLoop1
	jmp QBLoop1

exit:
	mov ax,0
	mov ds,ax
	mov bx,9*4+2
	mov ax,cs:oldInt9_1
	mov [bx],ax
	mov bx,9*4
	mov ax,cs:oldInt9_2
	mov [bx],ax
	mov ax,4C00H
	int 21H

backspace:
	cmp bx, 1
	jle Check_caps
	sub bx, 2
	mov dl, 0h
	mov byte ptr [bx],dl
	inc bx
	mov byte ptr [bx],00001111B
	dec bx
	mov cs:switch,0
	jmp Check_caps

caps1:
	mov capsLockCheck, 1
	jmp Check_shift

caps2:
	mov capsLockCheck, 0
	jmp Check_shift

shift1:
	mov shiftCheck, 1
	jmp compare_alpha

shift2:
	mov shiftCheck, 0
	jmp compare_alpha

toCompare:
	jmp compare

QSLoop1:
	inc si
	cmp si,scan_num
	jz toCompare
	cmp si, 27
	jz QNShift
	cmp ah,qzScan[si]
	jz QSPrint
	jmp QSLoop1

QBLoop1:
	inc si
	cmp si,scan_num
	jz toCompare
	cmp si, 27
	jz QNShift
	cmp ah,qzScan[si]
	jz QBPrint
	jmp QBLoop1

QNShift:
	cmp shiftCheck, 0
	jz QNLoop1
	jmp QNLoop2

QNLoop1:
	cmp si,scan_num
	jz toCompare
	cmp ah,qzScan[si]
	jz QSPrint
	inc si
	jmp QNLoop1

QNLoop2:
	cmp si,scan_num
	jz toCompare
	cmp ah,qzScan[si]
	jz QBPrint
	inc si
	jmp QNLoop2

QSPrint:
	mov dl,qzSmallAscii[si]
	mov byte ptr [bx],dl
	inc bx
	mov byte ptr [bx],00001111B
	inc bx
	mov cs:switch,0
	jmp toCompare

QBPrint:
	mov dl,qzBigAscii[si]
	mov byte ptr [bx],dl
	inc bx
	mov byte ptr [bx],00001111B
	inc bx
	mov cs:switch,0
	jmp toCompare

code ends
end start