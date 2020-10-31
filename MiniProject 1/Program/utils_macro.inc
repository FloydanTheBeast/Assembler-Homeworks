; меняет значения переданных переменных местами
macro SwapVars var1, var2 {
	mov eax, [var1]
	mov ecx, [var2]
	mov [var1], ecx
	mov [var2], eax
}