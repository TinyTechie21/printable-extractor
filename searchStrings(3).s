WRITE = 1
stdout = 1
.section .data
eol: .ascii "\n"

.global searchStrings

.section .text

myPutChar:
# rdi : byte address
    push %rbp
    mov %rsp, %rbp
    
    mov $WRITE, %rax
    push %rdi
   push %rsi
    
    mov $1, %rdx
    mov %rdi, %rsi
    mov $stdout, %rdi
    syscall
    pop %rsi
    pop %rdi
    mov $0, %cl 
    
    mov %rbp, %rsp
    pop %rbp
    ret

searchStrings:
# rdi - en. base rsi - tamanho da area de memoria onde está o ficheiro
    push %rbp
    mov %rsp, %rbp

    
    
    
search_loop:
    movb (%rdi), %al   # carrega um byte da memória
    
    cmp $0x20, %al     # compara com 0x20 (espaço)
     jl test_enter      # salta se for menor que 0x20
    cmp $0x7E, %al     # compara com 0x7E (til)
     jg test_enter      # salta se for maior que 0x7E
        
       call myPutChar
       jmp not_printable
    
test_enter:
        cmp $0, %cl
        jne not_printable        #caso nao seja igual a 0
        
        push %rdi
        mov $eol, %rdi          #Enter para imprimir na linha seguinte
        call myPutChar
        pop %rdi
        
not_printable:
    inc %rdi          # avança para o próximo byte

    dec %rsi          # decrementa o tamanho restante
 
    cmp $0, %rsi
    jnz search_loop # salta para loop se ainda houver bytes
        
    
    mov %rbp, %rsp
    pop %rbp
    ret
