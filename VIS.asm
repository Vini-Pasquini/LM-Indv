section .data
	arr DB 78, 23, 12, 87, 54, 12, 11, 13, 18, 55, 31, 71, 74, 47, 66, 61, 97, 82, 22, 25
	len EQU $ - arr
	temp DW 0
	
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
	
	%macro etapa_b 2
		
	%endmacro
	
	%macro etapa_c 2
		
	%endmacro
	
section .text

global _start

_start:

	;ETAPA A, ID = 2 (Maior valor do vetor)
	etapa_a arr, len
	
	;ETAPA B, ID = 1 (Digito da dezena)
	
	xor ax, ax
	xor al, al
	xor ah, ah
	xor cl, cl
	
	mov [temp], bl
	mov ax, [temp]
	
	mov cl, 10
	div cl
	
	xor bl, bl
	mov bl, al
	
	;ETAPA C, ID = 1 (Fatorial)
	
	
	mov eax, 1
	int 0x80
