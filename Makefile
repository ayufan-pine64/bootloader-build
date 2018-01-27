UBOOT_CONFIG := sopine_baseboard
ATF ?= arm-trusted-firmware/build/sun50iw1p1/debug/bl31.bin

all: image-bootloaders

include Makefile.linaro.mk
include Makefile.atf.mk
include Makefile.uboot.mk
include Makefile.tools.mk
include Makefile.sopine.mk
include Makefile.blobs.mk

bootloaders:
	mkdir -p $@

bootloaders/pine64_plus-uboot.bin: tmp/u-boot-pine64_plus/u-boot-with-spl.bin bootloaders
	cp $< $@

bootloaders/sopine_baseboard-uboot.bin: tmp/u-boot-sopine_baseboard/u-boot-with-spl.bin bootloaders
	cp $< $@

.PHONY: image-bootloaders
image-bootloaders: \
	bootloaders/pine64_plus-uboot.bin \
	bootloaders/sopine_baseboard-uboot.bin \
	u-boot-sopine-flash-spi.img.xz \
	u-boot-sopine-erase-spi.img.xz \
	u-boot-pine64_plus-boot.img.xz \
	u-boot-sopine_baseboard-boot.img.xz

.PHONY: versions
versions:
	@echo "u-boot: $$(git -C u-boot describe --always)"
	@echo "arm-trusted-firmware: $$(git -C arm-trusted-firmware describe --always)"
	@echo "sunxi-tools: $$(git -C sunxi-tools describe --always)"
