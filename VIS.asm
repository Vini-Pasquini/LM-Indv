section .data
	array DB 78, 23, 12, 87, 98, 54, 11, 13, 18, 55, 31, 71, 74, 47, 66, 61, 82, 96, 22, 25
	arrayLength EQU $ - array
	
	temp DW 0
	
	factorialOf DB 0
	factorialValue DB "000001", 10
	factorialLength EQU $ - factorialValue
	
	finalMessage DB "Valor final: "
	messageLength EQU $ - finalMessage
	
	%macro step_a 2
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
	
	%macro step_b 1
		xor ax, ax
		xor al, al
		xor ah, ah
		xor cl, cl
		
		mov [%1], bl
		mov ax, [%1]
		
		mov cl, 10
		div cl
	%endmacro
	
	%macro step_c 3
		mov [%1], al
		mov [%3], BYTE 0
		xor ax, ax
		xor al, al
		xor ah, ah
		xor cl, cl
		inc cl
		mult_loop:
			xor edx, edx
			mov edx, factorialLength
			sub edx, 2
			arr_loop:
				mov ax, [%2+edx]
				sub ax, '0'
				mul cl
				add ax, [%3]
				mov bl, 10
				div bl
				mov [%3], al
				add ah, '0'
				mov [%2+edx], ah
				dec edx
			arr_cond:
				cmp dl, 0
				jge arr_loop
			inc cl
		mult_cond:
			cmp cl, [%1]
			jle mult_loop
	%endmacro
	
	%macro print 2
		mov eax, 4
		mov ebx, 1
		mov ecx, %1
		mov edx, %2
		int 0x80
	%endmacro
	
section .text

global _start

_start:

	; ETAPA A, ID = 2 (Maior valor do vetor)
	step_a array, arrayLength
	
	; ETAPA B, ID = 1 (Digito da dezena)
	step_b temp
	
	; ETAPA C, ID = 1 (Fatorial)
	step_c factorialOf, factorialValue, temp
	
	; Impressao na tela do valor final
	print finalMessage, messageLength
	print factorialValue, factorialLength
	
	; Finaliza o programa
	mov eax, 1
	mov ebx, 0
	int 0x80
