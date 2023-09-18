# [NewFaceAuthenticator](https://docs.caf.io/sdks/android/getting-started/faceauthenticator) - Flutter Plugin

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.10+  |
| Dart                | 2.7+   |
| Android API         | 21+    |
| iOS                 | 11.0+  |

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
source 'https://cdn.cocoapods.org/' # ou 'https://github.com/CocoaPods/Specs' se o CDN estiver fora do ar
```

Por último, adicione a permissão de câmera no arquivo `ROOT_PROJECT/ios/Runner/Info.plist`:

```
<key>NSCameraUsageDescription</key>
<string>To capture the selfie</string>
```

## Utilização

```dart
FaceAuthenticator faceAuthenticator = new FaceAuthenticator(mobileToken: mobileToken, personId: 'CPF');

// Outros parâmetros de customização

FaceAuthenticatorSuccess faceAuthenticatorResult = await faceAuthenticator.start();

if (faceAuthenticatorResult is FaceAuthenticatorSuccess) {
  // O SDK foi encerrado com sucesso e a selfie foi capturada
} else if (faceAuthenticatorResult is FaceAuthenticatorSuccess) {
  // O SDK foi encerrado devido à alguma falha e a selfie não foi capturada
} else {
  // O usuário simplesmente fechou o SDK, sem nenhum resultado
}
```

### FaceAuthenticator methods

| Parameter                                                                                                                                                                                          | Required                                         |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| <p><strong><code>.setStage(String stage)</code></strong></p><p>Used to redirect the SDK to the desired environment in caf api.</p>                                                                 | No                                               |
| <p><strong><code>.setFilter(String filter)</code></strong></p><p>Used to change the SDK camera filter. It has the following options: **CameraFilter.NATURAL** or **CameraFilter.LINE_DRAWING**</p> | No, the default is **CameraFilter.LINE_DRAWING** |
| <p><strong><code>.setEnableScreenshots(bool enable)</code></strong></p><p>Used to enable screenshots during the SDK scan.</p>                                                                      | No, the default is **false**                     |

### Enums

#### CafStage

| Description                                                    | Values                           |
| -------------------------------------------------------------- | -------------------------------- |
| Used to set the SDK stage on `.setStage(String stage)` method. | `CafStage.PROD`, `CafStage.BETA` |

#### CameraFilter

| Description                         | Values                                              |
| ----------------------------------- | --------------------------------------------------- |
| Used to set the SDK's camera filter | `CameraFilter.NATURAL`, `CameraFilter.LINE_DRAWING` |

### FaceAuthenticatorSuccess

| Field                                                                                                                                                                                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `String signedResponse`<br><br> Signed response from the CAF server confirming that the captured selfie has a real face. This parameter is used to get an extra layer of security, checking that the signature of the response is not broken, or caused by request interception. If it is broken, there is a strong indication of request interception. |

### FaceAuthenticatorFailure

#### iOS

The `FaceAuthenticatorFailure` object return the following parameters.

| Field                                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------------ |
| `String signedResponse`<br><br> Signed response from the CAF server confirming that the captured selfie has a real face. |
| `String errorType`<br><br> Error type returned by the SDK. Check the table below.                                        |
| `String errorMessage`<br><br>Error message returned by the SDK.                                                          |
| `String code`<br><br>Error code returned by the SDK. Check the table below.                                              |

In case of failure, the `FaceAuthenticatorFailure` object will also return a signedResponse containing information.
Within the signedResponse, the parameter isAlive defines the execution of liveness, where true is approved and false is rejected.

| Code | Error Type                | Description                                                                                                                                                                                      |
| ---- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1    | `unknown`                 | Try aganin                                                                                                                                                                                       |
| 2    | `getToken`                | Error while trying to capture the execution token.                                                                                                                                               |
| 3    | `livenessError`           | Error while attempting to execute liveness due to communication issues.                                                                                                                          |
| 4    | `registerError`           | Error while performing the registration of the liveness execution.                                                                                                                               |
| 5    | `captureAlreadyActive`    | An existing capture is already in progress. Wait until the current capture completes before starting a new one.                                                                                  |
| 6    | `cameraPermissionDenied ` | The user disallowed access to the camera when prompted. You should direct the user to re-try.                                                                                                    |
| 7    | `networkError`            | An error occurred with the video streaming process. The associated string (if available) will contain further information about the error.                                                       |
| 8    | `serverError`             | A server-side error/token invalidation occurred. The associated string (if available) will contain further information about the error.                                                          |
| 9    | `unexpectedError`         | An unexpected and unrecoverable error has occurred. The associated string will contain further information about the error. These errors should be reported to iProov for further investigation. |

#### Android

The `FaceAuthenticatorFailure` object return the following parameters.

| Field                                                                                         |
| --------------------------------------------------------------------------------------------- |
| `String errorType`<br><br> Error type returned by the SDK. `NetworkReason` or `ServerReason`. |
| `String errorMessage`<br><br>Error message returned by the SDK.                               |
| `String code`<br><br>Error code returned by the SDK.                                          |
