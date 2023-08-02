# [NewFaceLiveness](https://docs.caf.io/sdks/android/getting-started/passivefaceliveness) - Flutter Plugin

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Dart                | 2.12+  |
| Android API         | 21+    |
| iOS                 | 11.0+  |

## Configurações

### Android

No arquivo `ROOT_PROJECT/android/app/build.gradle`, adicione:

``` gradle
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

``` swift
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
PassiveFaceLiveness passiveFaceLiveness = new PassiveFaceLiveness(mobileToken: mobileToken);

// Outros parâmetros de customização

PassiveFaceLivenessResult passiveFaceLivenessResult = await passiveFaceLiveness.start();

if (passiveFaceLivenessResult is PassiveFaceLivenessSuccess) {
  // O SDK foi encerrado com sucesso e a selfie foi capturada
} else if (passiveFaceLivenessResult is PassiveFaceLivenessFailure) {
  // O SDK foi encerrado devido à alguma falha e a selfie não foi capturada
} else {
  // O usuário simplesmente fechou o SDK, sem nenhum resultado
}
```


#### PassiveFaceLivenessSuccess

| Campo |
| --------- |
| `String signedResponse`<br><br> Signed response from the CAF server confirming that the captured selfie has a real face. This parameter is used to get an extra layer of security, checking that the signature of the response is not broken, or caused by request interception. If it is broken, there is a strong indication of request interception.|

#### PassiveFaceLivenessFailure

| Campo |
| --------- |
| `String errorMessage`<br><br>Mensagem explicando o motivo da falha do SDK.|