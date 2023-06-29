# [FaceAuthenticator](https://docs.combateafraude.com/docs/mobile/introduction/home/#faceauthenticator) - Flutter Plugin

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Dart                | 2.12+  |
| Android API         | 21+    |
| iOS                 | 11.0+  |

Caso você utilize Dart em uma versão abaixo de 2.12, confira a versão compatível [aqui](https://github.com/combateafraude/Flutter/tree/face-authenticator-compatible).

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
}
```

No arquivo `ROOT_PROJECT/android/app/settings.gradle`, adicione:

```gradle
dependencyResolutionManagement {
    repositories {
        ...
        //Your maven should be like this
        maven { url 'https://raw.githubusercontent.com/iProov/android/master/maven/' }
        maven { url 'https://repo.combateafraude.com/android/release' }
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

### Flutter

Adicione o plugin no seu arquivo `ROOT_PROJECT/pubspec.yaml`:

#### Estável
```yml
dependencies:  
  face_authenticator:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: new-face-authenticator-v1.0.0
```

## Utilização

```dart
FaceAuthenticator faceAuthenticator = new FaceAuthenticator(mobileToken: mobileToken, personId: personId);


// Outros parâmetros de customização
faceAuthenticator.setCafStage(CafStage.PROD);


FaceAuthenticatorResult faceAuthenticatorResult = await faceAuthenticator.start();

if (faceAuthenticatorResult is FaceAuthenticatorSuccess) {
  // O SDK foi encerrado com sucesso e obtivemos um resultado de autenticação, que pode ser verdadeiro ou falso
} else if (faceAuthenticatorResult is FaceAuthenticatorFailure) {
  // O SDK foi encerrado devido à alguma falha e não foi possível obter um resultado de autenticação
} else {
  // O usuário simplesmente fechou o SDK, sem nenhum resultado
}
```