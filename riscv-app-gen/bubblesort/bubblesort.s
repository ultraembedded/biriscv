
bubblesort.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <bubbleSort>:
80000000:	00100813          	li	a6,1
80000004:	04b85063          	bge	a6,a1,80000044 <bubbleSort+0x44>
80000008:	00259613          	slli	a2,a1,0x2
8000000c:	00c50633          	add	a2,a0,a2
80000010:	00450513          	addi	a0,a0,4
80000014:	00050793          	mv	a5,a0
80000018:	02b85863          	bge	a6,a1,80000048 <bubbleSort+0x48>
8000001c:	ffc7a703          	lw	a4,-4(a5)
80000020:	0007a683          	lw	a3,0(a5)
80000024:	00e6d663          	bge	a3,a4,80000030 <bubbleSort+0x30>
80000028:	fed7ae23          	sw	a3,-4(a5)
8000002c:	00e7a023          	sw	a4,0(a5)
80000030:	00478793          	addi	a5,a5,4
80000034:	fec794e3          	bne	a5,a2,8000001c <bubbleSort+0x1c>
80000038:	fff58593          	addi	a1,a1,-1
8000003c:	ffc60613          	addi	a2,a2,-4
80000040:	fd059ae3          	bne	a1,a6,80000014 <bubbleSort+0x14>
80000044:	00008067          	ret
80000048:	fff58593          	addi	a1,a1,-1
8000004c:	ffc60613          	addi	a2,a2,-4
80000050:	fc5ff06f          	j	80000014 <bubbleSort+0x14>

Disassembly of section .text.startup:

80000054 <main>:
80000054:	800007b7          	lui	a5,0x80000
80000058:	0b878793          	addi	a5,a5,184 # 800000b8 <main+0x64>
8000005c:	0007a303          	lw	t1,0(a5)
80000060:	0047a883          	lw	a7,4(a5)
80000064:	0087a803          	lw	a6,8(a5)
80000068:	00c7a603          	lw	a2,12(a5)
8000006c:	0107a683          	lw	a3,16(a5)
80000070:	0147a703          	lw	a4,20(a5)
80000074:	0187a783          	lw	a5,24(a5)
80000078:	fd010113          	addi	sp,sp,-48
8000007c:	00410513          	addi	a0,sp,4
80000080:	00700593          	li	a1,7
80000084:	02112623          	sw	ra,44(sp)
80000088:	00612223          	sw	t1,4(sp)
8000008c:	01112423          	sw	a7,8(sp)
80000090:	01012623          	sw	a6,12(sp)
80000094:	00c12823          	sw	a2,16(sp)
80000098:	00d12a23          	sw	a3,20(sp)
8000009c:	00e12c23          	sw	a4,24(sp)
800000a0:	00f12e23          	sw	a5,28(sp)
800000a4:	f5dff0ef          	jal	80000000 <bubbleSort>
800000a8:	02c12083          	lw	ra,44(sp)
800000ac:	00000513          	li	a0,0
800000b0:	03010113          	addi	sp,sp,48
800000b4:	00008067          	ret
