.data

matrix: .space 4194304
v: .space 4194304
n: .long 1024
formatInput: .asciz "%d"
formatOutput: .asciz "%d: ((%d, %d), (%d, %d))\n"
formatOutputGET: .asciz "((%d, %d), (%d, %d))\n"
nr_operatii: .space 4
id_operatie: .space 4
nr_fisiere: .space 4
blocuri: .space 4
id: .space 4
kb: .space 4
line: .long -1
column: .long -1
startX: .long -1
startY: .long -1
stopX: .long -1
stopY: .long -1
len: .long  1048576
id_curent: .space 4
stop_delete: .long -1
stop_defragmentation: .long -1
lim_maxim: .long 0
last_ecx: .long 0


.text

ADD:
    
    push %ebp           #pun stackframe
    movl %esp, %ebp     
    pusha

    pushl $nr_fisiere
    pushl $formatInput
    call scanf
    addl $8, %esp

    
    movl $1, %ebx

    et_for_citire_id_kb:

       
        pushl $id            #citire descriptor(notat cu id)
        pushl $formatInput
        call scanf
        addl $8, %esp

        pushl $kb            #citire dimensiune(notam cu kb)
        pushl $formatInput
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

            
            xorl %ebx, %ebx
            movl $-1, %edx
            xorl %eax, %eax
            movl $-1, line
           
            movl $0, blocuri

            cmpl n, %esi                        #daca dimensiunea e mai mare de 1024 nu inlocuieste nimic
            jg et_returnare_caz_imposibil_add
 

        et_for_line_add:
            incl line
            cmpl $1024, line
            jge et_testing_add
            movl $-1, column
            xorl %ebx, %ebx


            et_for_column_add:
                incl column
                cmpl $1024, column
                jge et_for_line_add
                xorl %ecx, %ecx

                addl line, %ecx         #calculeaza constant pozitia din matrice cu formula ecx= line*1024+column
                shl $10, %ecx
                addl column, %ecx

                cmpl $0, (%edi, %ecx, 4)
                jne et_move_forward

                #completare cu retinerea pozitiilor de start si stop pentru linie si coloana
                # daca startY+blocuri>1024 sare pe cazul et_returnare_caz_imposibil_add


                movl line, %eax
                movl %eax, startX
                movl %eax, stopX

                xorl %eax, %eax
                            
                incl %ebx
                movl %ebx, blocuri
                cmpl %ebx, %esi
                jne et_for_column_add

                #in cazul in care am gasit un nr de blocuri egale 

                
                movl column, %edx
                subl %ebx, %edx
                incl %edx
                movl %edx, startY

                movl startY, %eax
                addl %ebx, %eax
                decl %eax
                movl %eax, stopY
                cmpl n, %eax
                jg et_for_line_add

                movl startX, %eax
                cmpl stopX, %eax
                jne et_returnare_caz_imposibil_add
                jmp et_testing_add

                

                et_move_forward:
                    
                    xorl %ebx, %ebx
                    movl $0, blocuri
                    movl $-1, startX
                    movl $-1, startY
                    movl $-1, stopX
                    movl $-1, stopY
                    jmp et_for_column_add

        #trebuie sa testam daca gaseste un interval pe care poate adauga descriptorul dat

        et_testing_add:

            cmpl $-1, startY
            je et_returnare_caz_imposibil_add
            jmp et_replace_add

        #incepem inlocuirea

        et_replace_add:

        xorl %ecx, %ecx

        movl startX, %ecx
        shl $10, %ecx
        addl startY, %ecx
        subl $1, %ecx      #calculam pozitia de inceput ecx

        xorl %edx, %edx

        movl stopX, %edx
        shl $10, %edx
        addl stopY, %edx        #calculam pozitia de sfarsit ecx

        xorl %eax, %eax
        et_for_replace_add:

            incl %ecx
            movl id, %eax
            movl %eax, (%edi, %ecx, 4)
            cmpl %ecx, %edx
            jg et_for_replace_add


        et_afisare_add:

            pushl stopY
            pushl stopX
            pushl startY
            pushl startX
            pushl id
            pushl $formatOutput
            call printf
            addl $24, %esp

            pushl $0
            call fflush
            popl %ebx

            jmp et_add_gata

     et_returnare_caz_imposibil_add:
        pushl $0
        pushl $0
        pushl $0
        pushl $0
        pushl id
        pushl $formatOutput
        call printf
        addl $24, %esp

        pushl $0
        call fflush
        popl %ebx
        
    et_add_gata:
        
        popl %ebx

    et_continue_read_add:

        cmpl %ebx, nr_fisiere
        je et_ret_add 
        incl %ebx
        jmp et_for_citire_id_kb

    et_ret_add:

        popa 
        pop %ebp
        ret

GET:

    push %ebp
    movl %esp, %ebp
    pusha

    pushl $id
    pushl $formatInput
    call scanf
    addl $8, %esp

    movl id, %esi

    xorl %ecx, %ecx
    xorl %ebx, %ebx
    movl $-1, %edx
    movl $-1, line
    movl $-1, column

    movl $-1, startX
    movl $-1, startY
    movl $-1, stopX
    movl $-1, stopY

    et_for_line_get:
        incl line
        cmpl $1024, line
        jge et_testing_get
        movl $-1, column

        et_for_column_get:
            incl column
            cmpl $1024, column
            jge et_for_line_get

            xorl %ecx, %ecx

            movl line, %ecx
            shl $10, %ecx
            addl column, %ecx

            cmpl %esi, (%edi, %ecx, 4)
            jne et_for_column_get

            movl line, %eax
            movl %eax, startX
            movl %eax, stopX

            xorl %eax, %eax
            movl column, %eax
            movl %eax, stopY
            movl %eax, %ebx

            cmpl $-1, %edx
            jne et_for_column_get

            movl column, %edx
            movl %edx, startY

            jmp et_for_column_get
    
    et_testing_get:

        cmpl $-1, startY
        je et_returnare_caz_imposibil_get
    
    et_afisare_get:
        pushl stopY
        pushl stopX
        pushl startY
        pushl startX
        pushl $formatOutputGET
        call printf
        addl $20, %esp

        pushl $0
        call fflush
        popl %ebx

        jmp et_ret_get 

    et_returnare_caz_imposibil_get:
        pushl $0
        pushl $0
        pushl $0
        pushl $0
        pushl $formatOutputGET
        call printf
        addl $20, %esp

    et_ret_get:
        popa
        pop %ebp
        ret


DELETE:

    pushl %ebp
    movl %esp, %ebp
    pusha

    push $id
    push $formatInput
    call scanf
    addl $8, %esp

    xorl %ecx, %ecx
    movl $-1, %edx
    movl id, %eax

    movl $-1, line
    movl $-1, column
    movl $0, stopX
    movl $-1, stopY

    et_delete_line_replace:
        incl line
        cmpl $1024, line
        jge et_delete

        movl $-1, column

        et_delete_column_replace:
            incl column
            cmpl $1024, column
            je et_delete_line_replace

            xorl %ecx, %ecx
            movl line, %ecx
            shl $10, %ecx
            addl column, %ecx

            cmpl %eax, (%edi, %ecx, 4)
            jne et_delete_column_replace

            movl $0, (%edi, %ecx, 4)

            jmp et_delete_column_replace

    et_delete:

    movl stopX, %eax
    decl %eax
    movl %eax, line
    movl stopY, %eax
    movl %eax, column

    et_for_delete_line:
        incl line
        cmpl $1024, line
        jge et_ret_delete

        et_for_delete_column:
            incl column
            cmpl $1024, column
            jl et_continue
                movl $-1,column
                jmp et_for_delete_line

            et_continue:
            xorl %ecx, %ecx
            movl line, %ecx
            shl $10, %ecx
            addl column, %ecx

            cmpl $0, (%edi, %ecx, 4)
            je et_for_delete_column

            et_delete_exists:
                movl (%edi, %ecx, 4), %ebx
                movl %ebx, id_curent
                movl line, %eax
                movl %eax, startX
                movl %eax, stopX
                movl column, %eax
                movl %eax, startY

            et_parcurgere_delete_column:
                incl column

                cmpl $1025,column
                je et_ret_delete

                xorl %ecx, %ecx
                movl line, %ecx
                shl $10, %ecx
                addl column, %ecx

                cmpl %ebx, (%edi, %ecx,4)
                je et_increment_stop

                    et_afisare_delete:
                        pushl stopY
                        pushl stopX
                        pushl startY
                        pushl startX
                        pushl id_curent
                        pushl $formatOutput
                        call printf
                        addl $24, %esp

                        pushl $0
                        call fflush
                        popl %ebx

                        jmp et_delete
                et_increment_stop:
                    movl column, %edx
                    movl %edx, stopY
                    jmp et_parcurgere_delete_column
        
        jmp et_for_delete_column

    et_ret_delete:
        popa
        popl %ebp
        ret

DEFRAGMENTATION:

    push %ebp
    movl %esp, %ebp
    pusha

    xorl %ecx, %ecx
    xorl %ebx, %ebx
    xorl %edx, %edx
    movl $-1, stopY
    movl $0, stopX
    movl $0, last_ecx
    movl $0, lim_maxim
    
    et_fill_vector_zero:
        cmpl len ,%ebx
        jge et_vector_ecx

        movl $0, (%esi, %ebx,4)
        incl %ebx
        jmp et_fill_vector_zero
    
    et_vector_ecx:
        xorl %ecx, %ecx
        xorl %ebx, %ebx
    et_vector_defrag:
        cmpl len, %ecx
        jge et_zero_matrix

        cmpl $0, (%edi, %ecx, 4)
        je et_continue_matrix

        movl (%edi, %ecx,4), %eax
        movl %eax, (%esi, %ebx,4)
        incl %ebx
        incl %ecx
        jmp et_vector_defrag

        et_continue_matrix:
        incl %ecx
        jmp et_vector_defrag
    
    et_zero_matrix:
        movl $-1, %ecx
        movl $0, %ebx
        et_for_zero_matrix:
            incl %ecx
            cmpl len, %ecx
            jge et_test_defrag
            movl $0, (%edi, %ecx,4)
            jmp et_for_zero_matrix


    et_test_defrag:
        movl last_ecx, %ecx
        movl $1, blocuri
        movl lim_maxim, %ebx

        et_test_for_defrag:
            cmpl $1000000, %ebx
            jge et_defragmentation
            movl (%esi, %ebx, 4), %eax
            incl %ebx                       # trece la pozitia urmatoare din vector
            cmpl %eax, (%esi, %ebx, 4)      #compara 2 elemente consecutive in vector
            je et_continue_counting

            

            movl %ecx, %eax
            shrl $10, %eax          #retin linia pe care sunt in eax
            shl $10, %eax           #retin line*1024
            addl $1024, %eax        #calculez limita superioara a liniei
            movl %eax, line

    
            cmpl line, %ebx
            jg et_increment_ecx

            movl %ebx, lim_maxim
            subl blocuri, %ebx
            decl %ebx
            for_replace_defragmentation:
                incl %ebx
                cmpl lim_maxim, %ebx
                jge et_test_defrag
                movl (%esi, %ebx, 4), %edx
                movl %edx, (%edi, %ecx, 4)
                incl %ecx
                movl %ecx, last_ecx
                jmp for_replace_defragmentation

            et_increment_ecx:
                xorl %edx, %edx
                movl %ecx, %eax
                divl n
                cmpl $0, %edx
                je for_replace_defragmentation
                incl %ecx
                movl %ecx, last_ecx
                jmp et_increment_ecx

            et_continue_counting:
                incl blocuri
                jmp et_test_for_defrag


    et_defragmentation:

    movl stopX, %eax
    decl %eax
    movl %eax, line
    movl stopY, %eax
    movl %eax, column

    et_for_defragmentation_line:
        incl line
        cmpl $1024, line
        jge et_ret_defragmentation

        et_for_defragmentation_column:
            incl column
            cmpl $1024, column
            jl et_continue_defragmentation
                movl $-1,column
                jmp et_for_defragmentation_line

            et_continue_defragmentation:
            xorl %ecx, %ecx
            movl line, %ecx
            shl $10, %ecx
            addl column, %ecx

            cmpl $0, (%edi, %ecx, 4)
            je et_for_defragmentation_column

            et_defragmentation_exists:
                movl (%edi, %ecx, 4), %ebx
                movl %ebx, id_curent
                movl line, %eax
                movl %eax, startX
                movl %eax, stopX
                movl column, %eax
                movl %eax, startY

            et_parcurgere_defragmentation_column:
                incl column

                cmpl $1025,column
                je et_ret_delete

                xorl %ecx, %ecx
                movl line, %ecx
                shl $10, %ecx
                addl column, %ecx

                cmpl %ebx, (%edi, %ecx,4)
                je et_increment_stop_defrag

                    et_afisare_defragmentation:
                        pushl stopY
                        pushl stopX
                        pushl startY
                        pushl startX
                        pushl id_curent
                        pushl $formatOutput
                        call printf
                        addl $24, %esp

                        pushl $0
                        call fflush
                        popl %ebx

                        jmp et_defragmentation
                et_increment_stop_defrag:
                    movl column, %edx
                    movl %edx, stopY
                    jmp et_parcurgere_defragmentation_column
        
        jmp et_for_defragmentation_column

    et_ret_defragmentation:
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

lea matrix, %edi
lea v, %esi
xorl %ecx, %ecx



et_read:

    cmpl nr_operatii, %ebx
    je et_exit
    incl %ebx

    push $id_operatie
    push $formatInput
    call scanf
    addl $8, %esp

    movl id_operatie, %eax

    cmpl $1, %eax
    je et_call_add

    cmpl $2, %eax
    je et_call_get

    cmpl $3, %eax
    je et_call_delete

    cmpl $4, %eax
    je et_call_defragmentation

    jmp et_read

    et_call_add:

        call ADD
        jmp et_read
    
    et_call_get:

        call GET
        jmp et_read

    et_call_delete:
        
        call DELETE
        jmp et_read
    
    et_call_defragmentation:

        call DEFRAGMENTATION
        jmp et_read


et_exit:

    movl $1, %eax
    movl $0, %ebx
    int $0x80