arm-trusted-firmware:
	git clone https://github.com/apritzel/arm-trusted-firmware.git $@

arm-trusted-firmware/build/sun50iw1p1/release/bl31.bin: arm-trusted-firmware
	make -C $< CROSS_COMPILE="$(LINARO_CC)" PLAT=sun50iw1p1 bl31

arm-trusted-firmware/build/sun50iw1p1/debug/bl31.bin: arm-trusted-firmware
	make -C $< CROSS_COMPILE="$(LINARO_CC)" PLAT=sun50iw1p1 DEBUG=1 bl31
