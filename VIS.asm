section .data
	; Define-se o array que sera trabalhado e sua variavel de tamanho
	array DB 78, 23, 12, 87, 98, 54, 11, 13, 18, 55, 31, 71, 74, 47, 66, 61, 82, 96, 22, 25	; Inicializa-se o array com numeros de 10 a 99
	arrayLength EQU $ - array									; Inicializa-se a constante de tamanho com o mesmo
	
	temp DW 0	; Variavel temporaria para uso posterior
	
	; Define-se utilitarios para o calculo do fatorial
	factorialOf DB 0				; Inicializa-se o valor do fatorial a ser calculado com 0 (sera atualizado depois da etapa 2)
	factorialValue DB "000001", 10		; Inicializa-se o array do valor fatorial de 'factorialOf' com 1 (este sera manipulado e impresso ao final)
							; ja que o fatorial maximo que o programa pode calcular é o de 9 (362880), este deve possuir no minimo 6 digitos
	factorialLength EQU $ - factorialValue	; Inicializa-se a constante de tamanho com o mesmo
	
	; Define-se utilitarios para impressao do valor ao final do programa
	finalMessage DB "Valor final: "	; Inicializa-se o array com a mensagem final
	messageLength EQU $ - finalMessage	; Inicializa-se a constante de tamanho com o mesmo
	
	; Define-se as macros para as etapas
	
	; A macro para a etapa a recebe, respectivamente, um array e seu tamanho, e retorna para bl seu maior elemento
	%macro step_a 2
		xor bl, bl			; Limpa bl (sera usado como maior)
		xor cl, cl			; Limpa cl (sera usado como indice)
		xor dl, dl			; Limpa dl (sera usado como valor a ser verificado)
		jmp greater_cond		; Imediatamente pula para a condicao do loop
		get_greater:			
			mov dl, [%1+ecx]	; Passa para dl o valor da posicao 'ecx' do array passado
			if_else:		
				cmp dl, bl	; Verifica se dl (valor atual) é maiora que bl (maior valor até entao)
				jle end_if	; Se for menor, mantem bl e finaliza a verificacao
				xor bl, bl	; Se for maior, limpa bl (valor antigo)...
				mov bl, dl	; ... Passa para bl o valor atualmente em dl
			end_if:		
			inc ecx		; Incrementa o contador
		greater_cond:			
			cmp cl, %2		; Verifica se o contador chegou no valor do tamanho do array
			jl get_greater		; Se chegou, finaliza. Se nao, volta para o inicio do loop
	%endmacro				; O resultado da operacao é mantido em bl
	
	; A macro para a etapa b recebe um valor qualquer e retorna para al o digito da dezena do mesmo
	%macro step_b 1
		mov [temp], BYTE 0	; Limpa variavel temporaria
		xor ax, ax		; Limpa ax (Dividendo)
		xor al, al		; Limpa al (Quociente)
		xor ah, ah		; Limpa ah (Resto)
		xor cl, cl		; Limpa cl (Divisor)
					
		mov [temp], %1		; Passa o valor para a variavel temporaria (o valor é esperado estar em um registrados de 8 bits)
		mov ax, [temp]		; Passa o valor da variavel temporaria para ax (convertendo o valor de 8 para 16 bits)
					
		mov cl, 10		; Passa 10 para o divisor
		div cl			; Efetua a divisao por dez, tendo o digito da dezena em al (quociente)
	%endmacro			; O resultado da operacao é mantido em al
	
	; A macro para a etapa c recebe, respectivamente, o valor para seu fatorial ser calculado e um array de zeros finalizado em 1 onde sera calculado e retornado o valor fatorial
	%macro step_c 2
		mov [temp], BYTE 0			; Limpa a variavel temporaria
		xor ax, ax				; Limpa ax (Dividendo)
		xor al, al				; Limpa al (Quociente)
		xor ah, ah				; Limpa ah (Resto)
		xor bl, bl				; Limpa bl (Divisor)
		xor cl, cl				; Limpa cl (sera usado como contador)
		inc cl					; "Inicializa" cl com 1 (Ele será usado na multiplicacao, portanto nao pode iniciar de 0)
		mult_loop:				
			xor edx, edx			; Limpa edx (Usado como indice do loop interno)
			mov edx, factorialLength	; Inicializa indice com o tamanho do array (ainda nao o final onde será trabalhado)
			sub edx, 2			; Volta duas posicoes (este é o final do valor fatorial, sua casa de unidade, pois 'factorialLength' é uma unidade após o final real...
							; ... e, na última posicao, há um digito para pular linha na hora da impressao)
							; A conta é feita de tras para frente no vetor ja que a unidade fica mais a direita do vetor
			arr_loop:			
				mov ax, [%2+edx]	; Passa para ax o valor na posicao 'edx'
				sub ax, '0'		; Como o array é uma string, subtrai 48 para transformar o valor do char no real valor
				mul cl			; Multiplica o digito em 'edx' pelo indice atual
				add ax, [temp]		; Adiciona o quociente da operacao anterior para gerar o real digito da casa 'edx'
				mov bl, 10		; Passa 10 para o divisor
				div bl			; Efetu a divisao por dez, tendo o quociente, digito da proxima casa (edx-1), em al e o resto, digito dasta casa (edx) em ah
				mov [temp], al		; Passa o quociente atual para a variavel temporaria
				add ah, '0'		; Adicona 48 para transformar o valor em seu caracter correspondente
				mov [%2+edx], ah	; Passa o digito para sua casa correspondente
				dec edx		; Anda para a "proxima" casa (anterior no array)
			arr_cond:			
				cmp dl, 0		; Verifica se a operacao ocorreu por todas as casas decimais
				jge arr_loop		; Se nao, segue o procedimento (volta ao inico do loop). Do contrario, finaliza
			inc cl				; Incrementa o contador, aproximando-se de n
		mult_cond:				
			cmp cl, [%1]			; Verifica se o contador ja passou de n (numero cujo fatorial esta sendo calculado)
			jle mult_loop			; Se passou, finaliza. Do contrario, passa para a proxima iteracao do loop
	%endmacro					; O resultado é mantido em 'factorialValue'
	
	; Funcao de impressao. Recebe, respectivamente, a mensagem a ser impressa e seu tamanha correspondente
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
	step_a array, arrayLength		; Chama a macro da etapa a, passando o array de numeros e seu tamanho
	
	; ETAPA B, ID = 1 (Digito da dezena)
	step_b bl				; Chama a macro da etapa b, passando o resultado da etapa a (maior valor do vetor, em bl)
	
	; ETAPA C, ID = 1 (Fatorial)
	mov [factorialOf], al			; Passa para factorialOf o resultado da etapa b (digito da dezena)
	step_c factorialOf, factorialValue	; Chama a macro da etapa c, passando o o resultado da etapa b, cujo fatorial deve ser calculado, e o array de saída, inicializado com "000001"
	
	; Impressao na tela do valor final
	print finalMessage, messageLength	; Chama a macro de impressao, passando a mensagem anterior ao valor e seu tamanho
	print factorialValue, factorialLength	; Chama a macro de impressao, passando o array com valor fatorial e seu tamanho
	
	; Finaliza o programa
	mov eax, 1
	mov ebx, 0
	int 0x80
