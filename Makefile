UBOOT_CONFIG := sopine_baseboard
ATF ?= arm-trusted-firmware/build/sun50iw1p1/debug/bl31.bin

all: image-bootloaders

include Makefile.linaro.mk
include Makefile.atf.mk
include Makefile.uboot.mk
include Makefile.tools.mk
include Makefile.sopine.mk

bootloaders:
	mkdir -p $@

bootloaders/pine64_plus-uboot.bin: tmp/u-boot-pine64_plus/u-boot-with-spl.bin bootloaders
	cp $< $@

bootloaders/sopine_baseboard-uboot.bin: tmp/u-boot-sopine_baseboard/u-boot-with-spl.bin bootloaders
	cp $< $@

.PHONY: image-bootloaders
image-bootloaders: \
	bootloaders/pine64_plus-uboot.bin \
	bootloaders/sopine_baseboard-uboot.bin
