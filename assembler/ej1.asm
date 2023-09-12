.data
prompt1: .asciiz "Ingrese el primer número: "     # Mensaje para solicitar el primer número al usuario
prompt2: .asciiz "Ingrese el segundo número: "    # Mensaje para solicitar el segundo número al usuario
prompt3: .asciiz "Ingrese el tercer número: "     # Mensaje para solicitar el tercer número al usuario
result: .asciiz "El número mayor es: "            # Mensaje para mostrar el número mayor
equal_msg: .asciiz "Los 3 números son iguales"    # Mensaje para números iguales

.text
.globl main

main:
    # Solicitar entrada al usuario
    li $v0, 4         # Cargar el valor 4 en $v0 (código de la syscall para imprimir cadena)
    la $a0, prompt1  # Cargar la dirección de 'prompt1' en $a0 (cadena a imprimir)
    syscall

    # Leer el primer número
    li $v0, 5         # Cargar el valor 5 en $v0 (código de la syscall para leer entero)
    syscall
    move $t0, $v0     # Copiar el valor leído desde $v0 a $t0

    li $v0, 4         # Cargar el valor 4 en $v0 (código de la syscall para imprimir cadena)
    la $a0, prompt2  # Cargar la dirección de 'prompt2' en $a0 (cadena a imprimir)
    syscall

    # Leer el segundo número
    li $v0, 5         # Cargar el valor 5 en $v0 (código de la syscall para leer entero)
    syscall
    move $t1, $v0     # Copiar el valor leído desde $v0 a $t1

    li $v0, 4         # Cargar el valor 4 en $v0 (código de la syscall para imprimir cadena)
    la $a0, prompt3  # Cargar la dirección de 'prompt3' en $a0 (cadena a imprimir)
    syscall

    # Leer el tercer número
    li $v0, 5         # Cargar el valor 5 en $v0 (código de la syscall para leer entero)
    syscall
    move $t2, $v0     # Copiar el valor leído desde $v0 a $t2

    # Verificar si los números son iguales
    beq $t0, $t1, check_t2  # Saltar a 'check_t2' si $t0 y $t1 son iguales
    beq $t0, $t2, check_t1  # Saltar a 'check_t1' si $t0 y $t2 son iguales
    beq $t1, $t2, check_result  # Saltar a 'check_result' si $t1 y $t2 son iguales

    # Encontrar el número mayor
    move $t3, $t0     # Inicializar $t3 con $t0
    blt $t1, $t3, update_max  # Saltar a 'update_max' si $t1 es menor que $t3
    move $t3, $t1     # Actualizar $t3 con $t1 si es mayor
update_max:
    blt $t2, $t3, print_result  # Saltar a 'print_result' si $t2 es menor que $t3
    move $t3, $t2     # Actualizar $t3 con $t2 si es mayor
    j print_result     # Saltar directamente a 'print_result' después de encontrar el máximo

check_t1:
    beq $t1, $t2, equal_numbers  # Saltar a 'equal_numbers' si $t1 y $t2 también son iguales
    j check_result  # Si solo $t0 y $t2 son iguales, continuar con la verificación del resultado

check_t2:
    beq $t1, $t2, equal_numbers  # Saltar a 'equal_numbers' si $t1 y $t2 también son iguales
    j check_result  # Si solo $t0 y $t1 son iguales, continuar con la verificación del resultado

equal_numbers:
    li $v0, 4         # Cargar el valor 4 en $v0 (código de la syscall para imprimir cadena)
    la $a0, equal_msg  # Cargar la dirección de 'equal_msg' en $a0 (mensaje de igualdad)
    syscall
    j exit            # Saltar a 'exit' para salir del programa

check_result:
    j print_result     # Si los números no son iguales, imprimir el resultado directamente

print_result:
    li $v0, 4         # Cargar el valor 4 en $v0 (código de la syscall para imprimir cadena)
    la $a0, result    # Cargar la dirección de 'result' en $a0 (mensaje de resultado)
    syscall

    li $v0, 1         # Cargar el valor 1 en $v0 (código de la syscall para imprimir entero)
    move $a0, $t3     # Cargar el valor de $t3 (el número mayor) en $a0
    syscall

exit:
    # Salir del programa
    li $v0, 10        # Cargar el valor 10 en $v0 (código de la syscall para salir del programa)
    syscall

