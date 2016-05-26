default:
	nasm -f elf32 -g -F dwarf -l uebung4.lst uebung4.asm && gcc -m32 -g -o uebung4 uebung4.o && rm uebung4.o
