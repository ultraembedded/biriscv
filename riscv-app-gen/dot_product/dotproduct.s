
dotproduct.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <produto_escalar>:
80000000:	00050793          	mv	a5,a0
80000004:	01c50613          	addi	a2,a0,28
80000008:	00000513          	li	a0,0
8000000c:	0007a703          	lw	a4,0(a5)
80000010:	0005a683          	lw	a3,0(a1)
80000014:	00478793          	addi	a5,a5,4
80000018:	00458593          	addi	a1,a1,4
8000001c:	02d70733          	mul	a4,a4,a3
80000020:	00e50533          	add	a0,a0,a4
80000024:	fec794e3          	bne	a5,a2,8000000c <produto_escalar+0xc>
80000028:	00008067          	ret

Disassembly of section .text.startup:

8000002c <main>:
8000002c:	00000513          	li	a0,0
80000030:	00008067          	ret
