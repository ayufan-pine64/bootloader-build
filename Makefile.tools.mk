sunxi-tools:
	git clone https://github.com/apritzel/sunxi-tools

sunxi-tools/sunxi-fel: sunxi-tools
	make -C sunxi-tools

%.img.xz: %.img
	pxz -f -3 $<

clean:
	rm -rf tmp/ bootloaders/
