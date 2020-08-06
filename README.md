# PassiveFaceLiveness - Flutter Plugin

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
If you want to use `DocumentDetector` you need to add this other configuration too:

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

You need to add this rules in your Proguard/R8 file. If not exits, it's necessary create:

``` pro
# Keep the classes that are deserialized by GSON
-keep class com.combateafraude.helpers.server.model.** { <fields>; }
```

### iOS environment

#### Prerequisites
- Xcode minimum version:  11.4 (Swift 5.2)

| Deployment Info |  iOS Version |
|-----------------|--------------|
| `Target`        | iOS 11.0 +   |

* Internet connection
* A valid [combateafraude](https://combateafraude.com) Mobile token. To get one, please mail to [Frederico Gassen](mailto:frederico.gassen@combateafraude.com)

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
  passive_face_liveness:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: passive-face-liveness-v0.4.1       
```

## Usage

```dart
  PassiveFaceLiveness passiveFaceLiveness =
      PassiveFaceLiveness.builder(mobileToken: mobileToken);
  final passiveFaceLivenessResult =
      await passiveFaceLiveness.build();
```

### Optional parameters

* `setAndroidLayout(String layoutName, String drawableGreenName, String drawableWhiteName, String drawableRedName)` - replace the SDK layout and masks in Android with yours with the respectively [template](https://gist.github.com/kikogassen/62068b6e5bc7988d28594d833b125519)
* `setAndroidStyle(String styleName)` -  set the SDK color style in Android. [Template](https://github.com/combateafraude/Mobile/wiki/Common#styles)

* `setIOSColorTheme(Color color)` - set the SDK color style for iOS.
* `setIOSShowStepLabel(bool show)` - Show/hides the step label in iOS.
* `setIOSShowStatusLabel(bool show)` - Show/hides the status label.
* `setIOSSLayout(PassiveFaceLivenessLayout layout)` - Sets some layout options to customize the screen on iOS.
Example:
```dart
  passiveFaceLiveness.setIOSSLayout(
    PassiveFaceLivenessLayout(
        closeImageName: "close",
        soundOnImageName: "sound_on",
        soundOffImageName: "sound_off",
        greenMaskImageName: "green_mask",
        redMaskImageName: "red_mask",
        whiteMaskImageName: "white_mask"),
  );
```
- Note: Necessary add images in Assets Catalog Document on Xcode project

* `enableSound(bool enableSound)` - enable/disable the SDK sound
* `setRequestTimeout(int requestTimeout)` - set the server calls request timeout

### SDK Result
The `PassiveFaceLivenessResult` class, which extends `SDKResult`, has two parameters: String imagePath and the missedAttemps count. If the SDKFailure == null, the imagePath won't be null. Otherwise, they will.

```dart

class PassiveFaceLivenessResult extends SDKResult {
  final String imagePath;
  final String imageUrl;
  final String signedResponse;
  final double missedAttemps;
  final SDKFailure sdkFailure;
}
```

`PassiveFaceLivenessResult` class returns a `SDKFailure` object.

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
