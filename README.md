Simple project to allow creating a game n music binary with a custom arm9 payload.

In the `data/` folder are the binaries taken from a game n' music rom dump and respective
rom metadata.
 - `arm9.bin` is the decompressed arm9 binary present in the original binary.
 - `bare-entrypoint.bin` is the initial loader present in the official binary,
which normally would use datel's decompression function to decompress the arm9,
but it has been patched to jump to whatever function is appended at the end of it.
In our case the target function is a very barebone `loader9.s`, first using the bios to
call the LZSS swi to decompress the arm9 binary that gets compressed during the build step.
Then the sd related functions in ram are replaced with the custom ones, and lastly the
MBR loading code is patched to support drives formatted on modern systems.
 - `arm7.bin` is the arm7 binary present in the original binary.
To fix 3ds compatibility with the generated rom image, a simple `loader7.s` gets loaded to a
supported memory region, and then puts the original arm7 binary to its expected location in ram.

`sd_patches` contains a modified gnm sdhc dldi that is adapted to interface with the internals of the GnM firmware.

## Compiling
A Wonderful toolchain+blocksds setup is required with the following packages installed:
wf-nnpack
blocksds-toolchain

Then run `make` on the root folder, 3 files will be generated:
`GameNMusic2.nds`: Rom containing patched arm7 and arm9 but with no secure area (won't boot if flashed to cart)
`GameNMusic2-enc.nds` and `gnm-backup.bin`: Rom containing the secure area section taken from the original datel dump.