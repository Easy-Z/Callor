include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = callor
callor_FILES = XXXRootListController.m
callor_INSTALL_PATH = /Library/PreferenceBundles
callor_FRAMEWORKS = UIKit
callor_PRIVATE_FRAMEWORKS = Preferences
callor_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/callor.plist$(ECHO_END)
