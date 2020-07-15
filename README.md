# DocumentDetector - Flutter Plugin

## Configurations

### Flutter environment

#### Prerequisites

- Flutter minimum version: 1.12
- Old project (before version 1.12) migrated to API 2.0 (Android) - [Check the instructions here](https://flutter.dev/docs/development/packages-and-plugins/plugin-api-migration)

### Android environment

#### Prerequisites

| Setting            | Version |
|--------------------|---------|
| `minSdkVersion`    | 21      |
| `targetSdkVersion` | 29      |
| `Java version`     | 8       |

* Internet connection
* A valid [combateafraude](https://combateafraude.com) Mobile token. To get one, please mail to [Frederico Gassen](mailto:frederico.gassen@combateafraude.com)
* A physical device (how to scan a real document with a simulator?)

Add this configuration in your app-level `build.gradle`:

``` java
android {

    ...

    dataBinding.enabled = true

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}
```

Our SDKs uses [Data Binding](https://developer.android.com/topic/libraries/data-binding). To use it, you need to enable it in your app.
The `compileOptions` is necessary because the libraries use lambda functions, only introduced in Java 8.
For `DocumentDetector` you need to add this other configuration too:

``` java
android {

    ...

    aaptOptions {
        noCompress "tflite"
    }
}
```
This says to builder to not compress the .tflite files. If you don't set this you will have a crash in the builder of ImageClassifier.

#### Required permissions ✏️ 

When working on Android API 23+, you'll have to request the runtime permissions for our SDKs. Use the [permission_handler](https://pub.dev/packages/permission_handler) plugin to request the SDK specific runtime permissions.

#### Proguard/R8 rules

You need to add this rules in your Proguard/R8 file. If not exits, it's necessary create:

```java
# OkHttp safe warning
-dontwarn okhttp3.internal.platform.ConscryptPlatform
-dontwarn org.conscrypt.ConscryptHostnameVerifier
-dontwarn androidx.paging.PositionalDataSource

# Keep the classes that are deserialized by GSON
-keep class com.combateafraude.helpers.server.model.** { <fields>; }

# Keep - Library. Keep all public and protected classes, fields, and methods.
-keep public class * {
    public protected <fields>;
    public protected <methods>;
}

# Keep all enums. Removing this causes a crash in the Document enum
-keepclassmembers enum * {
    <fields>;
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep native methos. Removing this causes a crash
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

# Retrofit does reflection on generic parameters. InnerClasses is required to use Signature and
# EnclosingMethod is required to use InnerClasses. Exceptions is to keep the throws sentences
-keepattributes Signature, InnerClasses, EnclosingMethod, Exceptions, MethodParameters

# Retrofit does reflection on method and parameter annotations.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations

# Retain service method parameters when optimizing.
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# Ignore annotation used for build tooling.
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Ignore JSR 305 annotations for embedding nullability information.
-dontwarn javax.annotation.**

# Guarded by a NoClassDefFoundError try/catch and only used when on the classpath.
-dontwarn kotlin.Unit

# Top-level functions that can only be used by Kotlin.
-dontwarn retrofit2.KotlinExtensions

# With R8 full mode, it sees no subtypes of Retrofit interfaces since they are created with a Proxy
# and replaces all potential values with null. Explicitly keeping the interfaces prevents this.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>
```

### iOS environment

#### Prerequisites
- Xcode minimum version:  11.4 (Swift 5.2)

| Deployment Info |  iOS Version |
|-----------------|--------------|
| `Target`        | iOS 12.0 +   |

* Internet connection
* A valid [combateafraude](https://combateafraude.com) Mobile token. To get one, please mail to [Frederico Gassen](mailto:frederico.gassen@combateafraude.com)
* A physical device (how to scan a real document with a simulator?)

#### Podfile

In `/ios` directory of your project, add the following to the end of `Podfile`(before any post_install logic):

```swift
source 'https://github.com/combateafraude/iOS.git'
source 'https://cdn.cocoapods.org/'
```

## Instalation
Add this to your `pubspec.yaml`:

```yml
dependencies:  
  name: document_detector_sdk:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: document-detector-v.1.0.0
```

## Usage

**BREAKING CHANGES**  
Warning: Changes on document-detector-v.0.13.0 to document-detector-v.1.0.0
- Changed: constructor of DocumentDetector
    - removed parameters: documentType and uploadImages
    -  add parameters: flow

```dart
  DocumentDetector documentDetector =
      DocumentDetector.builder(
          mobileToken: mobileToken,
          flow: DocumentDetector.RG_FLOW or DocumentDetector.CNH_FLOW or
          [DocumentDetectorStep(document: DocumentType.CNH_FRONT)] or
          [any custom flow with DocumentDetectorStep]
          );

  final DocumentDetectorResult = await documentDetector.build();
```

You can capture only the front or back of a document using:
```dart
 flow: [DocumentDetectorStep(document: DocumentType.CNH_FRONT)]
```
or
```dart
 flow: [DocumentDetectorStep(document: DocumentType.CNH_BACK)]
```

### Optional parameters
* `setAndroidMask(String drawableGreenName, String drawableWhiteName, String drawableRedName)` - replace the default SDK's masks in Android. Enter the name of the drawable to be used
* `setAndroidLayout(String layoutName)` - replace the SDK layout in Android with yours with the respectively [template](https://gist.github.com/kikogassen/62068b6e5bc7988d28594d833b125519)
* `setAndroidStyle(String styleName)` -  set the SDK color style in Android. [Template](https://github.com/combateafraude/Mobile/wiki/Common#styles)
* `setAndroidSensorSettings(String luminosityMessageName, String orientationMessageName, String stabilityMessageName)` - replace the default SDK's sensor messages. Enter the name value in string.xml
* 
* `setIOSColorTheme(Color color)` - set the SDK color style for iOS.
* `setIOSShowStepLabel(bool show)` - Show/hides the step label in iOS.
* `setIOSShowStatusLabel(bool show)` - Show/hides the status label.
* `setIOSSLayout(DocumentDetectorLayout layout)` - Sets some layout options to customize the screen on iOS.
* `setIOSSensorSettings(String luminosityMessage, String orientationMessage, String stabilityMessage)` - replace the default SDK's sensor messages. Set label for sensor messages

Example:
```dart
  documentDetector.setIOSSLayout(
    DocumentDetectorLayout(
        closeImageName: "close",
        soundOnImageName: "sound_on",
        soundOffImageName: "sound_off",
        greenMaskImageName: "green_mask",
        redMaskImageName: "red_mask",
        whiteMaskImageName: "white_mask"),
  );
```
- Note: Necessary add images in Assets Catalog Document on Xcode project

* `hasSound(bool hasSound)` - enable/disable the SDK sound
* `setRequestTimeout(int requestTimeout)` - set the server calls request timeout
* `uploadImages(bool upload, int imageQuality)` - Enable the uploads of the document images, returning its URLs in DocumentDetectorResult.Capture.ImageUrl
* `showPopup(bool show)` - Shows/hides the document popup that helps the client


### DocumentDetectorStep

The DocumentDetectorStep constructor has the following structure:

```dart
DocumentDetectorStep(
      {@required this.document,
      this.androidStepLabelName,
      this.iosStepLabel,
      this.androidIllustrationName,
      this.iosIllustrationName,
      this.androidAudioName,
      this.iosAudioName,
      this.androidNotFoundMsgName,
      this.iosNotFoundMessage});
```

| **Parameter**           |  **Required** | **Description** |
|-------------------------|---------------|-----------------|
| document:DocumentType   | Yes           | Sets which document will be scanned in the correspondent step |
| androidStepLabelName    | No            | Sets name String on string.xml that will be shown in the bottom of screen on Android |
| iosStepLabel            | No            | Sets the String label that will be shown in the bottom of screen on iOS |
| androidIllustrationName | No            | Sets the illustration name in drawable folder that will be shown in the popup on Android |
| iosIllustrationName     | No            | Sets the UIImage name that will be shown in the popup on iOS |
| androidAudioName        | No            | Sets the file name in raw folder that will be played in the start of step on Android |
| iosAudioName            | No            | Sets the file name that will be played in the start of step on iOS |
| androidNotFoundMsgName  | No            | Sets name String on string.xml that will be shown when the user aim the camera to anything except any document on Android |
| iosNotFoundMessage      | No            | Sets the String label that will be shown when the user aim the camera to anything except any document on iOS |


### SDK Result
The `DocumentDetectorResult` class, which extends `SDKResult`, has array of document captures. It will be the same length of flow passed by parameter flow. RG_FLOW = 2, CNH_FLOW = 2.
It will be the same length of flow passed by parameter flow.

Example:
- DocumentDetector.CNH_FLOW = 2
- DocumentDetector.RG_FLOW = 2.
- [DocumentDetectorStep(document: DocumentType.CNH_FRONT)] = 1

```dart

class DocumentDetectorResult extends SDKResult {
  final String type; // The scanned document type ("rg", "rg_new", "cnh", "rne") that needs to be send on OCR route
  final List<Capture> capture; //The array of document captures. It will be the same length of flow passed by parameter flow. RG_FLOW = 2, CNH_FLOW = 2
  final Capture captureFront; //Valid only RG_FLOW or CNH_FLOW
  final Capture captureBack;  //Valid only RG_FLOW or CNH_FLOW
  final SDKFailure sdkFailure;
}
```

```dart
class Capture {
  String imagePath;
  String imageUrl;
  int missedAttemps;
  String scannedLabel;
}
```

`DocumentDetectorResult` class returns a `SDKFailure` object.

This object will be null in the success case or one of the following classes in an error case:

* InvalidTokenReason: when the mobileToken passed by parameter is invalid
* PermissionReason: when the SDK starts without the required runtime permissions;
* NetworkReason: when any SDK request cannot be completed, like by a timeout or no internet connection error;
* ServerReason: when any SDK request receives HTTP status code different from 200..299;
* StorageReason: when the SDK cannot save a file in the device internal storage.
* LibraryReason: when a SDK internal library cannot start.

## Specific documentation:

### [Android](https://github.com/combateafraude/Android/wiki)
### [iOS](https://github.com/combateafraude/iOS/wiki)
