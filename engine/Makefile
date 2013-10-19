export LIBNAME=libvedis.a
export SDK=7.0
export SDKNAME=iphoneos$(SDK)

DIR=build-ios-fat
DIRv7=build-ios-armv7
DIRv7s=build-ios-armv7s
DIR64=build-ios-arm64
DIRi386=build-ios-i386
DIRx86_64=build-ios-x86_64

LIPO=$(shell xcrun -sdk $(SDKNAME) -find lipo)

all: lib

lib: $(DIR)/$(LIBNAME)

$(DIR)/$(LIBNAME): $(DIRv7)/$(LIBNAME) $(DIRv7s)/$(LIBNAME) $(DIR64)/$(LIBNAME) $(DIRi386)/$(LIBNAME) $(DIRx86_64)/$(LIBNAME)
	install -d $(DIR)
	rm -f $@
	$(LIPO) -output $@ -create $^

clean: clean-armv7 clean-armv7s clean-arm64 clean-i386 clean-x86_64
	rm -rf $(DIR)

# -------------------------------------------------
# armv7
# -------------------------------------------------
.PHONY: $(DIRv7)/$(LIBNAME)
$(DIRv7)/$(LIBNAME):
	$(MAKE) -f ios.mk ARCH=armv7 DIR=$(DIRv7) SDKNAME=iphoneos$(SDK)

lib-armv7: $(DIRv7)/$(LIBNAME)

clean-armv7:
	$(MAKE) -f ios.mk clean ARCH=armv7 DIR=$(DIRv7)

# -------------------------------------------------
# armv7s
# -------------------------------------------------
.PHONY: $(DIRv7s)/$(LIBNAME)
$(DIRv7s)/$(LIBNAME):
	$(MAKE) -f ios.mk ARCH=armv7s DIR=$(DIRv7s) SDKNAME=iphoneos$(SDK)

lib-armv7s: $(DIRv7s)/$(LIBNAME)

clean-armv7s:
	$(MAKE) -f ios.mk clean ARCH=armv7s DIR=$(DIRv7s)

# -------------------------------------------------
# arm64
# -------------------------------------------------
.PHONY: $(DIR64)/$(LIBNAME)
$(DIR64)/$(LIBNAME):
	$(MAKE) -f ios.mk ARCH=arm64 DIR=$(DIR64) SDKNAME=iphoneos$(SDK)

lib-arm64: $(DIR64)/$(LIBNAME)

clean-arm64:
	$(MAKE) -f ios.mk clean ARCH=arm64 DIR=$(DIR64)

# -------------------------------------------------
# i386
# -------------------------------------------------
.PHONY: $(DIRi386)/$(LIBNAME)
$(DIRi386)/$(LIBNAME):
	$(MAKE) -f ios.mk ARCH=i386 DIR=$(DIRi386) SDKNAME=iphonesimulator$(SDK)

lib-i386: $(DIRi386)/$(LIBNAME)

clean-i386:
	$(MAKE) -f ios.mk clean ARCH=i386 DIR=$(DIRi386)

# -------------------------------------------------
# x86_64
# -------------------------------------------------
.PHONY: $(DIRx86_64)/$(LIBNAME)
$(DIRx86_64)/$(LIBNAME):
	$(MAKE) -f ios.mk ARCH=x86_64 DIR=$(DIRx86_64) SDKNAME=iphonesimulator$(SDK)

lib-x86_64: $(DIRx86_64)/$(LIBNAME)

clean-x86_64:
	$(MAKE) -f ios.mk clean ARCH=x86_64 DIR=$(DIRx86_64)
