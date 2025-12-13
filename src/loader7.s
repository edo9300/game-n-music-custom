.cpu    arm7tdmi
.align 4
.syntax  unified
.arm

entrypoint:
	adrl r0, arm7_payload_start
	adrl r1, arm7_payload_end
	ldr r2, =#0x037F8000
	movs r4, r2
copy:
1:
	ldr r3, [r0], # 4
	str r3, [r2], # 4
	cmp r0, r1
	blt 1b
	bx r4
.pool

.balign 4, 0xff
arm7_payload_start:
.incbin "arm7.bin"
arm7_payload_end:
