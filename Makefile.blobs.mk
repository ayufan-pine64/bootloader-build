tmp/u-boot/%/boot.scr: blobs/%.cmd
	mkdir -p $$(dirname $@)
	mkimage -C none -A arm -T script -d $< $@

tmp/u-boot/%/boot.img: tmp/u-boot/%/boot.scr
	dd if=/dev/zero of=$@ bs=1M count=2
	mkfs.vfat -n "u-boot-script" $@
	mcopy -sm -i $@ $< ::

u-boot-sopine-%.img: tmp/u-boot-sopine_baseboard/u-boot-with-spl.bin tmp/u-boot/%/boot.img
	rm -f $@.tmp
	dd if=$(word 2,$^) of=$@.tmp seek=8192 conv=notrunc status=none
	parted -s $@.tmp mklabel msdos
	parted -s $@.tmp unit s mkpart primary fat16 8192 100%
	parted -s $@.tmp set 1 boot on
	dd if=$(word 1,$^) of=$@.tmp seek=16 conv=notrunc status=none
	mv "$@.tmp" $@
