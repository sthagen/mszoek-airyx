.include <internal/framework.common.mk>

FRAMEWORK=QtKit
SRCS= \
      QKApplication.mm QKView.mm

INCS= \
      QKApplication.h QKView.h

RESOURCES=
QT_CFLAGS!= pkg-config --cflags Qt5Widgets
QT_LDFLAGS!= pkg-config --libs Qt5Widgets
#DBUS_LDFLAGS+=-Wl,-R\$$ORIGIN/./
CFLAGS+= -g ${FMWK_CFLAGS} -I/usr/local/include -I. -fblocks -framework Foundation
CXXFLAGS+= ${QT_CFLAGS}
LDFLAGS+= -g ${FMWK_LDFLAGS} -L/usr/local/lib ${QT_LDFLAGS} \
	  -Wl,-R/System/Library/Frameworks/Foundation.framework/Versions/A \
	  -Wl,-R/System/Library/Frameworks/CoreFoundation.framework/Versions/A \
	  -L${BUILDROOT}/System/Library/Frameworks/Foundation.framework/Versions/Current \
	  -L${BUILDROOT}/System/Library/Frameworks/CoreFoundation.framework/Versions/Current \
	  -lFoundation -lCoreFoundation -lobjc -lX11 -lm

.include <he.framework.mk>
