section .data
	arr DB 78, 23, 12, 87, 54, 95, 11, 13, 18, 55, 31, 71, 74, 47, 66, 61, 82, 98, 22, 25
	len EQU $ - arr
	
	%macro etapa_a 2
		mov ebx, 0
		xor cl, cl
		jmp greater_cond
		get_greater:
			mov edx, [%1+ecx]
			if_else:
				cmp dl, bl
				jle end_if
				mov ebx, edx
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
	
	mov eax, 1
	int 0x80
	
	;ETAPA B, ID = 1 (Digito da dezena)
	
	
	;ETAPA C, ID = 1 (Fatorial)
	
	
