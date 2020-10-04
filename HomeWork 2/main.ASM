; Абдельсалам Шади, БПИ191
; Вариант №1

; Условие задачи: Разработать программу, которая вводит одномерный массив A[N],
; формирует из элементов массива A новый массив B по правилам, указанным в таблице, и выводит его.
; Память под массивы может выделяться как статически, так и динамически по выбору разработчика.
; Массив B состоит из положительных элементов А.

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable
        ; string variables
        strVecSize   db 'Enter the size of vector: ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strVecElemOut  db '[%d] = %d', 10, 0
        strInitVec db 'Initial vector:', 10, 0
        strPosVec db 'Positive vector:', 10, 0
        strProgramFinish db 'The program has finished working...', 10, 0

        ; number variables
        vecSize     dd 0
        sum          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100
        positiveVec  rd 100
        positiveVecSize dd 0

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) vector input
        call VectorInput
; 2) get positive vector
        call GetPositiveVector
; 3) vector out
        push strInitVec
        call [printf]
        add esp, 4
        call VectorOut

        push strPosVec
        call [printf]
        add esp, 4
        call PositiveVectorOut
        push strProgramFinish
        call [printf]
        add esp, 4

finish:
        call [getch]
        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vecSize
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vecSize]
        cmp eax, 0
        jg  getVector

; fail size
        push [vecSize]
        push strIncorSize
        call [printf]
        jmp VectorInput

; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec

getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vecSize]
        jge endInputVector       ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop

endInputVector:
        ret
;--------------------------------------------------------------------------
GetPositiveVector:
        mov edx, positiveVec    ; edx = &positiveVec
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec

positiveVecLoop:
        cmp ecx, [vecSize]
        je endGetPositiveVector      ; to end of loop

        ; check if an element is positive by comparing it comparing it to a zero
        mov eax, [ebx]
        cmp eax, 0
        jle vectorIncrement

        mov [edx], eax
        add edx, 4

        ; increment size of positive vector
        mov eax, [positiveVecSize]
        add eax, 1
        mov [positiveVecSize], eax

vectorIncrement:
        inc ecx
        add ebx, 4
        jmp positiveVecLoop

endGetPositiveVector:
        ret
;--------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec

putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vecSize]
        je endOutputVector      ; to end of loop
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop

endOutputVector:
        mov esp, [tmpStack]
        ret

;--------------------------------------------------------------------------
PositiveVectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, positiveVec

putPositiveVectorLoop:
        mov [tmp], ebx
        cmp ecx, [positiveVecSize]
        je endOutputPositiveVector      ; to end of loop
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putPositiveVectorLoop

endOutputPositiveVector:
        mov esp, [tmpStack]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'