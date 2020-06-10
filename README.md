# DocumentDetector - Flutter Plugin

## Configurations

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

#### Proguard rules

As the Flutter plugins aren't compiled, you need to add this rules in your Proguard file (if you are using it):

```java
# Keep the classes that are deserialized by GSON
-keep class com.combateafraude.helpers.server.api.** { <fields>; }

# Keep - Library. Keep all public and protected classes, fields, and methods.
-keep public class * {
    public protected <fields>;
    public protected <methods>;
}

# Keep all enums. Removing this causes a crash in the Document enum
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep native methos. Removing this causes a crash
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}
```

Add `DocumentDetectorActivity` into your `AndroidManifest.xml`

```xml
        <activity
            android:name="com.combateafraude.documentdetector.DocumentDetectorActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>

```

### iOS environment

#### Prerequisites

| Deployment Info |  iOS Version |
|-----------------|--------------|
| `Target`        | iOS 12.0 +   |

* Internet connection
* A valid [combateafraude](https://combateafraude.com) Mobile token. To get one, please mail to [Frederico Gassen](mailto:frederico.gassen@combateafraude.com)
* A physical device (how to scan a real document with a simulator?)

#### Podfile

In `/ios` directory of your project, add the following to the end of `Podfile`(before any post_install logic):

```swift
source 'https://github.com/combateafraude/Mobile.git'
source 'https://cdn.cocoapods.org/'
```

## Instalation
Add this to your `pubspec.yaml`:

```yml
dependencies:  
  name: document_detector_sdk:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: document-detector-v.0.4.0
```

## Usage

```dart
  DocumentDetector documentDetector =
      DocumentDetector.builder(
          mobileToken: mobileToken,
          documentType: DocumentType.CNH or DocumentType.RG);

  final DocumentDetectorResult = await documentDetector.build();

```

### Optional parameters

* `setAndroidMask(String drawableGreenName, String drawableWhiteName, String drawableRedName)` - replace the default SDK's masks in Android. Enter the name of the drawable to be used
* `setAndroidLayout(String layoutName)` - replace the SDK layout in Android with yours with the respectively [template](https://gist.github.com/kikogassen/62068b6e5bc7988d28594d833b125519)
* `setIOSColorTheme(Color color)` - set the SDK color style for iOS
* `hasSound(bool hasSound)` - enable/disable the SDK sound
* `setAndroidStyle(String styleName)` -  set the SDK color style in Android. [Template](https://github.com/combateafraude/Mobile/wiki/Common#styles)
* `setRequestTimeout(int requestTimeout)` - set the server calls request timeout

### SDK Result
The `DocumentDetectorResult` class, which extends `SDKResult`, has the a Capture for documentFront and other for documentBack, where each Capture has the full image path of the document, the float confidence value of the detected image for the image detector and the missedAttemps count, which is increased for each wrong document, beyond `SDKFailure` for the operation.

For example, if you start with the CNH DocumentCaptureType, the DocumentDetectorResult object will contains the the front CNH imagePath and the confidence for that capture, the back CNH imagePath and confidence and the CNH DocumentDetectorType.

```dart

class DocumentDetectorResult extends SDKResult {
  final Capture captureFront;
  final Capture captureBack;
  final SDKFailure sdkFailure;
}
```

```dart
class Capture {
  String imagePath;
  int missedAttemps;
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
