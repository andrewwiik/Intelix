export ADDITIONAL_CFLAGS = -I$(THEOS_PROJECT_DIR)/headers

# ifeq ($(SIMULATOR),1)
# 	export TARGET = simulator:latest:7.0
# else
# 	export TARGET = iphone:latest:7.0
# endif

ARCHS = arm64


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Intelix
Intelix_CFLAGS = -I$(THEOS_PROJECT_DIR)/headers
Intelix_FILES = $(wildcard *.m) $(wildcard *.xm)

include $(THEOS_MAKE_PATH)/tweak.mk

after-all::
	@echo Signing Binary
	@ldid -S $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib
	@echo Copying to Distribution Folder
	@mkdir -p ./Distribution
	@cp ./$(TWEAK_NAME).plist ./Distribution/
	@cp $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib ./Distribution/

after-install::
	install.exec "killall -9 SpringBoard"
