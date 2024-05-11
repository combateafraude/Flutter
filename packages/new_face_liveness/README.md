# [FaceLiveness](https://docs.caf.io/sdks/flutter/getting-started/new-passivefaceliveness)

It brings cutting-edge live facial verification and fingerprint authentication technology into your Flutter applications, offering a seamless and secure way to authenticate users.

## Requirements

| Flutter | Version |
| ------- | ------- |
| Flutter | 1.20+   |
| Dart    | 2.15+   |

| Android    | Version |
| ---------- | ------- |
| minSdk     | 21      |
| compileSdk | 33      |

| iOS        | Version  |
| ---------- | -------- |
| iOS Target | 12.0     |
| Xcode      | 14.3.1+  |
| Swift      | 5.3.2+   |

#### Sending your app to Play Store

To publish your app on the *Google Play Store*, you must complete a data safety form. Since we integrate with the *FingerPrintJS SDK*, you'll need to provide the following information:

| Question in Google Play Console's data safety form | Response |
| -------------------------------------------------- | -------- |
| Does your app collect or share any of the required user data types? | Yes. |
| What type of data is collected? | Device or other identifiers. |
| Is this data collected, shared, or both? | Collected. |
| Is this data processed ephemerally? | Yes. |
| Why is this user data collected? | Fraud Prevention, Security, and Compliance. |

## Runtime permissions

### Android

| Permission | Reason | Required |
| ---------- | ------ | -------- |
| `CAMERA` | Capturing the selfie in policies with facial verification | Yes |

### iOS

| Permission | Reason | Required |
| ---------- | ------ | -------- |
| `Privacy - Camera Usage Description` | Capturing the selfie in live facial verification policies | Yes |

## Platform Configurations

### Android

If your version of Gradle is earlier than 7, add these lines to your `build.gradle`.

```groovy
allprojects {
  repositories {
    ...
    maven { url 'https://repo.combateafraude.com/android/release' }
    maven { url 'https://raw.githubusercontent.com/iProov/android/master/maven/' }
    maven { url 'https://maven.fpregistry.io/releases' }
    maven { url 'https://jitpack.io' }
  }
}
```

If your version of Gradle is 7 or newer, add these lines to your `settings.gradle`.

```groovy
dependencyResolutionManagement {
  repositories {
    ...
    maven { url 'https://repo.combateafraude.com/android/release' }
    maven { url 'https://raw.githubusercontent.com/iProov/android/master/maven/' }
    maven { url 'https://maven.fpregistry.io/releases' }
    maven { url 'https://jitpack.io' }
  }
}
```

Add support for Java 8 to your `build.gradle` file. Skip this if Java 8 is enabled.

```groovy
android {
    ...
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

### iOS

In the `info.plist` file, add the permissions below:

```swift
<key>NSCameraUsageDescription</key>
<string>To capture the selfie</string>
```

## Usage

| Parameter | Required |
| ---------- | -------- |
| `mobileToken`: Usage token associated with your CAF account | Yes |
| `personId`: User identification that registers the user's face for face matching. Currently, this value only accepts the user's CPF. | Yes |

```dart
FaceLiveness faceLiveness =
        FaceLiveness(mobileToken: mobileToken, peopleId: personId);

// Your SDK customization parameters

final stream = faceLiveness.start();

    stream.listen((event) {

      if (event is FaceLivenessEventConnecting) {
        // The SDK is connecting to the server. You should provide an indeterminate progress indicator
        // to let the user know that the connection is taking place.
      } else if (event is FaceLivenessEventConnected) {
        // The SDK has connected, and the iProov user interface will now be displayed. You should hide
        // any progress indication at this point.
      } else if (event is FaceLivenessEventClosed) {
        // The user canceled face verification, either by pressing the close button at the top of the screen, or sending
        // the app to the background.
      } else if (event is FaceLivenessEventSuccess) {
        // The user was successfully verified/enrolled and the token has been validated.
        // You can access the following properties:
        final signedResponse = event.signedResponse;
      } else if (event is FaceLivenessEventFailure) {
        // The user was not successfully verified/enrolled, as their identity could not be verified,
        // or there was another issue with their verification/enrollment (e.g. lost internet connection).
        // You can access the following properties:
        final errorType = event.errorType
        final errorDescription = event.errorDescription
      }
    });
```

### FaceLiveness Options

| Option | Required | Default Value | Android | iOS |
| ------ | -------- | ------- | ------- | --- |
| <p>`.setStage(String stage)`</p><p>Used to redirect the SDK to the desired environment in caf api.</p> | No | `CafStage.prod` | ✅ | ✅ |
| <p>`.setFilter(String filter)`</p><p>Set the camera filter applied to the camera preview.</p> | No | `CameraFilter.lineDrawing` | ✅ | ✅ |
| <p>`.setEnableScreenshots(bool enable)`</p><p>Used to enable screenshots during the SDK scan.</p> | No | `false` | ✅ | ❌ |
| <p>`.setEnableLoadingScreen(bool enable)`</p><p>Used to determines whether the SDK's loading screen will be implemented through client side or if will be used the default screen. If set to 'true,' the loading screen will be a standard SDK screen. If 'false,' You should provide an indeterminate progress indicator.</p> | No | `false` | ✅ | ✅ |
| <p>`.setImageUrlExpirationTime(String time)`</p><p>Use to change the default image URL expiration time to retrieve the facial capture.</p> | No | 30 min | ✅ | ✅ |

### Enums

#### CafStage

| Description | Values |
| ----------- | ------ |
| Used to set the SDK stage on `.setStage(String stage)` option. | `CafStage.prod`, `CafStage.beta` |

#### CameraFilter

| Description | Values |
| ----------- | ------ |
| Used to set the SDK's camera filter on `.setFilter(String filter)` option. | `CameraFilter.natural`, `CameraFilter.lineDrawing` |

#### Time

| Description | Values |
| ----------- | ------ |
| Used to set the image URL expiration time on `.setImageUrlExpirationTime(String time)` option. | `Time.threeHours`, `Time.thirtyDays` |

## FaceLiveness Event Streaming

### FaceLivenessEventConnecting

The SDK is loading, you can use this event return to set an action in your app, for example, a loading indicator.

### FaceLivenessEventConnected

The SDK is not loading anymore, you can use this event return to set a action in your app, for example, you can stop your loading indicator.

### FaceLivenessEventClosed

The execution has been cancelled by the user.

### FaceLivenessEventSuccess

| Event | Description |
| ----- | ----------- |
| `requestId` | Request identifier. |
| `isAlive` | Validation of a living person, identifies whether the user passed successfully or not. |
| `token` | Request token. |
| `userId` | User identifier provided for the request. |
| `imageUrl` | Temporary link to the image, generated by our API. |
| `personId` | User identifier provided for the SDK. |
| `sdkVersion` | Sdk version in use. |
| `iat` | Token expiration. |

> The `isAlive` parameter is **very important**, based on this validation, the user can be guided to continue the flow or not. In case of `isAlive: true`, it  would be able to continue with the journey. If `isAlive: false`, this user is not valid and should be prevented from continuing their journey.

### FaceLivenessEventFailure

| Parameter | Description |
| --------- | ----------- |
| `String errorType` | Error type returned by the SDK |
| `String errorDescription` | Error description message returned by the SDK. |

| Error type cases| Description |
|---|---|
|`unsupportedDevice` | This error may occur if the device hardware or software does not meet the minimum requirements for facial recognition functionality. |
|`cameraPermission`  | This error typically occurs when the user denies access to the camera or if the app lacks the necessary permissions. |
|`networkException`  | This error may occur due to various network issues such as a lack of internet connection, server timeouts, or network congestion. |
|`tokenException`  | This error may occur if the provided authentication token is invalid, expired, or lacks the necessary permissions to perform facial recognition tasks. |
|`serverException` | This error is typically returned when there is an issue with the server processing the facial recognition request. This could include server-side errors, misconfigurations, or service interruptions. |
