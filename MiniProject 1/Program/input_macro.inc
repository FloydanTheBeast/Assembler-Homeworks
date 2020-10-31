include 'utils_macro.inc'

macro InputMacro {
stringInput:
	cinvoke printf, strScanStringMsg
	cinvoke scanf, strScanString, inputString
	stdcall GetStringLength, inputString
	mov [strLen], eax ; сохраняем длину строки в strLen
inputValues:
	; ввод индексов начала и конца построки
	cinvoke printf, strScanIntMsg
	cinvoke scanf, strScanInt, i
	cinvoke printf, strScanIntMsg
	cinvoke scanf, strScanInt, j

	mov eax, [i]
	mov ecx, [j]

	; если i > j, то меняем их местами
	cmp eax, ecx 
	jg swapVars
	jmp checkValues
swapVars:
	SwapVars i, j
checkValues:
	; проверка меньшего индекса
	mov eax, [i]
	mov ecx, [strLen]
	
	; если число больше длины строки
	cmp eax, ecx
	jge valueGreaterThanLength

	; если число меньше нуля
	cmp eax, 0
	jl valueLessThanZero

	; проверка большего индекса
	mov eax, [j]

	; если число больше длины строки
	cmp eax, ecx
	jge valueGreaterThanLength

	; если число меньше нуля
	cmp eax, 0
	jl valueLessThanZero

	; продолжение программы
	jmp reverseSubstring
valueGreaterThanLength:
	cinvoke printf, strValueFailGL, [strLen]
	jmp valueFailed
valueLessThanZero:
	cinvoke printf, strValueFailLZ
	jmp valueFailed
valueFailed:
	jmp inputValues
}