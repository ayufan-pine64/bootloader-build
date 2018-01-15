u-boot:
	git clone https://github.com/linux-sunxi/u-boot $@ --single-branch --depth=30

.PHONY: u-boot-menuconfig
u-boot-menuconfig: u-boot
	make -C $< ARCH=arm $(UBOOT_CONFIG)_defconfig KBUILD_OUTPUT=$(CURDIR)/tmp/u-boot-menuconfig
	make -C $< ARCH=arm menuconfig KBUILD_OUTPUT=$(CURDIR)/tmp/u-boot-menuconfig
	make -C $< ARCH=arm savedefconfig KBUILD_OUTPUT=$(CURDIR)/tmp/u-boot-menuconfig
	mv $(CURDIR)/tmp/u-boot-menuconfig/defconfig $</configs/$(UBOOT_CONFIG)_defconfig

u-boot/configs/%_defconfig: u-boot

tmp/u-boot-%/.config: u-boot/configs/%_defconfig
	make -C u-boot ARCH=arm $(shell basename $<) KBUILD_OUTPUT=$(CURDIR)/$(shell dirname $@)

tmp/u-boot-%/spl/sunxi-spl.bin tmp/u-boot-%/u-boot.itb tmp/u-boot-%/u-boot.bin: tmp/u-boot-%/.config \
	$(ATF)
	make -C u-boot ARCH=arm \
		CROSS_COMPILE="$(LINARO_CC)" \
		BL31="$(CURDIR)/$(word 2,$^)" \
		KBUILD_OUTPUT=$(CURDIR)/$(shell dirname $<) \
		-j$$(nproc) \
		u-boot-with-spl.bin spl/sunxi-spl.bin u-boot.itb u-boot.bin

tmp/u-boot-spl32/spl/sunxi-spl.bin:
	make -C u-boot ARCH=arm \
		CROSS_COMPILE="ccache arm-linux-gnueabihf-" \
		KBUILD_OUTPUT=$(CURDIR)/tmp/u-boot-spl32 \
		-j$$(nproc) \
		sun50i_spl32_defconfig
	make -C u-boot ARCH=arm \
		CROSS_COMPILE="ccache arm-linux-gnueabihf-" \
		KBUILD_OUTPUT=$(CURDIR)/tmp/u-boot-spl32 \
		-j$$(nproc) \
		spl/sunxi-spl.bin

tmp/u-boot-%/u-boot-with-spl.bin: tmp/u-boot-%/spl/sunxi-spl.bin \
	tmp/u-boot-%/u-boot.itb
	cat $^ > $@.tmp
	mv $@.tmp $@
