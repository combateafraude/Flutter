# [NewFaceAuthenticator](https://docs.caf.io/sdks/android/getting-started/faceauthenticator) - Flutter Plugin

## Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Dart                | 2.12+  |
| Android API         | 21+    |
| iOS                 | 13.0+  |

## Configurações

### Android

No arquivo `ROOT_PROJECT/android/app/build.gradle`, adicione:

```gradle
android {

    ...

    dataBinding.enabled = true

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    rootProject.allprojects {
    repositories {
        maven { url "https://repo.combateafraude.com/android/release" }
        maven { url 'https://raw.githubusercontent.com/iProov/android/master/maven/' }
    }
}
}
```

### iOS

No arquivo `ROOT_PROJECT/ios/Podfile`, adicione no final do arquivo:

```swift
source 'https://github.com/combateafraude/iOS.git'
source 'https://cdn.cocoapods.org/' #
```

Por último, adicione a permissão de câmera no arquivo `ROOT_PROJECT/ios/Runner/Info.plist`:

```swift
<key>NSCameraUsageDescription</key>
<string>To capture the selfie</string>
```

## Utilização

```dart
FaceAuthenticator faceAuthenticator =
        FaceAuthenticator(mobileToken: mobileToken, personId: personId);

// Outros parâmetros de customização

final stream = faceAuthenticator.start();
    stream.listen((event) {
      if (event is FaceAuthenticatorEventConnecting) {
        // The SDK is connecting to the server. You should provide an indeterminate progress indicator
        // to let the user know that the connection is taking place.
      } else if (event is FaceAuthenticatorEventConnected) {
        // The SDK has connected, and the iProov user interface will now be displayed. You should hide
        // any progress indication at this point.
      } else if (event is FaceAuthenticatorEventClosed) {
        // The user canceled face verification, either by pressing the close button at the top of the screen, or sending
        // the app to the background.
      } else if (event is FaceAuthenticatorEventSuccess) {
        // The user was successfully verified/enrolled and the token has been validated.
        // You can access the following properties:
        final signedResponse = event.signedResponse;
      } else if (event is FaceAuthenticatorEventFailure) {
        // The user was not successfully verified/enrolled, as their identity could not be verified,
        // or there was another issue with their verification/enrollment (e.g. lost internet connection).
        // You can access the following properties:
        final errorType = event.errorType
        final errorMessage = event.errorMessage
        final code = event.code
        final signedResponse = event.signedResponse
      }
    });
```

### FaceAuthenticator methods

| Parameter                                                                                                                                                                                          | Required                                         |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| <p><strong>`.setStage(String stage)`</strong></p><p>Used to redirect the SDK to the desired environment in caf api.</p>                                                                 | No                                               |
| <p><strong>`.setFilter(String filter)`</strong></p><p>Used to change the SDK camera filter. It has the following options: **CameraFilter.natural** or **CameraFilter.lineDrawing**</p> | No, the default is **CameraFilter.lineDrawing** |
| <p><strong>`.setEnableScreenshots(bool enable)`</strong></p><p>Used to enable screenshots during the SDK scan.</p>                                                                      | No, the default is **false**                     |
| <p><strong>`.setEnableLoadingScreen(bool enable)`</strong></p><p>Used to determines whether the SDK's loading screen will be implemented through client side or if will be used the default screen. If set to 'true,' the loading screen will be a standard SDK screen. If 'false,' You should provide an indeterminate progress indicator.</p>                                                                      | No, the default is **false**                     |

### Enums

#### CafStage

| Description                                                    | Values                           |
| -------------------------------------------------------------- | -------------------------------- |
| Used to set the SDK stage on `.setStage(String stage)` method. | `CafStage.prod`, `CafStage.beta` |

#### CameraFilter

| Description                         | Values                                              |
| ----------------------------------- | --------------------------------------------------- |
| Used to set the SDK's camera filter | `CameraFilter.natural`, `CameraFilter.lineDrawing` |

### FaceAuthenticatorSuccess

| Field                                                                                                                                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <p>`String signedResponse`</p><p> Signed response from the CAF server confirming that the captured selfie has a real face. This parameter is used to get an extra layer of security, checking that the signature of the response is not broken, or caused by request interception. If it is broken, there is a strong indication of request interception.</p> |

### FaceAuthenticatorFailure

#### iOS

The `FaceAuthenticatorFailure` object return the following parameters.

| Field                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------ |
| <p>`String signedResponse`</p><p> Signed response from the CAF server confirming that the captured selfie has a real face.</p> |
| <p>`String errorType`</p><p> Error type returned by the SDK. Check the table below.</p>                                        |
| <p>`String errorMessage`</p><p>Error message returned by the SDK.</p>                                                          |
| <p>`String code`</p><p>Error code returned by the SDK. Check the table below.</p>                                              |

In case of failure, the `FaceAuthenticatorFailure` object will also return a signedResponse containing information.
Within the signedResponse, the parameter isAlive defines the execution of liveness, where true is approved and false is rejected.

| Code | Error Type                | Description                                                                                                                                                                                      |
| ---- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1    | `unknown`                 | Try aganin                                                                                                                                                                                       |
| 2    | `getToken`                | Error while trying to capture the execution token.                                                                                                                                               |
| 3    | `livenessError`           | Error while attempting to execute liveness due to communication issues.                                                                                                                          |
| 4    | `registerError`           | Error while performing the registration of the liveness execution.                                                                                                                               |
| 5    | `captureAlreadyActive`    | An existing capture is already in progress. Wait until the current capture completes before starting a new one.                                                                                  |
| 6    | `cameraPermissionDenied` | The user disallowed access to the camera when prompted. You should direct the user to re-try.                                                                                                    |
| 7    | `networkError`            | An error occurred with the video streaming process. The associated string (if available) will contain further information about the error.                                                       |
| 8    | `serverError`             | A server-side error/token invalidation occurred. The associated string (if available) will contain further information about the error.                                                          |
| 9    | `unexpectedError`         | An unexpected and unrecoverable error has occurred. The associated string will contain further information about the error. These errors should be reported to iProov for further investigation. |

#### Android

The `FaceAuthenticatorFailure` object return the following parameters.

| Field                                                                                         |
| --------------------------------------------------------------------------------------------- |
| <p>`String errorType`</p><p> Error type returned by the SDK. `NetworkReason` or `ServerReason`.</p> |
| <p>`String errorMessage`</p><p>Error message returned by the SDK.</p>                               |
| <p>`String code`</p><p>Error code returned by the SDK.</p>                                          |
