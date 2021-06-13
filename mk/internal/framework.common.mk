# Common settings for building frameworks
FMWK_CFLAGS := -O0 -g -DLINUX -DPLATFORM_IS_POSIX -DGCC_RUNTIME_3 \
	 -DPLATFORM_USES_BSD_SOCKETS -I/usr/local/include -I/usr/include/freetype2 \
	 -I/usr/include/fontconfig -I/usr/include/cairo -fPIC
FMWK_LDFLAGS+= -L${BUILDROOT}/usr/lib -L/usr/local/lib -Wl,--no-as-needed

