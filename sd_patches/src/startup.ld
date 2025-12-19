OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(startup)
MEMORY {
    target (wx) : ORIGIN = 0x02018b18, LENGTH = 2132
}
SECTIONS
{
    .text 0x02018b18:
    {
        *(.text.startup);
        *(.text*);
    } > target
}