OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(sdRead)
MEMORY {
    target (wx) : ORIGIN = 0x020186ec, LENGTH = 1068
}
SECTIONS
{
    .text 0x020186ec:
    {
        *(.text.sdRead);
        *(.text*);
    } > target
}