.data
v: .space 4096
n: .long 1024
n1:.long 1023
id: .space 4
kb: .space 4
poz_start: .long -1
poz_stop: .space 4
poz_start_get: .long -1
poz_stop_get: .long -1
poz_start_delete: .long -1
poz_stop_delete: .long -1
poz_start_defrag: .long -1
poz_stop_defrag: .long -1
blocuri: .space 4
nr_operatii: .space 4
id_operatie: .space 4
id_delete:.space 4
descriptor: .space 4
nr_fisiere: .space 4
id_curent: .space 4
index: .long 0
found: .long 0
formatInput: .asciz "%d"
formatprintf0: .asciz "(%d, %d)\n"
formatprintf1: .asciz "(%d, %d)\n" 
formatprintf2: .asciz "%d: (%d, %d)\n"


.text
 
ADD:
    
    push %ebp           #pun stackframe
    movl %esp, %ebp     
    pusha

    push $nr_fisiere
    push $formatInput
    call scanf
    addl $8, %esp

    
    movl $1, %ebx
    et_for_citire_id_kb:

       
        push $id            #citire descriptor(notat cu id)
        push $formatInput
        call scanf
        addl $8, %esp

        push $kb            #citire dimensiune(notam cu kb)
        push $formatInput
        call scanf
        addl $8, %esp


     
        movl kb, %eax       #memoram in eax nr de kb pentru a calcula dimensiunea
        xorl %ecx, %ecx

        et_add:

            pushl %ebx
            addl $7, %eax
            shrl $3, %eax           #eax retine numarul de blocuri din vector care trebuie completate folosind ADD
            pushl %eax              #salvez valoarea lui eax pe stiva
            popl %esi               #numarul de blocuri e retinut in %esi

            xorl %ecx, %ecx
            xorl %ebx, %ebx
            movl $-1, %edx
            xorl %eax, %eax

            movl $0, blocuri

            cmpl n, %esi
            jg et_returnare_caz_imposibil_add

            et_for_add:

                cmpl n, %ecx
                jge et_testare_add      #daca la finalul for-ului 
                cmpl $0, (%edi, %ecx,4)
                jne not_zero


        #in cazul in care v[ecx]==0

        incl %ebx               #incrementare blocuri
        movl %ebx, blocuri
        cmp %esi, %ebx          #verificam daca am gasit numarul de blocuri cautat
        jne blocuri_inegale


        movl %ecx, %edx         #start=pozitie element pentru care se umple nr de blocuri care trebuie ocupate
        subl %ebx, %edx         #start=pozitie-blocuri
        incl %edx               #start=poz-blocuri+1
        movl %edx, poz_start 

        addl poz_start, %esi                 #memoreaza in esi pozitia de oprire a secventei
        decl %esi
        cmpl n, %esi
        jg et_returnare_caz_imposibil_add

        jmp et_replace


    not_zero:

    # daca elementul nu e zero reseteaza numaratoarea blocurilor
    xorl %ebx, %ebx
    movl $0, blocuri
    movl $-1, poz_start

    blocuri_inegale:
    incl %ecx           #se incrementeaza daca nu se ocupa toate blocurile
    jmp et_for_add      #se executa structura repetitiva

    et_testare_add:

        #daca ajungem in aceasta eticheta inseamna ca nu am gasit suficiente blocuri si poz_start=-1

        
        movl poz_start, %eax
        cmpl $-1, %eax
        je et_returnare_caz_imposibil_add

        #in caz contrar sare la inlocuire

        jmp et_replace

    et_returnare_caz_imposibil_add:

        pushl %ecx
        pushl $0
        pushl $0
        pushl id
        pushl $formatprintf2
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ecx

        pushl $0
        call fflush
        popl %ebx

        jmp et_add_gata

    et_replace:
        xorl %ecx, %ecx
        movl poz_start, %ecx
        subl $1, %ecx       #ecx =start-1
        movl %ecx, %edx
        movl blocuri, %eax
        addl %eax, %edx
        movl %edx, poz_stop


    et_for_replace:
        incl %ecx
        movl id, %eax
        movl %eax, (%edi, %ecx, 4)
        cmpl %ecx, %edx
        jg et_for_replace

    
    et_afisare_add:

        pushl %ecx
        pushl poz_stop
        pushl poz_start 
        pushl id
        pushl $formatprintf2
        call printf
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ebx
        popl %ecx

        push $0
        call fflush
        popl %ebx

        
        et_add_gata:

        popl %ebx

        et_incrementare_add:

        cmpl %ebx, nr_fisiere
        je et_final_add  
        incl %ebx
        jmp et_for_citire_id_kb
            
        et_final_add:

        popa
        pop %ebp
        ret 

GET:    
    push %ebp           #pun stackframe
    movl %esp, %ebp     
    pusha

    pushl $id
    pushl $formatInput
    call scanf
    addl $8, %esp

    movl id, %esi

    xorl %ecx, %ecx     #index vector
    xorl %ebx, %ebx
    movl $-1, %edx      #mutam poz_start in %edx
    movl $-1, poz_stop_get
    movl $-1, poz_start_get
    
    
    et_for_get:

        cmpl n, %ecx
        jge et_testare_get

        cmpl %esi, (%edi, %ecx,4)    #verifica daca v[ecx]==id
        jne et_continue_get
             
             movl %ecx, poz_stop_get       #muta succesiv ecx (pozitia curenta din v) in pozitia de oprire cat timp v[ecx]==id
             movl %ecx, %ebx

             cmpl $-1, %edx         #verifica daca pozitia de start nu a fost initializata
             jne et_continue_get

            movl %ecx, %edx
            movl %edx, poz_start_get  #muta in pozitia de inceput prima pozitie pe care gaseste un element din vector egal cu id
             
        
        et_continue_get:
            incl %ecx
            jmp et_for_get


        et_testare_get:
            movl $-1, %edx      #reinitializare edx pentru testarea cazului in care nu este gasita nicio secventa care sa contina id
            cmpl poz_start_get, %edx
            je et_returnare_caz_imposibil_get
            
            jmp et_afisare_get


        et_returnare_caz_imposibil_get:
        
            pushl $0
            pushl $0
            push $formatprintf0
            call printf
            popl %ebx   
            popl %ebx             
            popl %ebx
        

            
            pushl $0
            call fflush
            popl %ebx
            

            jmp et_final_get

        et_afisare_get:

        
            pushl poz_stop_get
            pushl poz_start_get
            pushl $formatprintf1
            call printf
            popl %ebx
            popl %ebx
            popl %ebx
            

        
            pushl $0
            call fflush
            popl %ebx
            

        et_final_get:

        popa
        pop %ebp
        ret

DELETE:

        push %ebp
        movl %esp, %ebp
        pusha

        pushl $id
        pushl $formatInput
        call scanf
        addl $8, %esp

        xorl %ecx, %ecx
        movl $-1, %edx
        movl id, %eax
        movl $-1, poz_stop_delete
        movl $-1, poz_start_delete

        
        et_for_delete_replace:

            cmpl n, %ecx 
            jge et_delete      #iesire din loop pentru index >=1024

            cmpl %eax, (%edi, %ecx,4)
            jne et_continue_delete_replace    #verifica daca v[ecx]!=id v[ecx] 
            
            movl $0, (%edi, %ecx, 4)
          

            et_continue_delete_replace:
                incl %ecx
                jmp et_for_delete_replace


        et_delete:
            movl poz_stop_delete, %ecx
            incl %ecx
    
        et_for_delete:

            cmpl n, %ecx
            jge et_final_delete

            cmpl $0, (%edi, %ecx, 4)            #compara v[ecx] cu 0
            je et_continue_delete_for           #daca v[ecx]==0, incrementeaza in continuare
            jmp et_delete_caz_posibil

                et_delete_caz_posibil:
                    movl (%edi, %ecx, 4), %ebx
                    movl %ebx, id_curent
                    movl %ecx, poz_start_delete

                    et_parcurgere_delete:
                    incl %ecx

                    cmpl $1025, %ecx
                    jge et_final_delete

                    cmpl %ebx, (%edi, %ecx, 4)
                    je et_continue_poz_stop

                         et_afisare_delete:
                            pushl poz_stop_delete
                            pushl poz_start_delete
                            pushl id_curent
                            pushl $formatprintf2
                            call printf
                            addl $16, %esp

                            jmp et_delete  

                    et_continue_poz_stop:

                        movl %ecx, poz_stop_delete
                        jmp et_parcurgere_delete


             et_continue_delete_for:
                incl %ecx
                jmp et_for_delete
                      
                
    et_final_delete:
        popa 
        pop %ebp
        ret
    
DEFRAGMENTATION:

    push %ebp
    movl %esp, %ebp
    pusha

    xorl %ecx, %ecx
    xorl %ebx, %ebx
    xorl %edx, %edx
    movl $-1, poz_start_defrag
    movl $-1,poz_stop_defrag

    et_for_defragmentation:

        cmpl n, %ecx
        jge et_defragmentation

        cmpl $0, (%edi, %ecx, 4)            #cauta primul v[ecx]==0
        jne et_continue_for_defragmentation

        movl %ecx, %ebx                     #retine pozitia primului element nul

        et_while_defragmentation:

            incl %ecx                       #continua incrementarea si cauta primul element diferit de 0
            cmpl n, %ecx
            jge et_defragmentation
            

            cmpl $0, (%edi, %ecx, 4)
            je et_while_defragmentation

            movl (%edi, %ecx, 4), %edx
            movl %edx, (%edi, %ebx, 4)      #realizeaza interschimbarea
            movl $0, (%edi, %ecx, 4)

            movl %ebx, %ecx                 #reinitializeaza ecx dupa interschimbare

        et_continue_for_defragmentation:
            incl %ecx
            jmp et_for_defragmentation


        #incepe cautarea de secvente diferite de 0


        et_defragmentation:
            movl poz_stop_defrag, %ecx      #initializeaza ecx cu pozitia de oprire a fiecarui interval 
            incl %ecx
    
        et_intervale_defragmentation:

            cmpl n, %ecx
            jge et_final_defragmentation

            cmpl $0, (%edi, %ecx, 4)                     #compara v[ecx] cu 0
            je et_continue_defragmentation               #daca v[ecx]==0, incrementeaza in continuare
            jmp et_defrag_caz_posibil

                et_defrag_caz_posibil:
                    movl (%edi, %ecx, 4), %ebx           #daca v[ecx]!=0 retine id-ul acestuia intr-o variabila globala si in registrul ebx
                    movl %ebx, id_curent
                    movl %ecx, poz_start_defrag

                    et_parcurgere_defrag:
                    incl %ecx

                    cmpl $1025, %ecx
                    jge et_final_defragmentation

                    cmpl %ebx, (%edi, %ecx, 4)
                    je et_increase_stop_defrag

                         et_afisare_defragmentation:
                            pushl poz_stop_defrag
                            pushl poz_start_defrag
                            pushl id_curent
                            pushl $formatprintf2
                            call printf
                            addl $16, %esp

                            jmp et_defragmentation  

                    et_increase_stop_defrag:

                        movl %ecx, poz_stop_defrag
                        jmp et_parcurgere_defrag

             et_continue_defragmentation:
                incl %ecx
                jmp et_intervale_defragmentation
                      
        et_final_defragmentation:
             popa 
             popl %ebp
             ret
    

.global main

main:

    push $nr_operatii
    push $formatInput
    call scanf
    addl $8, %esp
    
    xorl %ebx, %ebx

    lea v, %edi
    xorl %ecx, %ecx

    et_for_zero_vector:
         cmpl $1024, %ecx
         jge et_for_read
         movl $0, (%edi, %ecx, 4)
         incl %ecx
         jmp et_for_zero_vector


    et_for_read:

        cmp nr_operatii, %ebx  
        je et_exit
        incl %ebx


        push $id_operatie
        push $formatInput
        call scanf
        addl $8, %esp

        movl id_operatie, %eax
        
        cmp $1, %eax
        je et_call_add

        cmp $2, %eax
        je et_call_get

        cmp $3, %eax
        je et_call_delete

        cmp $4, %eax
        je et_call_defragmentation

        jmp et_for_read

        et_call_add:

            call ADD
            jmp et_for_read

        et_call_get:
            call GET
            jmp et_for_read

        et_call_delete:
            call DELETE
            jmp et_for_read
        
        et_call_defragmentation:
            call DEFRAGMENTATION
            jmp et_for_read

            
et_exit:
    pushl $0
    call fflush
    popl %eax
    
    mov $1, %eax
    mov $0, %ebx
    int $0x80
