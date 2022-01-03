.data
     n: .space 4
     m: .space 4
     v: .space 400
     st: .space 150
     fr: .space 150
     inputsir: .space 400
     formatPrintf: .asciz "%d "
     formatPrintf2: .asciz "%s"
     formatPrintf3: .asciz "%d\n"
     formatPrintf4: .asciz "%s\n"
     delim: .asciz " "
     terminator: .asciz "\n"
     k: .long 0
     k1: .long 0
     k2: .long 0
     ok: .long 0
     negconst: .long -1
     nr: .space 4 


.text

.global main




// functia afisare:

afisare:
     pushl %ebp
     movl %esp, %ebp
     pushl %edi
     pushl %esi
     pushl %ebx
     
     movl 8(%ebp), %edi
     
     movl 12(%ebp), %edx
     movl %edx, k
     incl k
     
     xorl %ecx, %ecx
     incl %ecx
     
     jmp for_afisare
     
     
for_afisare:
     cmp %ecx, k
     je exit_for
     movl (%edi, %ecx, 4), %eax
     pushl %ecx
     pushl %eax
     pushl $formatPrintf
     call printf
     popl %ebx
     popl %ebx
     popl %ecx
     incl %ecx
     jmp for_afisare
     
     
exit_for:
     pushl %ecx
     pushl $terminator
     pushl $formatPrintf2
     call printf
     popl %ebx
     popl %ebx
     popl %ecx
         
     popl %ebx
     popl %esi
     popl %edi
     popl %ebp
     ret




// functia verificare:
  
  
verificare:
     pushl %ebp
     movl %esp, %ebp
     pushl %edi
     pushl %esi
     pushl %ebx
     
     movl 8(%ebp), %edi
     movl 12(%ebp), %edx
     movl $v, %esi
     movl %edx, k
     incl k
     xorl %ecx, %ecx
     incl %ecx
     jmp verif_for
     
verif_for:
     cmp %ecx, k
     je verif_exit_1
     movl (%esi, %ecx, 4), %eax
     
     cmp $0, %eax
     je cont_verif_for
     
     movl (%edi, %ecx, 4), %ebx
     
     cmp %eax, %ebx
     jne verif_exit_0
     
     jmp cont_verif_for
     
cont_verif_for:
     incl %ecx
     jmp verif_for
     
verif_exit_1:
     movl $1, %eax
     popl %ebx
     popl %esi
     popl %edi
     popl %ebp
     ret
     
verif_exit_0:
     movl $0, %eax
     popl %ebx
     popl %esi
     popl %edi
     popl %ebp
     ret



// functia pozitie:


pozitie:
     pushl %ebp
     movl %esp, %ebp
     pushl %edi
     pushl %esi
     pushl %ebx
     
     movl 8(%ebp), %edi
     movl 12(%ebp), %edx
     
     movl %edx, k1
    
     movl %edx, k2
     incl k2

     xorl %ecx, %ecx
     incl %ecx
     jmp for1
     
     
for1:
     cmp %ecx, k1
     je poz_exit_1
     movl (%edi, %ecx, 4), %ebx
     movl %ecx, %edx
     incl %edx
     jmp for2
     

for2:
     cmp %edx, k2
     je for1_cont
     
     movl (%edi, %edx, 4), %eax
     cmp %eax, %ebx
     je distanta
     
     jmp for2_cont


for1_cont:
     incl %ecx
     jmp for1


for2_cont:
     incl %edx
     jmp for2


distanta:
     movl %edx, %eax
     sub %ecx, %eax
     sub $1, %eax
     
     
     cmp %eax, m
     jg poz_exit_0
     jmp for2_cont


poz_exit_1:
     movl $1, %eax
     popl %ebx
     popl %esi
     popl %edi
     popl %ebp
     ret
     
poz_exit_0:
     movl $0, %eax
     popl %ebx
     popl %esi
     popl %edi
     popl %ebp
     ret



// functia backtracking:

bkt:
     pushl %ebp
     movl %esp, %ebp
     pushl %esi
     pushl %edi
     pushl %ebx
     
     movl 8(%ebp), %esi
     movl 12(%ebp), %edi
     movl 16(%ebp), %edx
     movl %edx, k
     
     xorl %ecx, %ecx
     incl %ecx
     jmp for_bkt
     
     
for_bkt:
     cmp %ecx, n
     jl bkt_exit
     
     movl (%esi, %ecx, 4), %eax
     
     cmp $3, %eax
     jl step1
     
     jmp cont_for_bkt
     
     
step1:
     movl %ecx, (%edi, %edx, 4)
     incl (%esi, %ecx, 4)
     
     // apelam functia verificare:
     
     pushl %ecx
     pushl %edx
     
     pushl %edx
     pushl $st
     call verificare
     popl %ebx
     popl %ebx
     
     popl %edx
     popl %ecx
     
     cmp $1, %eax
     jne bkt_recall
     
     
     // apelam functia pozitie:
     
     pushl %ecx
     pushl %edx
     
     pushl %edx
     pushl %edi
     call pozitie
     popl %ebx
     popl %ebx
     
     popl %edx
     popl %ecx
     
     cmp $1, %eax
     jne bkt_recall


     // verificam daca k=3*n
     
     cmp %edx, nr
     je finalizare
     jmp bkt_recall
     
     
finalizare:
     pushl %ecx
     pushl %edx
     
     pushl %edx
     pushl %edi
     call afisare
     popl %ebx
     popl %ebx
     
     popl %edx
     popl %ecx
     
     movl $1, ok
     jmp bkt_exit
     
bkt_recall:
     pushl %ecx
     pushl %edx
     
     incl %edx
     
     pushl %edx
     pushl %edi
     pushl %esi
     call bkt
     popl %ebx
     popl %ebx
     popl %ebx
     
     
     popl %edx
     popl %ecx
     
     decl (%esi, %ecx, 4)
     jmp cont_for_bkt
     
bkt_exit:
     popl %ebx
     popl %edi
     popl %esi
     popl %ebp
     ret
     

cont_for_bkt:
     incl %ecx
     jmp for_bkt    
     
     
// functia main:
     


main:
    pushl $inputsir
    call gets
    popl %ebx
    
    // citim inputul 
    
    pushl $delim
    pushl $inputsir
    
    call strtok
    popl %ebx
    popl %ebx
    pushl %eax
    call atoi
    popl %ebx
    
    movl %eax, n
    
    // citim n-ul
    
    pushl $delim
    pushl $0
    call strtok
    popl %ebx
    popl %ebx
    pushl %eax
    call atoi
    popl %ebx
    
    movl %eax, m
    
    // citim m-ul
    
    xorl %ecx, %ecx
    incl %ecx
    movl $v, %esi
    movl n, %eax
    movl $3, %edx
    mull %edx
    movl %eax, nr
    
    
    
et_for:
    // citim numerele din permutare
    
    cmp %ecx, nr
    jl task
    
    pushl %ecx
    
    pushl $delim
    pushl $0
    call strtok
    popl %ebx
    popl %ebx
    pushl %eax
    call atoi
    popl %ebx
    
    popl %ecx
    
    movl %eax,(%esi, %ecx, 4)
    
    
    
    // am pus numarul citit in vectorul v
    
    incl %ecx
    
    jmp et_for
    
    
task:
    

    // facem bkt
    movl k, %edx
    incl %edx
    
    pushl %edx
    pushl $st
    pushl $fr
    call bkt
    popl %ebx
    popl %ebx
    popl %ebx
    
    cmp $0, ok
    je afisare_neg
    jmp exit
    
    
afisare_neg:
    pushl negconst
    pushl $formatPrintf3
    call printf
    popl %ebx
    popl %ebx
    
    jmp exit

exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80    
