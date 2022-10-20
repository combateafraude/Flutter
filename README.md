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

``` gradle
android {

    ...

    dataBinding.enabled = true

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
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
      ref: face-authenticator-v3.10.0
```
#### Release Candidate
```yml
dependencies:  
  face_authenticator:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: face-authenticator-v3.11.0-rc01
```

## Utilização

```dart
FaceAuthenticator faceAuthenticator = new FaceAuthenticator(mobileToken: mobileToken);
faceAuthenticator.setPeopleId("The user CPF");

// Outros parâmetros de customização

FaceAuthenticatorResult faceAuthenticatorResult = await faceAuthenticator.start();

if (faceAuthenticatorResult is FaceAuthenticatorSuccess) {
  // O SDK foi encerrado com sucesso e obtivemos um resultado de autenticação, que pode ser verdadeiro ou falso
} else if (faceAuthenticatorResult is FaceAuthenticatorFailure) {
  // O SDK foi encerrado devido à alguma falha e não foi possível obter um resultado de autenticação
} else {
  // O usuário simplesmente fechou o SDK, sem nenhum resultado
}
```

### Customizações gerais

| FaceAuthenticator |
| --------- |
| `.setPeopleId(String peopleId)`<br><br>CPF do usuário que irá se autenticar |
| `.setAudioSettings(bool enable, String audioResIdName)`<br><br>Habilita/desabilita os sons. Permite customizar o áudio utilizado pelo SDK. Caso deseje mudar o áudio do SDK, adicione o arquivo de audio em `ROOT_PROJECT/android/app/src/main/res/raw/` com o nome desejado seguindo e o parametrize |
| `.setAnalyticsSettings(bool useAnalytics)`<br><br>Habilita/desabilita a coleta de dados para maximização da informação antifraude. O padrão é `true` |
| `.setNetworkSettings(int requestTimeout)`<br><br>Altera as configurações de rede padrão. O padrão é `60` segundos |
| `.setAndroidSettings(FaceAuthenticatorAndroidSettings androidSettings)`<br><br>Customizações somente aplicadas em Android |
| `.setIosSettings(FaceAuthenticatorIosSettings iosSettings)`<br><br>Customizações somente aplicadas em iOS |
| `.setEyesClosedSettings(bool enable, double threshold)`<br><br> Permite customizar a validação de olhos abertos no SDK |

#### Android

| FaceAuthenticatorAndroidSettings constructor |
| --------- |
| `FaceAuthenticatorCustomizationAndroid customization`<br><br>Customização do layout em Android da activity |
| `CaptureSettings captureSettings`<br><br>Configuraçōes de tempos de estabilização para a captura da selfie |
| `SensorSettingsAndroid sensorSettings`<br><br>Customização das configurações dos sensores de captura |
| `bool enableEmulator`<br><br>Permite o uso de emulador quando `true` |
| `bool enableRootDevices`<br><br>Permite o uso de dispositivos root quando `true` |
| `bool enableSwitchCameraButton`<br><br>Permite habilitar ou desabilitar o botão de inversão da câmera. O padrão é `True` |
| `bool enableBrightnessIncrease`<br><br>Habilita/desabilita o incremento de brilho do dispositivo do dispositivo na abertura do SDK |
 `bool useDebug`<br><br>Habilita/desabilita o uso do app em modo depuração. O padrão é `false` |


| FaceAuthenticatorCustomizationAndroid constructor |
| --------- |
| `String styleResIdName`<br><br>Nome do style resource que define as cores do SDK. Por exemplo, caso deseje mudar as cores do SDK, crie um style em `ROOT_PROJECT/android/app/src/main/res/values/styles.xml` com o nome `R.style.my_custom_style` seguindo o [template](https://gist.github.com/kikogassen/4b57db7139034ea2e85ea798eb88d248) e parametrize "my_custom_style" |
| `String layoutResIdName`<br><br>Nome do layout resource que substituirá o layout padrão do SDK. Por exemplo, caso deseje mudar o layout do SDK, crie um layout em `ROOT_PROJECT/android/app/src/main/res/layout/my_custom_layout.xml` seguindo o [template](https://gist.github.com/kikogassen/63a45e15501140fd0149b17ec824115a) e parametrize "my_custom_layout" |
| `String greenMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara verde padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_green_mask.png` e parametrize "my_custom_green_mask" |
| `String redMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara vermelha padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_red_mask.png` e parametrize "my_custom_red_mask" |
| `String whiteMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara branca padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_white_mask.png` e parametrize "my_custom_white_mask" |


| SensorSettingsAndroid constructor |
| --------- |
| `SensorStabilitySettingsAndroid sensorStabilitySettings`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |

| SensorStabilitySettingsAndroid constructor |
| --------- |
| `String messageResourceIdName`<br><br>Nome do string resource à ser mostrado quando o celular não estiver estável. A mensagem padrão é "Mantenha o celular parado". Por exemplo, caso deseje mostrar a String "Teste", crie uma String em `ROOT_PROJECT/android/app/src/main/res/values/strings.xml` com o nome `R.string.my_custom_stability_string` e valor "Teste" e parametrize "my_custom_stability_string" |
| `int stabilityStabledMillis`<br><br>Quantos milissegundos o celular deve se manter no limiar correto para ser considerado estável. O padrão é `2000` ms |
| `double stabilityThreshold`<br><br>Limiar inferior entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `0.5` m/s² |

#### iOS

| FaceAuthenticatorIosSettings constructor |
| --------- |
| `FaceAuthenticatorCustomizationIos customization`<br><br>Customização visual do SDK |
| `int beforePictureMillis`<br><br>Duração em milissegundos entre a primeira detecção do rosto e a efetiva captura da foto |
| `SensorStabilitySettingsIos sensorStability`<br><br>Configurações do sensor de estabilidade à ser aplicado no SDK |

| FaceAuthenticatorCustomizationIos constructor |
| --------- |
| `String colorHex`<br><br>Cor tema do SDK. Por exemplo, caso deseje usar a cor preta, utilize "#000000" |
| `String greenMaskImageName`<br><br>Nome da imagem à substituir a máscara verde padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String whiteMaskImageName`<br><br>Nome da imagem à substituir a máscara branca padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String redMaskImageName`<br><br>Nome da imagem à substituir a máscara vermelha padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String closeImageName`<br><br>Nome da imagem à substituir o botão de fechar o SDK. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `bool showStepLabel`<br><br>Flag que indica se deseja mostrar o label do passo atual |
| `bool showStatusLabel`<br><br>Flag que indica se deseja mostrar o label do status atual |

| SensorStabilitySettingsAndroid constructor |
| --------- |
| `String message`<br><br>String à ser mostrada quando o celular não estiver estável |
| `double stabilityThreshold`<br><br>Limiar inferior entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `0.3` m/s² |

### Coletando o resultado

O objeto de retorno do FaceAuthenticator é do tipo abstrato `FaceAuthenticatorResult`. Ele pode ser uma instância de `FaceAuthenticatorSuccess`, `FaceAuthenticatorFailure` ou `FaceAuthenticatorClosed`.

#### FaceAuthenticatorSuccess

| Campo |
| --------- |
| `bool authenticated`<br><br>Flag que indica se o usuário foi aprovado na autenticação facial |
| `String signedResponse`<br><br>Resposta assinada do servidor da CAF que confirmou a autenticação facial. Utilize esse parâmetro caso queira uma camada extra de segurança verificando se a assinatura da resposta não está quebrada, provocada por uma interceptação da requisição. Se estiver quebrada, há um grande indício de interceptação da requisição |
| `String trackingId`<br><br>Identificador dessa execução em nossos servidores. Se possível, salve este campo e mande-o junto para nossa API. Assim, teremos mais dados de como o usuário se comportou durante a execução | Será nulo se o usuário configurar useAnalytics = false ou as chamadas de analytics não funcionarem |

#### FaceAuthenticatorFailure

| Campo |
| --------- |
| `String message`<br><br>Mensagem amigável explicando o motivo da falha do SDK |
| `String type`<br><br>Tipo de falha que encerrou o SDK |

Os tipos de falha existentes são:
- `InvalidTokenReason`: quando o token informado é inválido. Não deve ocorrer em um ambiente de produção;
- `PermissionReason`: quando alguma permissão obrigatória não foi concedida pelo usuário. Só ocorrerá em um ambiente de produção se o seu app não solicitar ao seu usuário ou o mesmo desabilitar manualmente antes de iniciar;
- `NetworkReason`: falha de conexão com o servidor. Ocorrerá em produção se o dispositivo do usuário estiver sem internet;
- `ServerReason`: falha em alguma requisição com nossos servidores. Ocorrerá em produção somente no caso de uma falha nossa;
- `SecurityReason`: quando o dispositivo não é seguro para executar o SDK. Se esta falha ocorrer, avise-nos;
- `StorageReason`: quando o dispositivo não possui espaço suficiente para a captura de alguma foto. Pode ocorrer em produção;
- `LibraryReason`: quando alguma falha interna impossibilitou a execução do SDK. Pode ocorrer devico à erros de configuração do projeto, não deve ocorrer em produção;

