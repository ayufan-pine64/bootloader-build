.PHONY: sopine-spiflash-write
sopine-spiflash-write: \
	tmp/u-boot-sopine_baseboard/spl/sunxi-spl.bin \
	tmp/u-boot-sopine_baseboard/u-boot.itb \
	sunxi-tools/sunxi-fel
	sunxi-tools/sunxi-fel spiflash-write 0 $(word 1,$^)
	sunxi-tools/sunxi-fel spiflash-write 32768 $(word 2,$^)

.PHONY: sopine-spiflash-clear
sopine-spiflash-clear: sunxi-tools/sunxi-fel
	dd if=/dev/zero of=tmp/clear.img count=16
	sunxi-tools/sunxi-fel spiflash-write 0 tmp/clear.img

.PHONY: sopine-fel
sopine-fel: \
	tmp/u-boot-spl32/spl/sunxi-spl.bin \
	tmp/u-boot-sopine_baseboard/u-boot.bin \
	sunxi-tools/sunxi-fel
	sunxi-tools/sunxi-fel -v -p spl $(word 1,$^) \
		write 0x44000 $(ATF) \
		write 0x4a000000 $(word 2,$^) \
		reset64 0x44000

