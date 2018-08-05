PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Callor
Callor_FILES = Tweak.xm
Callor_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += callor
include $(THEOS_MAKE_PATH)/aggregate.mk
