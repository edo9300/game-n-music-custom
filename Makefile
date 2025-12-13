# SPDX-License-Identifier: CC0-1.0
#
# SPDX-FileContributor: Adrian "asie" Siekierka, 2024

export WONDERFUL_TOOLCHAIN ?= /opt/wonderful
export BLOCKSDS ?= /opt/blocksds/core

# Tools
# -----

OBJCOPY	:= $(WONDERFUL_TOOLCHAIN)/toolchain/gcc-arm-none-eabi/bin/arm-none-eabi-objcopy
AS		:= $(WONDERFUL_TOOLCHAIN)/toolchain/gcc-arm-none-eabi/bin/arm-none-eabi-as
CP		:= cp
MV		:= mv
MAKE	:= make
MKDIR	:= mkdir
DD		:= dd
CAT		:= cat
RM		:= rm -rf

TARGET := GameNMusic2

# Verbose flag
# ------------

ifeq ($(V),1)
_V		:=
else
_V		:= @
endif

# Build rules
# -----------

.PHONY: all clean sd_patches

all: $(TARGET)-enc.nds
	
clean:
	@echo "  CLEAN"
	$(_V)$(RM) build $(TARGET).nds $(TARGET)-enc.nds datel_rom.bin
	$(_V)$(MAKE) -C sd_patches clean

$(TARGET).nds: build/arm9.bin
	@echo "  BUILDING"
	$(_V)$(BLOCKSDS)/tools/ndstool/ndstool -c $@ \
		-7 data/arm7.bin -9 build/arm9.bin \
		-t data/banner.bin -h data/header.bin \
		-r9 0x02100000 -e9 0x02100800

$(TARGET)-enc.nds: $(TARGET).nds
	@echo "  ENCRYPTING"
	$(_V)$(CP) $(TARGET).nds build/$@
	$(_V)$(DD) if=data/secure-area.bin of=build/$@ seek=16 status=none
	$(_V)$(DD) if=$(TARGET).nds of=build/$@ skip=36 seek=36 status=none
	$(_V)$(MV) build/$@ $@
	$(_V)$(BLOCKSDS)/tools/ndstool/ndstool -fh $@
	$(_V)$(CP) $@ datel_rom.bin

build/arm9.bin: sd_patches
	@$(MKDIR) -p build
	$(_V)$(AS) -I src -I sd_patches/build src/loader.s -o build/loader.out
	$(_V)$(OBJCOPY) -O binary build/loader.out build/loader.frm
	$(_V)$(CAT) data/bare-entrypoint.bin build/loader.frm > build/arm9.bin

sd_patches:
	$(_V)$(MAKE) -C sd_patches