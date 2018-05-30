%macro print 2
    mov eax, 4
    mov ebx, 1
    mov ecx, %1; Que se va a imprimir
    mov edx, %2; La longitud de lo que se va a imprimir
    int 0x80
%endmacro
%macro input 2
  mov eax, 3
  mov ebx, 0
  mov ecx, %1; Donde guardar el valor
  mov edx, %2; el tamaño de la localidad de memoria
  int 0x80
%endmacro
segment .data
    arreglo db 0,0
    len equ $-arreglo
    ln db 10,13
    lenln equ $-ln
    salto_linea db 10,13
    len_salto equ $-salto_linea
segment .bss
    datos resb 1
    aux1 resb 1
    aux2 resb 1
    resu resb 1
segment .text
global _start
_start:
    mov esi, arreglo; SE MUEVE AL REGISTRO ESI LA DIRECCION DEL ARREGLO
    mov edi,0; SE LIMPIA EL REGISTRO MOVIENDO UN 0
    input datos, 2; SE PIDE AL USUARIO UNA ENTRADA POR TECLADO
    mov al,[datos+0]; SE MUEVE A LA PARTE BAJA DE AX EL PRIMER DIGITO A LA IZQUIERDA
    sub al,'0'; SE LE RESTA '0' PARA PODER OBTENER EL VALOR NUMERICO (NO ASCII)
    mov [esi],al; SE GUARDA EN "arreglo" EL VALOR DE AL
    mov al,[datos+1]; SE REPITE EL MISMO PROCESO PARA EL SEGUNDO DIGITO
    sub al,'0'
    mov [esi+1],al; SE GUARDA EN "arreglo + 1" EL VALOR DE AL
    mov ebp, arreglo
    mov edi,0; SERVIRA COMO CONTADOR PARA IMRPIMIR 2 DIGITOS
_impri:
    mov al, [ebp+edi]
    add al, '0'
    mov [datos], al
    add edi,1
    print datos, 1
    cmp edi, 2
    jb _impri
    print salto_linea, len_salto
_ciclo_eleva:
    mov al, [ebp]; SE GUARDA EN AL EL VALOR DE EBP
    mul al; SE MULTIPLICA EL VALOR ALMACENADO EN "AL" POR SI MISMO
    mov [aux1], al; SE GUARDA EL VALOR EN AUX1
    mov al, [ebp+1]; SE REALIZA LA MISMA OPERACION CON EL DIGITO A LA DERECHA
    mul al
    mov [aux2], al
    mov eax, [aux1]; SE RECUPERA EL VALOR DEL DIGITO A LA IZQUIERDA
    mov ebx, [aux2]; SE RECUPERA EL VALOR DEL DIGITO A LA DERECHA
    add eax, ebx; SE SUMAN AMBOS RESULTADOS
    mov [resu], eax; SE ALMACENA EL RESULTADO DE LA SUMA EN RESU
    mov ax, 0; SE LIMPIA EL REGISTRO
    mov al, [resu]; SE RECUPERA DE NUEVO EL VALOR DEL RESULTADO DE LAS SUMA DE LOS CUADRADOS
    cmp al, 1
    je _salir
;---------------------------------------------------------------------
    mov dl, 10
    div dl
    mov [arreglo+0], al
    mov [arreglo+1], ah
    mov ebp, arreglo
    mov edi, 0
_imprimir:
    mov al, [ebp+edi]
    add al, '0'
    mov [datos], al
    add edi,1
    print datos, 1
    cmp edi, 2
    jb _imprimir
    print salto_linea, len_salto
    mov ebp, arreglo
    mov edi,0
    jmp _ciclo_eleva
_salir:
    mov dl, 10
    div dl
    mov [arreglo+0], al
    mov [arreglo+1], ah
    mov ebp, arreglo
    mov edi,0
_sa:
    mov al, [ebp+edi]
    add al, '0'
    mov [datos], al
    add edi,1
    print datos, 1
    cmp edi, 2
    jb _sa
    print salto_linea, len_salto
    
    mov eax, 1
    xor ebx, ebx
    int 0x80