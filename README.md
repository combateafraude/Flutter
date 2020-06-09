# Flutter DocumentDetector Plugin

Combate à Fraude DocumentDetector SDK in the Flutter version.

Supports both Android and iOS.
* Android - DocumentDetector SDK Version  >= 1.0.0-beta9
* iOS - DocumentDetector SDK Version >= 1.0.0

## Getting Started
* Get a valid Combate a Fraude Mobile token. Please, send mail to [Frederico Gassen](mailto:frederico.gassen@combateafraude.com)
* A physical device (how to scan a real document with a simulator?)

## Instalation
To install, either add to your pubspec.yaml

```yml
dependencies:  
  name: document_detector_sdk:
    git:
      url: https://github.com/combateafraude/ActiveFaceLivenessFlutter.git
      ref: v.0.2.0       
```

## Configure Platform Project
### Android

#### Prerequisites
| Setting           |  Version  |
| ----------------- | --------- |
|  minSdkVersion    |  21       |
|  targetSdkVersion |  29       |
|  Java version     |  8        |

#### Project configuration
Our SDKs uses Data Binding. To use it, you need to enable it in your app.  
The ```compileOptions``` is necessary because the libraries use lambda functions, only introduced in Java 8.

Add this configuration in your app-level build.gradle:

```java
android {

    ...

    dataBinding.enabled = true

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    aaptOptions {
        noCompress "tflite"
    }
    
}
```

#### Required permissions
When working with our libraries and Android API 23+, you'll have to request the runtime permissions for our SDKs.

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

Use plugin [permission_handler](https://pub.dev/packages/permission_handler) for request runtime permissions.

#### Update AndroidManifest.xml
Add ```DocumentDetectorActivity``` into your ```AndroidManifest.xml```

```xml
        <activity
            android:name="com.combateafraude.documentdetector.DocumentDetectorActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>

```

### iOS

#### Prerequisites
| Deployment Info   | iOS Version  |
| ----------------- | ------------ |
|  Target           | iOS 12.0 +   |

#### Configure dependencies in Podfile
In the ```/ios``` directory of your project, open the ```Podfile``` and add the following to the bottom (just above any post_install logic):

```swift
source 'https://github.com/combateafraude/Mobile.git'
source 'https://cdn.cocoapods.org/'
```

#### Required permissions
In the ```info.plist``` file add the permissions below

```swift
Privacy - Camera Usage Description
```

## How to use

### Required parameters
```dart
  DocumentDetector documentDetector =
      DocumentDetector.builder(
          mobileToken: mobileToken,
          documentType: DocumentType.CNH or DocumentType.RG);

  final DocumentDetectorResult = await documentDetector.build();

```
### Opcional parameters

#### Layout parameters

```setAndroidMask(String drawableGreenName, String drawableWhiteName, String drawableRedName)``` -  set the SDK background masks.

```setAndroidLayout(String layoutName)``` - replace the SDK layout in Android with yours with the respectively [template](https://gist.github.com/kikogassen/62068b6e5bc7988d28594d833b125519)

```setIOSColorTheme(Color color)``` - set the SDK color style for iOS

#### Style parameters
```hasSound(bool hasSound)``` - enable/disable the SDK sound

```setAndroidStyle(String styleName)``` -  set the SDK color style in Android. [Template](https://github.com/combateafraude/Mobile/wiki/Common#styles)

#### Common parameters
```setRequestTimeout(int requestTimeout)``` - set the server calls request timeout

### SDK Result
The DocumentDetectorResult class, which extends ```SDKResult```, has the a Capture for documentFront and other for documentBack, where each Capture has the full image path of the document, the float confidence value of the detected image for the image detector and the missedAttemps count, which is increased for each wrong document, beyond ```SDKFailure``` for the operation.

For example, if you start with the CNH DocumentCaptureType, the DocumentDetectorResult object will contains the the front CNH imagePath and the confidence for that capture, the back CNH imagePath and confidence and the CNH DocumentDetectorType.

```dart

clss DocumentDetectorResult extends SDKResult {
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

DocumentDetectorResult class returns a SDKFailure object.

This object will be null in the success case or one of the following classes in an error case:

* InvalidTokenReason: when the mobileToken passed by parameter is invalid
* PermissionReason: when the SDK starts without the required runtime permissions;
* NetworkReason: when any SDK request cannot be completed, like by a timeout or no internet connection error;
* ServerReason: when any SDK request receives HTTP status code different from 200..299;
* StorageReason: when the SDK cannot save a file in the device internal storage.
* LibraryReason: when a SDK internal library cannot start.


```dart
class SDKFailure {
  final String message;

  SDKFailure(this.message);

  @override
  String toString() {
    return message;
  }
}

class InvalidTokenReason extends SDKFailure {
  InvalidTokenReason(String message) : super('Token inválido');
}

class PermissionReason extends SDKFailure {
  PermissionReason(String permission)
      : super(
            '$permission é necessária para iniciar o SDK. Por favor, requisite-a ao seu usuário');
}

class NetworkReason extends SDKFailure {
  final String ioExceptionMessage;
  NetworkReason(this.ioExceptionMessage)
      : super('Falha ao conectar-se ao servidor');
}

class ServerReason extends SDKFailure {
  final int code;
  ServerReason(String message, this.code) : super(message);
}

class StorageReason extends SDKFailure {
  final String exceptionMessage;
  StorageReason(this.exceptionMessage)
      : super('Erro no armazenamento do dispositivo');
}

class LibraryReason extends SDKFailure {
  LibraryReason(String libraryMessage) : super(libraryMessage);
}

```

## For production usage
If you use proguard, you should include this line.

```java
# Keep the classes that are deserialized by GSON
-keep class com.combateafraude.demo.report.model.** { <fields>; }
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


# Combate a Fraude Documentation

Read the iOS or Android documentation of Combate a Fraudes for more information:

* [https://github.com/combateafraude/Mobile/wiki/Common#sdkresult](https://github.com/combateafraude/Mobile/wiki/Common#sdkresult)
