THEOS_PACKAGE_DIR_NAME = debs
TARGET = :clang
ARCHS = armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = CalmCall
CalmCall_FILES = CalmCall.xm
CalmCall_FRAMEWORKS = UIKit CoreGraphics CoreImage

include $(THEOS_MAKE_PATH)/tweak.mk

internal-after-install::
	install.exec "killall -9 backboardd"
