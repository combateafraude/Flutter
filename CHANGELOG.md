# 4.4.5
- Added: support for ios version 14.5+

# 4.4.1
- Fixed: error in the return treatment

# 4.4.0
__Android Native SDK Update to 6.9.1__
__iOS Native SDK Update to 4.4.2__
- Added: MessageSettings
- Added: support for NullSafety

# 3.0.0
- **Android SDK - 5.1.3**
- **iOS SDK - 2.2.1**

# 2.0.0
__Android Native SDK Update to 4.1.0__
__iOS Native SDK Update to 2.1.0__
*BREAKING CHANGES*
- Removed: method uploadImages
- Added: method verifyQuality
- Changed: DocumentDetectorStep constructor: removed parameters, androidNotFoundMsgName and iosNotFoundMessage

# 1.1.0
__Android Native SDK Update to 2.2.0__
__iOS Native SDK Update to 1.3.1__
- Added: parameters to configure sensor messages

# 1.0.0
__Android Native SDK Update to 2.1.0__

__iOS Native SDK Update to 1.2.0__
- Added: support to other documents in Document Detector, like Registro Nacional de Estrangeiros (RNE), Carteira de Identidade de Advogado (OAB) and Identidade Militar.

*BREAKING CHANGES*
- Changed: constructor of DocumentDetector. Now you can start it with your own flow!
- Changed (Android): possibility to customize what kind of parameters you want in ´DocumentDetectorStep´ object. If you want to change only the stepLabel, pass it by parameter and send null in others.
- Updated: Proguard/R8 rules

# 0.13.0
Bugfix Android Layout methods

# 0.12.0
New release from version 0.11.0

# 0.11.0
Removed parameter `uploadImages` on build():
Added new methods:
- showPopup
- uploadImages

# 0.10.0
Add new methods for layout in iOS:
- setIOSShowStepLabel
- setIOSShowStatusLabel
- setIOSSLayout
Added new parameter opcional on build():
- uploadImages

# 0.9.0
Add field `type` in DocumentDetectorResult

# 0.8.0
Bugfix in DocumentDetector iOS SDK

# 0.7.0
Bugfix in DocumentDetector iOS code

# 0.6.0
Bugfix in DocumentDetector Java code

# 0.5.0
Bugfix in DocumentDetector Java code
Documentation update

# 0.4.0
Bugfix in DocumentDetector Java code

# 0.3.0
Updated DocumentDetector Android SDK version

# 0.2.0
Updated DocumentDetector Android SDK version
Minor fix
Removed methods:
- setMaxDimensionPhoto
- setRedMask
- setWhiteMask
- setGreenMask
Updated method:
- setMask

## 0.1.0
Initial version
