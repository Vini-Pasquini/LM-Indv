section .data
	arr DB 78, 23, 12, 87, 54, 95, 11, 13, 18, 55, 31, 71, 74, 47, 66, 61, 82, 96, 22, 25
	len EQU $ - arr
	
section .text

global _start

_start:

	;ETAPA A, ID = 2 (Maior valor do vetor)
	mov ebx, 0
	xor cl, cl
	jmp greater_cond
	get_greater:
		mov edx, [arr+ecx]
		if_else:
			cmp dl, bl
			jle end_if
			mov ebx, edx
		end_if:
		inc ecx
	greater_cond:
		cmp cl, len
		jl get_greater
	
	mov eax, 1
	int 0x80
	
	;ETAPA B, ID = 1 (Digito da dezena)
	
	
	;ETAPA C, ID = 1 (Fatorial)
	
	
