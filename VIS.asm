section .data
	arr DB 78, 23, 12, 87, 98, 54, 11, 13, 18, 55, 31, 71, 74, 47, 66, 61, 82, 96, 22, 25
	len EQU $ - arr
	
	temp DW 0
	
	fact DB 0
	fArr DB '0', '0', '0', '0', '0', '1', 10
	fLen EQU $ - fArr
	quo DW 0
	
	%macro etapa_a 2
		xor bl, bl
		xor cl, cl
		jmp greater_cond
		get_greater:
			mov dl, [%1+ecx]
			if_else:
				cmp dl, bl
				jle end_if
				xor bl, bl
				mov bl, dl
			end_if:
			inc ecx
		greater_cond:
			cmp cl, %2
			jl get_greater
	%endmacro
	
	%macro etapa_b 1
		xor ax, ax
		xor al, al
		xor ah, ah
		xor cl, cl
		
		mov [%1], bl
		mov ax, [%1]
		
		mov cl, 10
		div cl
	%endmacro
	
	%macro etapa_c 2
		
	%endmacro
	
section .text

global _start

_start:

	;ETAPA A, ID = 2 (Maior valor do vetor)
	etapa_a arr, len
	
	;ETAPA B, ID = 1 (Digito da dezena)
	etapa_b temp
	
	;ETAPA C, ID = 1 (Fatorial)
	mov [fact], al
	xor ax, ax
	xor al, al
	xor ah, ah
	xor cl, cl
	inc cl
	mult_loop:
		xor edx, edx
		mov edx, fLen
		sub edx, 2
		arr_loop:
			mov ax, [fArr+edx]
			sub ax, '0'
			mul cl
			add ax, [quo]
			mov bl, 10
			div bl
			mov [quo], al
			add ah, '0'
			mov [fArr+edx], ah
			dec edx
		arr_cond:
			cmp dl, 0
			jge arr_loop
		inc cl
	mult_cond:
		cmp cl, [fact]
		jle mult_loop
	
	mov eax, 4
	mov ebx, 1
	mov ecx, fArr
	mov edx, fLen
	int 0x80
	
	mov eax, 1
	mov ebx, 0
	int 0x80
