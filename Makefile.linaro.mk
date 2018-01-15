LINARO_URL ?= https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/aarch64-linux-gnu/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
LINARO ?= $(basename $(basename $(notdir $(LINARO_URL))))
LINARO_CC ?= ccache $(CURDIR)/$(LINARO)/bin/aarch64-linux-gnu-

linaro: $(LINARO)

$(LINARO):
	curl -L $(LINARO_URL) | \
		tar Jx
