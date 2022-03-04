# [PassiveFaceLiveness](https://docs.combateafraude.com/docs/mobile/introduction/home/#passivefaceliveness) - Flutter Plugin

Plugin que chama os SDKs nativos em [Android](https://docs.combateafraude.com/docs/mobile/android/passive-face-liveness/) e [iOS](https://docs.combateafraude.com/docs/mobile/ios/passive-face-liveness/). Caso tenha alguma dúvida, envie um email para o nosso [Head of Mobile](mailto:daniel.seitenfus@combateafraude.com)

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Dart                | 2.12+  |
| Android API         | 21+    |
| iOS                 | 11.0+  |
| Swift               | 5.5.2  |

Caso você utilize Dart em uma versão abaixo de 2.12, confira a versão compatível [aqui](https://github.com/combateafraude/Flutter/tree/passive-face-liveness-compatible).

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

Para habilitar texto e voz em Português, em seu projeto, no diretório ROOTPROJECT/ios, abra o arquivo .xcworkspace no Xcode e adicione em Project > Info > Localizations o idioma Portuguese (Brazil).

### Flutter

Adicione o plugin no seu arquivo `ROOT_PROJECT/pubspec.yaml`:

```yml
dependencies:  
  passive_face_liveness:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: passive-face-liveness-compatible-v4.7.0
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

### Customizações gerais

| PassiveFaceLiveness |
| --------- |
| `.setPeopleId(String peopleId)`<br><br>CPF do usuário que está utilizando o plugin à ser usado para detecção de fraudes via analytics |
| `.setPersonName(String personName)`<br><br>Vincula uma tentativa de prova de vida a um nome |
| `.setPersonCPF(String personCPF)`<br><br>Vincula uma tentativa de prova de vida a um cpf |
| `.setAnalyticsSettings(bool useAnalytics)`<br><br>Habilita/desabilita a coleta de dados para maximização da informação antifraude. O padrão é `true` |
| `.enableSound(bool enable)`<br><br>Habilita/desabilita os sons. O padrão é `true` |
| `.setNetworkSettings(int requestTimeout)`<br><br>Altera as configurações de rede padrão. O padrão é `60` segundos |
| `.setShowPreview(ShowPreview showPreview)`<br><br> Preview para verificação de qualidade da foto |
| `.setCaptureMode(VideoCapture videoCapture, ImageCapture imageCapture)`<br><br> Define as configurações de captura |
| `.setAndroidSettings(PassiveFaceLivenessAndroidSettings androidSettings)`<br><br>Customizações somente aplicadas em Android |
| `.setIosSettings(PassiveFaceLivenessIosSettings iosSettings)`<br><br>Customizações somente aplicadas em iOS |

| ShowPreview |
| --------- |
| `bool show`<br><br>Habilita/Desabilita preview
| `String title`<br><br>Título
| `String subTitle`<br><br> Subtítulo
| `String confirmLabel`<br><br>Texto do botão de confirmação
| `String retryLabel`<br><br>Texto do botão de capturar novamente

| Exemplo de uso |
```dart
ShowPreview showPreview = new ShowPreview(
        show: true,
        title: "A foto ficou boa?",
        subTitle: "Veja se a foto está nítida",
        confirmLabel: "Sim, ficou boa!",
        retryLabel: "Tirar novamente");

passiveFaceLiveness.setShowPreview(showPreview);
```

| MessageSettings |
| --------- | 
| `bool show`<br><br>Padrão: Habilita/Desabilita preview |
| `String stepName`<br><br>Padrão: "Registro Facial" |
| `String holdItMessage`<br><br>Padrão: "Segure assim" |
| `String faceNotFoundMessage`<br><br>Padrão: "Não encontramos nenhum rosto" |
| `String faceTooFarMessage`<br><br>Padrão: "Aproxime o rosto" |
| `String faceTooCloseMessage (somente para Android)`<br><br>Padrão: "Afaste o rosto" |
| `String faceNotFittedMessage`<br><br>Padrão: "Encaixe seu rosto" |
| `String multipleFaceDetectedMessage`<br><br>Padrão: "Mais de um rosto detectado" |
| `String verifyingLivenessMessage`<br><br>Padrão: "Verificando selfie…" |
| `String invalidFaceMessage`<br><br>Padrão: "Ops, rosto inválido. Por favor, tente novamente" |
| `String? sensorStabilityMessage`<br><br>Padrão: "Mantenha o celular parado"|;
| `String? sensorLuminosityMessage (somente para Android)`<br><br>Padrão: "Ambiente muito escuro"|;
| `String? sensorOrientationMessage (somente para Android)`<br><br>Padrão: "Celular não está na vertical"|;
| `String eyesClosedMessage (somente para Android)`<br><br>Padrão: "Seus olhos estão fechados" |
| `String notCenterXMessage (somente para Android)`<br><br>Padrão: "Centralize seu rosto na vertical" |
| `String notCenterYMessage (somente para Android)`<br><br>Padrão: "Centralize seu rosto na horizontal" |
| `String notCenterZMessage (somente para Android)`<br><br>Padrão: "Seu rosto não está ajustado à máscara" |

| <b>Exemplo de uso </b> |

```dart
MessageSettings messageSettings = new MessageSettings(
        stepName: "Mensagem de exemplo",
        faceNotFoundMessage: "Mensagem de exemplo",
        faceTooFarMessage: "Mensagem de exemplo",
        faceTooCloseMessage: "Mensagem de exemplo",
        faceNotFittedMessage: "Mensagem de exemplo",
        multipleFaceDetectedMessage: "Mensagem de exemplo",
        verifyingLivenessMessage: "Mensagem de exemplo",
        holdItMessage: "Mensagem de exemplo",
        invalidFaceMessage: "Mensagem de exemplo");

passiveFaceLiveness.setMessageSettings(messageSettings);

```

#### Android

| PassiveFaceLivenessAndroidSettings constructor |
| --------- |
| `PassiveFaceLivenessCustomizationAndroid customization`<br><br>Customização do layout em Android da activity |
| `CaptureSettings captureSettings`<br><br>Configuraçōes de tempos de estabilização para a captura da selfie |
| `SensorSettingsAndroid sensorSettings`<br><br>Customização das configurações dos sensores de captura |
| `int showButtonTime`<br><br>Altera o tempo para a exibição do botão de captura manual. O padrão é `20000` milisegundos |
| `bool enableSwitchCameraButton`<br><br>Permite habilitar ou desabilitar o botão de inversão da câmera. O padrão é `True` |
| `bool enableGoogleServices`<br><br>Permite habilitar/desabilitar recursos do SDK que consomem GoogleServices no SDK, não recomendamos desabilitar os serviços por conta da perda de segurança. O padrão é `True` |
| `bool emulatorSettings`<br><br>Permite habilitar/desabilitar o uso de dispositivos emulados no SDK, recomendamos desabilitar o uso dos emuladores por questões de segurança. O padrão é `False` |
| `bool rootSettings`<br><br>Permite habilitar/desabilitar o uso de dispositivos com root no SDK, recomendamos desabilitar o uso desses dispositivos por questões de segurança. O padrão é `False` |

| PassiveFaceLivenessCustomizationAndroid constructor |
| --------- |
| `String styleResIdName`<br><br>Nome do style resource que define as cores do SDK. Por exemplo, caso deseje mudar as cores do SDK, crie um style em `ROOT_PROJECT/android/app/src/main/res/values/styles.xml` com o nome `R.style.my_custom_style` seguindo o [template](https://gist.github.com/kikogassen/4b57db7139034ea2e85ea798eb88d248) e parametrize "my_custom_style" |
| `String layoutResIdName`<br><br>Nome do layout resource que substituirá o layout padrão do SDK. Por exemplo, caso deseje mudar o layout do SDK, crie um layout em `ROOT_PROJECT/android/app/src/main/res/layout/my_custom_layout.xml` seguindo o [template](https://gist.github.com/dbseitenfus/b4f4cb601ba854b0c041625ed75af0b4) e parametrize "my_custom_layout" |
| `String greenMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara verde padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_green_mask.png` e parametrize "my_custom_green_mask" |
| `String redMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara vermelha padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_red_mask.png` e parametrize "my_custom_red_mask" |
| `String whiteMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara branca padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_white_mask.png` e parametrize "my_custom_white_mask" |
| `MaskType maskType`<br><br>Define o tipo de máscara utilizada nas capturas. Existem dois tipos: MaskType.DEFAULT, com o padrão pontilhado e MaskType.NONE, que remove completamente a máscara. O padrão é `MaskType.DEFAULT` |


| CaptureSettings constructor |
| --------- |
| `int beforePictureMillis`<br><br>Duração em milissegundos entre a primeira detecção do rosto e a efetiva captura da foto |
| `int afterPictureMillis`<br><br>Duração em milissegundos entre a captura da foto e o envio para o servidor para o mantimento do rosto e dos sensores válidos |


| SensorSettingsAndroid constructor |
| --------- |
| `SensorStabilitySettingsAndroid sensorStabilitySettings`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |

| SensorStabilitySettingsAndroid constructor |
| --------- |
| `int stabilityStabledMillis`<br><br>Quantos milissegundos o celular deve se manter no limiar correto para ser considerado estável. O padrão é `2000` ms |
| `double stabilityThreshold`<br><br>Limiar inferior entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `0.5` m/s² |

#### iOS

| PassiveFaceLivenessIosSettings constructor |
| --------- |
| `PassiveFaceLivenessCustomizationIos customization`<br><br>Customização visual do SDK |
| `int beforePictureMillis`<br><br>Duração em milissegundos entre a primeira detecção do rosto e a efetiva captura da foto |
| `SensorStabilitySettingsIos sensorStability`<br><br>Configurações do sensor de estabilidade à ser aplicado no SDK |
| `bool enableManualCapture`<br><br>Habilita modo de captura manual |
| `double timeEnableManualCapture`<br><br>Define tempo para exibição do botão de captura manual |

| PassiveFaceLivenessCustomizationIos constructor |
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

O objeto de retorno do PassiveFaceLiveness é do tipo abstrato `PassiveFaceLivenessResult`. Ele pode ser uma instância de `PassiveFaceLivenessSuccess`, `PassiveFaceLivenessFailure` ou `PassiveFaceLivenessClosed`.

#### PassiveFaceLivenessSuccess

| Campo |
| --------- |
| `String imagePath`<br><br>Endereço completo da imagem no dispositivo |
| `String imageUrl`<br><br>URL da imagem armazenada temporariamente nos servidores da CAF |
| `String signedResponse`<br><br>Resposta assinada do servidor da CAF que confirmou que a selfie capturada possui um rosto verdadeiro (não é foto de foto ou vídeo). Utilize esse parâmetro caso queira uma camada extra de segurança verificando se a assinatura da resposta não está quebrada, provocada por uma interceptação da requisição. Se estiver quebrada, há um grande indício de interceptação da requisição |
| `String trackingId`<br><br>Identificador dessa execução em nossos servidores. Se possível, salve este campo e mande-o junto para nossa API. Assim, teremos mais dados de como o usuário se comportou durante a execução | Será nulo se o usuário configurar useAnalytics = false ou as chamadas de analytics não funcionarem |

#### PassiveFaceLivenessFailure

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

### Customizando view iOS

Para customização iOS, é necessário que os plugins Flutter estejam adicionados localmente no projeto. A customizção é realizada nativamente com a abordagem ViewCode.

[Clique aqui](https://github.com/combateafraude/Flutter/tree/ios-customization-example) e acesse o exemplo com um guia para utilização desse recurso.
