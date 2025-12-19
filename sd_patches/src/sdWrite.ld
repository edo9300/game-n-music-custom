OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(sdWrite)
MEMORY {
    target (wx) : ORIGIN = 0x020181cc, LENGTH = 1312
}
SECTIONS
{
    .text 0x020181cc:
    {
        *(.text.sdWrite);
        *(.text*);
    } > target
}