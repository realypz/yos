print_string:
	mov ah, 0x0E            ; function number = 0Eh : Display Character

.repeat_next_char:
	lodsb   			 ; get character from string
						 ; Load byte at address DS:(E)SI into AL.
						 ; http://www.jaist.ac.jp/iscenter-new/mpc/altix/altixdata/opt/intel/vtune/doc/users_guide/mergedProjects/analyzer_ec/mergedProjects/reference_olh/mergedProjects/instructions/instruct32_hh/vc161.htm
	cmp al, 0             		 ; cmp al with end of string
	je .done_print		    	 	 ; if char is zero, end of string
	int 0x10                	 ; otherwise, print it.
										 ; call INT 10h, BIOS video service
										 ; https://en.wikipedia.org/wiki/BIOS_interrupt_call
	jmp .repeat_next_char   	 ; jmp to .repeat_next_char if not 0

.done_print:
	ret                 	    ;return
