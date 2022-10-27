# [PassiveFaceLiveness](https://docs.combateafraude.com/docs/mobile/introduction/home/#passivefaceliveness) - Flutter Plugin

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Dart                | 2.12+  |
| Android API         | 21+    |
| iOS                 | 11.0+  |

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

//Para realizar a customização de layout do SDK faça a importação das seguintes bibliotecas
dependencies {
    implementation "androidx.camera:camera-view:1.2.0-alpha02"
    implementation 'com.combateafraude.sdk:passive-face-liveness:5.25.11'
    //SDK Android nativo que o plugin implementa

//bibliotecas de design que irá utilizar em seu layout (estas são utilizadas em nosso template de exemplo para customização)
    implementation 'com.google.android.material:material:1.2.1'
    implementation 'androidx.constraintlayout:constraintlayout:2.0.2'
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

## Flutter

Adicione o plugin no seu arquivo `ROOT_PROJECT/pubspec.yaml`:

#### Estável
```yml
dependencies:  
  passive_face_liveness:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: passive-face-liveness-v4.29.5
```
#### Release Candidate
```yml
dependencies:  
  passive_face_liveness:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: passive-face-liveness-v4.29.0-rc01
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
## Desativando validações de segurança para teste
Estamos constantemente realizando ações para tornar o produto cada vez mais seguro, mitigando uma série de ataques observados ao processo de captura e, consequentemente, reduzindo o maior número de possíveis fraudes de identidade. O SDK possui alguns bloqueios que podem impedir a execução em certos contextos. Para desabilitá-los, você pode utilizar os métodos conforme o exemplo abaixo:
``` dart
PassiveFaceLivenessAndroidSettings androidSettings =
        PassiveFaceLivenessAndroidSettings(
          emulatorSettings: true,
          rootSettings: true,
          useDeveloperMode: true,
          useAdb: true,
          useDebug: true,
        );

passiveFaceLiveness.setAndroidSettings(androidSettings);
```
> <b>Atenção!</b> Desabilitar as validações de segurança são recomendadas <b>apenas para ambiente de testes. </b>Para publicação do seu aplicativo em produção, recomendamos utilizar as configurações padrão.

### Customizações gerais

| PassiveFaceLiveness |
| --------- |
| `.setPeopleId(String peopleId)`<br><br>CPF do usuário que está utilizando o plugin à ser usado para detecção de fraudes via analytics |
| `.setPersonName(String personName)`<br><br>Vincula uma tentativa de prova de vida a um nome |
| `.setPersonCPF(String personCPF)`<br><br>Vincula uma tentativa de prova de vida a um cpf |
| `.setAnalyticsSettings(bool useAnalytics)`<br><br>Habilita/desabilita a coleta de dados para maximização da informação antifraude. O padrão é `true` |
| `.setAudioSettings(bool enable, String audioResIdName)`<br><br>Habilita/desabilita os sons. Permite customizar o áudio utilizado pelo SDK. Caso deseje mudar o áudio do SDK, adicione o arquivo de audio em `ROOT_PROJECT/android/app/src/main/res/raw/` com o nome desejado seguindo e o parametrize || `.setNetworkSettings(int requestTimeout)`<br><br>Altera as configurações de rede padrão. O padrão é `60` segundos |
| `.setShowPreview(ShowPreview showPreview)`<br><br> Preview para verificação de qualidade da foto |
| `.setCaptureMode(VideoCapture videoCapture, ImageCapture imageCapture)`<br><br> Define as configurações de captura |
| `.setGetImageUrlExpireTime(String expireTime)`<br><br> Define o tempo de duração da URL da imagem no servidor até ser expirada. Espera receber um intervalo de tempo entre "30m" à "30d". O padrão é `3h` |
| `.setMessageSettings(MessageSettings messageSettings)`<br><br> Permite personalizar as mensagens exibidas no balão de "status" durante o processo de captura e análise |
| `.setCurrentStepDoneDelay(bool showDelay, int delay)`<br><br> Aplica delay na activity após a finalização de cada etapa. Esse método pode ser utilizado para exibir uma mensagem de sucesso na própria tela após a captura, por exemplo. O padrão é `false` |
| `.setAndroidSettings(PassiveFaceLivenessAndroidSettings androidSettings)`<br><br>Customizações somente aplicadas em Android |
| `.setIosSettings(PassiveFaceLivenessIosSettings iosSettings)`<br><br>Customizações somente aplicadas em iOS |
| `.setEyesClosedSettings(bool enable, double threshold)`<br><br> Permite customizar a validação de olhos abertos no SDK |
| `.setCaptureProcessingErrorMessage(@NonNull @StringRes Integer message)`<br><br> Permite customizar a mensagem exibida quando ocorre um problema no processamento ou erro na response da API. |

| ImageCapture constructor |
| --------- |
| `bool use`<br><br>Habilita/desabilita a captura de um frame. O padrão é `true` |
| `int beforePictureMillis`<br><br>Duração em milissegundos entre a primeira detecção do rosto e a efetiva captura da foto. O padrão é 0 ms |
| `int afterPictureMillis`<br><br>Duração em milissegundos entre a captura da foto e o envio para o servidor para o mantimento do rosto e dos sensores válidos. O padrão é 2000 ms |

| VideoCapture constructor |
| --------- |
| `bool use`<br><br>Habilita/desabilita a captura por vídeo. O padrão é `false` |
| `int time`<br><br>Estabelece o tempo do vídeo que será capturado. O padrão é 3s|

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
| `String? captureProcessingErrorMessage` <br><br>Padrão: "Ops, tivemos um problema ao processar sua imagem. Tente novamente."|
| `String multipleFaceDetectedMessage`<br><br>Padrão: "Mais de um rosto detectado" |<br><br>Padrão: "Ambiente muito escuro"|;
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
| `SensorSettingsAndroid sensorSettings`<br><br>Customização das configurações dos sensores de captura |
| `int showButtonTime`<br><br>Altera o tempo para a exibição do botão de captura manual. O padrão é `20000` milisegundos |
| `bool enableSwitchCameraButton`<br><br>Permite habilitar ou desabilitar o botão de inversão da câmera. O padrão é `True` |
| `bool enableGoogleServices`<br><br>Permite habilitar/desabilitar recursos do SDK que consomem GoogleServices no SDK, não recomendamos desabilitar os serviços por conta da perda de segurança. O padrão é `True` |
| `bool emulatorSettings`<br><br>Permite habilitar/desabilitar o uso de dispositivos emulados no SDK. Recomendamos desabilitar o uso dos emuladores por questões de segurança. O padrão é `False` |
| `bool rootSettings`<br><br>Permite habilitar/desabilitar o uso de dispositivos com root no SDK. Recomendamos desabilitar o uso desses dispositivos por questões de segurança. O padrão é `False` |
| `bool useDeveloperMode`<br><br>Permite habilitar/desabilitar o uso de dispositivos com o modo de desenvolvedor Android ativado. Recomendamos desabilitar o uso desses dispositivos por questões de segurança. O padrão é `False` |
| `bool useAdb`<br><br>Permite habilitar/desabilitar o uso do modo de depuração Android Debug Bridge (ADB). Recomendamos desabilitar o uso desses dispositivos por questões de segurança. O padrão é `False` |
| `bool useAdb`<br><br>Habilita/desabilita o uso do app em modo depuração. O padrão é `False` |
| `bool enableBrightnessIncrease`<br><br>Habilita/desabilita o incremento de brilho do dispositivo do dispositivo na abertura do SDK |

| PassiveFaceLivenessCustomizationAndroid constructor |
| --------- |
| `String styleResIdName`<br><br>Nome do style resource que define as cores do SDK. Por exemplo, caso deseje mudar as cores do SDK, crie um style em `ROOT_PROJECT/android/app/src/main/res/values/styles.xml` com o nome `R.style.my_custom_style` seguindo o [template](https://gist.github.com/kikogassen/4b57db7139034ea2e85ea798eb88d248) e parametrize "my_custom_style" |
| `String layoutResIdName`<br><br>Nome do layout resource que substituirá o layout padrão do SDK. Por exemplo, caso deseje mudar o layout do SDK, crie um layout em `ROOT_PROJECT/android/app/src/main/res/layout/my_custom_layout.xml` seguindo o [template](https://gist.github.com/dbseitenfus/b4f4cb601ba854b0c041625ed75af0b4) e parametrize "my_custom_layout". Verifique as importações das bibliotecas mencionadas [aqui](#android)|
| `String greenMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara verde padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_green_mask.png` e parametrize "my_custom_green_mask" |
| `String redMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara vermelha padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_red_mask.png` e parametrize "my_custom_red_mask" |
| `String whiteMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara branca padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_white_mask.png` e parametrize "my_custom_white_mask" |
| `MaskType maskType`<br><br>Define o tipo de máscara utilizada nas capturas. Existem dois tipos: MaskType.DEFAULT, com o padrão pontilhado e MaskType.NONE, que remove completamente a máscara. O padrão é `MaskType.DEFAULT` |

| SensorSettingsAndroid constructor |
| --------- |
| `SensorStabilitySettingsAndroid sensorStabilitySettings`<br><br>Configurações do sensor de estabilidade à ser aplicado em todos os passos do SDK |
| `SensorOrientationAndroid sensorOrientationAndroid`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |

| SensorStabilitySettingsAndroid constructor |
| --------- |
| `int stabilityStabledMillis`<br><br>Quantos milissegundos o celular deve se manter no limiar correto para ser considerado estável. O padrão é `1500` ms |
| `double stabilityThreshold`<br><br>Limiar entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `0.7` m/s² |

| SensorOrientationAndroid constructor |
| --------- |
| `double stabilityThreshold`<br><br>Limiar entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `4` m/s² |


#### iOS

| PassiveFaceLivenessIosSettings constructor |
| --------- |
| `PassiveFaceLivenessCustomizationIos customization`<br><br>Customização visual do SDK |
| `int beforePictureMillis`<br><br>Duração em milissegundos entre a primeira detecção do rosto e a efetiva captura da foto |
| `SensorStabilitySettingsIos sensorStability`<br><br>Configurações do sensor de estabilidade à ser aplicado no SDK |
| `bool enableManualCapture`<br><br>Habilita modo de captura manual |
| `double timeEnableManualCapture`<br><br>Define tempo (em segundos) para exibição do botão de captura manual |
| `double compressionQuality`<br><br>Permite configurar a qualidade no processo de compressão. Por padrão, todas capturas passam por compressão. O método espera como parâmetro valores entre 0 e 1.0, sendo 1.0 a compressão com melhor qualidade (recomendado).O padrão é 1.0 |
| `String resolution`<br><br>Permite configurar a resolução de captura. O método espera como parâmetro uma `String IosResolution` (O padrão é `hd1280x720`), que possui as seguintes opções:|

| Resolution | Descrição |
| :--: | :--: |
| `low` |Especifica as configurações de captura adequadas para vídeo de saída e taxas de bits de áudio adequadas para compartilhamento em 3G|
| `medium` | Especifica as configurações de captura adequadas para as taxas de bits de áudio e vídeo de saída adequadas para compartilhamento via WiFi|
| `high` | Especifica as configurações de captura adequadas para saída de áudio e vídeo de alta qualidade |
| `photo` | Especifica as configurações de captura adequadas para saída de qualidade de foto de alta resolução |
| `inputPriority` | Especifica as configurações de captura adequadas para saída de qualidade de foto de alta resolução |
| `hd1280x720` | Especifica as configurações de captura adequadas para saída de vídeo com qualidade de 720p (1280 x 720 pixels)|
| `hd1920x1080` | Configurações de captura adequadas para saída de vídeo com qualidade 1080p (1920 x 1080 pixels)|
| `hd4K3840x2160` | Configurações de captura adequadas para saída de vídeo com qualidade 2160p (3840 x 2160 pixels) |
|

| PassiveFaceLivenessCustomizationIos constructor |
| --------- |
| `String? colorHex`<br><br>Cor tema do SDK. Por exemplo, caso deseje usar a cor preta, utilize "#000000" |
| `String? greenMaskImageName`<br><br>Nome da imagem à substituir a máscara verde padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String? whiteMaskImageName`<br><br>Nome da imagem à substituir a máscara branca padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String? redMaskImageName`<br><br>Nome da imagem à substituir a máscara vermelha padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String? closeImageName`<br><br>Nome da imagem à substituir o botão de fechar o SDK. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `bool? showStepLabel`<br><br>Flag que indica se deseja mostrar o label do passo atual |
| `bool? showStatusLabel`<br><br>Flag que indica se deseja mostrar o label do status atual |
| `double? buttonSize`<br><br>Valor que define o tamanho do botão de "fechar" o SDK |
| `String? buttonContentMode`<br><br>Atributo que define o content mode do botão de "fechar" o SDK. Escolha entre [esses valores](https://docs.combateafraude.com/docs/mobile/flutter/release-notes/#27-de-maio-de-2022). |

| SensorStabilitySettingsIos constructor |
| --------- |
| `String message`<br><br>String à ser mostrada quando o celular não estiver estável |
| `double stabilityThreshold`<br><br>Limiar inferior entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `0.3` m/s² |

### Coletando o resultado

O objeto de retorno do PassiveFaceLiveness é do tipo abstrato `PassiveFaceLivenessResult`. Ele pode ser uma instância de `PassiveFaceLivenessSuccess`, `PassiveFaceLivenessFailure` ou `PassiveFaceLivenessClosed`.

#### PassiveFaceLivenessSuccess

| Campo |
| --------- |
| `String imagePath`<br><br>Endereço completo da imagem no dispositivo |
| `String capturePath`<br><br>Endereço completo do vídeo no dispositivo. Caso o formato de captura não seja por vídeo, o retorno é null |
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
