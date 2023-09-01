
THEOS_DEVICE_IP = 192.168.1.36
THEOS_DEVICE_PORT=22

ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

TARGET = iphone:clang:latest:latest
CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ModMenu



ModMenu_FRAMEWORKS =  UIKit Foundation Security QuartzCore CoreGraphics CoreText  AVFoundation Accelerate GLKit SystemConfiguration GameController


ModMenu_CFLAGS = -fobjc-arc -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function 
ModMenu_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG -Wall -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-unused-function 

ModMenu_FILES = UserMenu.mm Menu.mm MenuLoad/ImGuiDrawView.xm  $(wildcard MenuLoad/*.mm)  $(wildcard MenuLoad/*.m) $(wildcard KittyMemory/*.cpp) $(wildcard KittyMemory/*.mm) $(wildcard img/*.m)



#LQMNemOS_LIBRARIES += substrate
# GO_EASY_ON_ME = 1

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/aggregate.mk
after-install::
   install.exec "killall -9 kgvn || :"


