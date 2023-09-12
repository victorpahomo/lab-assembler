.data
size_prompt: .asciiz "Ingrese la cantidad de ejecuciones desea de la serie:  "
fibs_prompt: .asciiz "Los primeros n números de Fibonacci son:\n"

      .text
      la   $a0, size_prompt   # Imprimir el mensaje "Ingrese el tamaño del arreglo (n): "
      li   $v0, 4             # Cargar el código de la llamada al sistema para imprimir una cadena
      syscall

      li   $v0, 5             # Cargar el código de la llamada al sistema para leer un entero
      syscall
      move $t5, $v0           # Almacenar el tamaño ingresado en $t5

      # Validar que el tamaño sea mayor a 0
      blez $t5, exit           # Si el tamaño es <= 0, salta a la etiqueta "exit"

      # Asignar memoria dinámica para el arreglo
      sll $t6, $t5, 2          # Calcular el número de bytes necesarios para el arreglo (4 bytes por palabra)
      li   $v0, 9             # Cargar el código de la llamada al sistema para asignar memoria dinámica
      move $a0, $t6           # Pasar el tamaño en bytes como argumento
      syscall
      move $t0, $v0           # Almacenar la dirección base del arreglo en $t0

      # Inicializar los primeros dos números de Fibonacci
      li   $t2, 1              # F[0] = 1
      li   $t3, 1              # F[1] = 1
      sw   $t2, 0($t0)         # Almacenar F[0] en el arreglo
      sw   $t3, 4($t0)         # Almacenar F[1] en el arreglo

      # Calcular y almacenar los números de Fibonacci restantes
      addi $t4, $t0, 8          # Inicializar $t4 para apuntar a F[2]
      li   $t1, 2               # Inicializar contador en 2
loop: beq  $t1, $t5, print_fibs  # Si hemos calculado suficientes números, imprimir y salir del bucle
      lw   $t2, -8($t4)         # Cargar F[n-2] desde la memoria
      lw   $t3, -4($t4)         # Cargar F[n-1] desde la memoria
      add  $t6, $t2, $t3        # Calcular F[n] = F[n-2] + F[n-1]
      sw   $t6, 0($t4)          # Almacenar F[n] en la memoria
      addi $t4, $t4, 4          # Avanzar a la siguiente posición en el arreglo
      addi $t1, $t1, 1          # Incrementar el contador
      j    loop

print_fibs:
      # Imprimir los números de Fibonacci
      la   $a0, fibs_prompt     # Cargar el mensaje "Los primeros n números de Fibonacci son:"
      li   $v0, 4               # Cargar el código de la llamada al sistema para imprimir una cadena
      syscall

      move $a0, $t5             # Pasar el tamaño como argumento
      move $a1, $t0             # Pasar la dirección del arreglo como argumento
      jal  print_fibonacci      # Llamar a la rutina de impresión de Fibonacci

exit:
      li   $v0, 10              # Cargar el código de la llamada al sistema para salir
      syscall

# Rutina para imprimir los números de Fibonacci en el arreglo con espacios entre ellos
print_fibonacci:
      move $t1, $a0             # Copiar el tamaño a $t1
      move $t0, $a1             # Copiar la dirección del arreglo a $t0

      li   $t2, 0               # Inicializar un contador para controlar los espacios

loop_print:
      lw   $a0, 0($t0)          # Cargar el número de Fibonacci actual
      li   $v0, 1               # Cargar el código de la llamada al sistema para imprimir un entero
      syscall

      # Imprimir un espacio después de cada número (excepto después del último)
      addi $t2, $t2, 1          # Incrementar el contador de espacios
      beq  $t2, $t1, no_space   # Si hemos llegado al último número, no imprimir espacio

      # Imprimir un espacio
      li   $v0, 11              # Cargar el código de la llamada al sistema para imprimir un carácter
      li   $a0, 32              # Cargar el valor ASCII del espacio en $a0
      syscall

no_space:
      addi $t0, $t0, 4          # Avanzar a la siguiente posición en el arreglo
      addi $t2, $t2, 1          # Incrementar el contador
      addi $t1, $t1, -1         # Decrementar el contador
      bgtz $t1, loop_print      # Repetir si no ha terminado
      jr   $ra                  # Retorno
