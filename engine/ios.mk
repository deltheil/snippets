# Note:
# - LIBNAME is exported by the parent Makefile
# - ARCH, DIR and SDKNAME are exported as environment variables

# -------------------------------------------------
# Toolchain
# -------------------------------------------------
XCODE_PREFIX=/Applications/Xcode.app/Contents/Developer
ifneq ($(findstring iphoneos,$(SDKNAME)),)
	SDKROOT=$(XCODE_PREFIX)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS$(SDK).sdk
else
	SDKROOT=$(XCODE_PREFIX)/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$(SDK).sdk
endif
CC=$(shell xcrun -sdk $(SDKNAME) -find clang)
AR=$(shell xcrun -sdk $(SDKNAME) -find ar)
RANLIB=$(shell xcrun -sdk $(SDKNAME) -find ranlib)

# -------------------------------------------------
# Compiler flags
# -------------------------------------------------
CFLAGS=-Wall -Werror -pedantic
CFLAGS+=-isysroot $(SDKROOT)
CFLAGS+=-arch $(ARCH)
ifneq ($(findstring iphoneos,$(SDKNAME)),)
	ifeq ($(ARCH),arm64)
		CFLAGS+=-miphoneos-version-min=7.0
	else
		CFLAGS+=-mthumb
		CFLAGS+=-miphoneos-version-min=4.0
	endif
else
	CFLAGS+=-miphoneos-version-min=4.0
endif
CFLAGS+= -Os -DNDEBUG

# -------------------------------------------------
# Main rules
# -------------------------------------------------
all: lib

lib: $(DIR)/$(LIBNAME)

$(DIR)/vedis.o: vedis.c
	install -d $(shell dirname $@)
	$(CC) $(CFLAGS) -c -o $@ $<

$(DIR)/$(LIBNAME): $(DIR)/vedis.o
	install -d $(DIR)
	rm -f $@
	$(AR) cq $@ $(DIR)/vedis.o
	$(RANLIB) $@

clean:
	rm -rf $(DIR)
