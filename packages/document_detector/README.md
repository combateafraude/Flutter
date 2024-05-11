# [DocumentDetector](https://docs.combateafraude.com/docs/mobile/introduction/home/#documentdetector) - Flutter Plugin

Atualmente, os documentos suportados são RG, CNH, RNE, CRLV, CTPS, Passaporte. Caso tenha alguma sugestão de outro documento, contate-nos!

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Dart                | 2.12+  |
| Android API         | 21+    |
| Compile SDK Version | 30+    |
| iOS                 | 11.0+  |

Caso você utilize Dart em uma versão abaixo de 2.12, confira a versão compatível [aqui](https://github.com/combateafraude/Flutter/tree/document-detector-compatible).

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

    aaptOptions {
        noCompress "tflite"
    }
}

//Para realizar a customização de layout do SDK faça a importação das seguintes bibliotecas
dependencies {
    implementation "androidx.camera:camera-view:1.2.0-alpha02"
    implementation 'com.combateafraude.sdk:document-detector:6.39.0'
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

Por último, adicione as permissões no arquivo `ROOT_PROJECT/ios/Runner/Info.plist`:

```
<key>NSCameraUsageDescription</key>
<string>To read the documents</string>

// Obrigatória somente para o fluxo de upload de documento
<key>NSPhotoLibraryUsageDescription</key>
	<string>To select images</string>
```

Para habilitar texto e voz em Português, em seu projeto, no diretório ROOTPROJECT/ios, abra o arquivo .xcworkspace no Xcode e adicione em Project > Info > Localizations o idioma Portuguese (Brazil).

### Flutter

Adicione o plugin no seu arquivo `ROOT_PROJECT/pubspec.yaml`:

```yml
dependencies:  
  document_detector:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: document-detector-v5.26.0
```

## Desativando validações de segurança para teste
Estamos constantemente realizando ações para tornar o produto cada vez mais seguro, mitigando uma série de ataques observados ao processo de captura e, consequentemente, reduzindo o maior número de possíveis fraudes de identidade. O SDK possui alguns bloqueios que podem impedir a execução em certos contextos. Para desabilitá-los, você pode utilizar os métodos conforme o exemplo abaixo:
``` dart
DocumentDetectorAndroidSettings androidSettings =
        DocumentDetectorAndroidSettings(
          emulatorSettings: true,
          rootSettings: true,
          useDeveloperMode: true,
          useAdb: true,
          useDebug: true,
        );

documentDetector.setAndroidSettings(androidSettings);
```
> <b>Atenção!</b> Desabilitar as validações de segurança são recomendadas <b>apenas para ambiente de testes. </b>Para publicação do seu aplicativo em produção, recomendamos utilizar as configurações padrão.

## Utilização

```dart
DocumentDetector documentDetector = new DocumentDetector(mobileToken: mobileToken);
documentDetector.setDocumentFlow(List<DocumentDetectorStep> documentSteps);

// Outros parâmetros de customização

DocumentDetectorResult documentDetectorResult = await documentDetector.start();

if (documentDetectorResult is DocumentDetectorSuccess) {
  // O SDK foi encerrado com sucesso e as fotos dos documentos foram capturadas
} else if (documentDetectorResult is DocumentDetectorFailure) {
  // O SDK foi encerrado devido à alguma falha e as fotos dos documentos não foram capturadas
} else {
  // O usuário simplesmente fechou o SDK, sem nenhum resultado
}
```

### Customizações gerais

| DocumentDetector |
| --------- |
| `.setPeopleId(String peopleId)`<br><br>CPF do usuário que está utilizando o plugin à ser usado para detecção de fraudes via analytics |
| `.setAnalyticsSettings(bool useAnalytics)`<br><br>Habilita/desabilita a coleta de dados para maximização da informação antifraude. O padrão é `true` |
| `.setDocumentFlow(List<DocumentDetectorStep> documentSteps)`<br><br>Fluxo de documentos à serem capturados no SDK |
| `.setPopupSettings(bool show)`<br><br>Altera a configuração dos popups inflados antes de cada documento. O padrão é `true` |
| `.enableSound(bool enable)`<br><br>Habilita/desabilita os sons. O padrão é `true` |
| `.setNetworkSettings(int requestTimeout)`<br><br>Altera as configurações de rede padrão. O padrão é `60` segundos |
| `.setShowPreview(ShowPreview showPreview)`<br><br> Preview para verificação da qualidade da foto |
| `.setAutoDetection(bool enable)`<br><br>Habilita/desabilita a autodetecção e verificações de sensores. Utilize `false` para desabilitar todas as verificações no dispositivo. Assim, todas validações serão executadas no backend, após a captura. O padrão é `true`|
| `.setCurrentStepDoneDelay(bool showDelay, int delay)`<br><br> Aplica delay na activity após a finalização de cada etapa. Esse método pode ser utilizado para exibir uma mensagem de sucesso na própria tela após a captura, por exemplo. O padrão é `false`|
| `.setMessageSettings(MessageSettings messageSettings)`<br><br> Permite personalizar mensagens exibidas no balão de "status" durante o processo de captura e análise. |
| `.setGetImageUrlExpireTime(String expireTime)`<br><br> Define o tempo de duração da URL da imagem no servidor até ser expirada. Espera receber um intervalo de tempo entre "30m" à "30d". O padrão é `3h` |
| `.setAndroidSettings(DocumentDetectorAndroidSettings androidSettings)`<br><br>Customizações somente aplicadas em Android |
| `.setIosSettings(DocumentDetectorIosSettings iosSettings)`<br><br>Customizações somente aplicadas em iOS |
| `.setUploadSettings(UploadSettings uploadSettings)`<br><br>Define as configurações para o upload de documentos. Ativando esta opção, o fluxo do SDK irá solicitar que o usuário envie os arquivos do documento ao invés de realizar a captura com a câmera do dispositivo. Esta opção também inclui as verificações de qualidade do documento. Por padrão, esta opção de fluxo não está habilitada |

| DocumentDetectorStep constructor |
| --------- |
| `DocumentType document`<br><br>Documento a ser escaneado neste respectivo passo |
| `DocumentDetectorStepCustomizationAndroid android`<br><br>Customizações visuais do respectivo passo aplicados em Android |
| `DocumentDetectorStepCustomizationIos ios`<br><br>Customizações visuais do respectivo passo aplicados em iOS |

| UploadSettings constructor|
| --------- |
| `bool compress`<br><br>Habilita/desabilita a compressão do arquivo antes de realizar o upload. O padrão é `true` |
| `int maxFileSize`<br><br>Define o tamanho máximo em KB do arquivo para upload. O limite padrão é 20000 KB (20MB) |
| `List<String> fileFormats`<br><br>Define o(os) formatos de arquivos que serão aceitos para upload. Por padrão são aceitos: .PDF , .JPG, .JPEG, .PNG, .HEIF |
| `String activityLayout`<br><br>Define o layout de plano de fundo do upload de documentos |
| `String popUpLayout`<br><br>Define o layout do popup de solicitação do documento para upload |

| ShowPreview |
| --------- |
<b>Como Modificar: </b> Caso deseje modificar o texto selecionado, modifique a String com a mensagem que deseja utilizar.|
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
        subtitle: "Veja se a foto está nítida",
        confirmLabel: "Sim, ficou boa!",
        retryLabel: "Tirar novamente");

documentDetector.setShowPreview(showPreview);
```

| MessageSettings |
| --------- |
<b>Como Modificar: </b> Caso deseje modificar o texto selecionado, modifique a String com a mensagem que deseja utilizar.| 
| `String? fitTheDocumentMessage`<br><br>Padrão: "Encaixe o documento na marcação"|
| `String? holdItMessage (somente para Android)`<br><br>Padrão: "Segure assim"|
| `String? verifyingQuality`<br><br>Padrão: "Verificando qualidade…"|
| `String? lowQualityDocument`<br><br>Padrão: "Ops, não foi possível ler as informações. Por favor, tente novamente"|
| `String? uploadingImage`<br><br>Padrão: "Enviando imagem…"|
| `boolean? showOpenDocumentMessage`<br><br>Padrão: `true`|
| `String? openDocumentWrongMessage`<br><br>Padrão: "Esse é o {'document'} aberto, você deve fecha-lo"|
| `String? documentNotFoundMessage`<br><br>Padrão: "Não encontramos um documento"|;
| `String? sensorLuminosityMessage`<br><br>Padrão: "Ambiente muito escuro"|;
| `String? sensorOrientationMessage`<br><br>Padrão: "Celular não está na vertical"|;
| `String? sensorStabilityMessage`<br><br>Padrão: "Mantenha o celular parado"|;
| `String? unsupportedDocumentMessage`<br><br>Padrão: "Ops, parece que este documento não é suportado. Contate-nos!"|
| `String? popupDocumentSubtitleMessage`<br><br>Padrão: "Posicione o documento em uma mesa, centralize-o na marcação e aguarde a captura automática."|
| `String? setPositiveButtonMessage`<br><br>Padrão: "Ok, entendi!"|
| `String? wrongDocumentMessage_RG_FRONT (somente para Android)`<br><br>Padrão: "Ops, esta é a frente do RG"|
| `String? wrongDocumentMessage_RG_BACK (somente para Android)`<br><br>Padrão: "Ops, este é o verso do RG"|
| `String? wrongDocumentMessage_RG_FULL (somente para Android)`<br><br>Padrão: "Ops, este é o RG aberto"|
| `String? wrongDocumentMessage_CNH_FRONT (somente para Android)`<br><br>Padrão: "Ops, esta é a frente da CNH"|
| `String? wrongDocumentMessage_CNH_BACK (somente para Android)`<br><br>Padrão: "Ops, este é o verso da CNH"|
| `String? wrongDocumentMessage_CNH_FULL (somente para Android)`<br><br>Padrão: "Ops, esta é a CNH aberta"|
| `String? wrongDocumentMessage_CRLV (somente para Android)`<br><br>Padrão: "Ops, este é o CRLV"|
| `String? wrongDocumentMessage_RNE_FRONT (somente para Android)`<br><br>Padrão: "Ops, esta é a frente do RNE"|
| `String? wrongDocumentMessage_RNE_BACK (somente para Android)`<br><br>Padrão: "Ops, este é o verso do RNE"|


| Exemplo de uso |
| --------- |
```dart
 MessageSettings messageSettings = new MessageSettings(
      fitTheDocumentMessageResIdName: "Mensagem de exemplo",
      holdItMessageResIdName:"Mensagem de exemplo",
      verifyingQualityMessageResIdName: "Mensagem de exemplo"
      lowQualityDocumentMessageResIdName:"Mensagem de exemplo" ,
      uploadingImageMessageResIdName:"Mensagem de exemplo",
      openDocumentWrongMessage: "Mensagem de exemplo",
      showOpenDocumentMessage: true);
documentDetector.setMessageSettings(messageSettings);
```


#### Android

| DocumentDetectorStepCustomizationAndroid constructor |
| --------- |
| `String stepLabelStringResName`<br><br>Nome do string resource à ser mostrado no label do nome do documento. Por exemplo, caso deseje mostrar a String "Teste", crie uma String em `ROOT_PROJECT/android/app/src/main/res/values/strings.xml` com o nome `R.string.my_custom_string` e valor "Teste" e parametrize "my_custom_string" |
| `String illustrationDrawableResName`<br><br>Nome do drawable resource à ser mostrado no popup de introdução da captura. Por exemplo, caso deseje mostrar uma ilustração customizada, salve-a em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_illustration.png` e parametrize "my_custom_illustration" |
| `String audioRawResName`<br><br>Nome do raw resource à ser executado no início da captura. Por exemplo, caso deseje executar um áudio customizado, salve-o em `ROOT_PROJECT/android/app/src/main/res/raw/my_custom_audio.mp3` e parametrize "my_custom_audio" |

| DocumentDetectorAndroidSettings constructor |
| --------- |
| `DocumentDetectorCustomizationAndroid customization`<br><br>Customização do layout em Android da activity |
| `SensorSettingsAndroid sensorSettings`<br><br>Customização das configurações dos sensores de captura |
| `List<CaptureStage> captureStages`<br><br>Array de estágios para cada captura. Esse parâmetro é útil caso você deseje modificar a maneira com qual o DocumentDetector é executado, como configurações de detecção, captura automática ou manual, verificar a qualidade da foto, etc |
| `Integer compressQuality`<br><br>Permite configurar a qualidade no processo de compressão. Por padrão, todas capturas passam por compressão. O método espera como parâmetro valores entre 50 e 100, sendo 100 a compressão com melhor qualidade (recomendado). O padrão é 100 |
| `bool enableSwitchCameraButton`<br><br>Permite habilitar ou desabilitar o botão de inversão da câmera. O padrão é `True` |
| `Resolution resolution`<br><br>Permite configurar a resolução de captura. O método espera como parâmetro uma Resolution que fornece as opções HD, FULL_HD, QUAD_HD e ULTRA_HD. O padrão é `Resolution.ULTRA_HD` |
| `bool enableGoogleServices`<br><br>Permite habilitar/desabilitar recursos do SDK que consomem GoogleServices no SDK, não recomendamos desabilitar os serviços por conta da perda de segurança. O padrão é `True` |
| `bool enableEmulator`<br><br>Permite o uso de emulador quando `true` |
| `bool enableRootDevices`<br><br>Permite o uso de dispositivos root quando `true` |
 `bool useDebug`<br><br>Habilita/desabilita o uso do app em modo depuração. O padrão é `false` |
 `bool useDeveloperMode`<br><br>Permite habilitar/desabilitar o uso de dispositivos com o modo de desenvolvedor Android ativado. Recomendamos desabilitar o uso desses dispositivos por questões de segurança. O padrão é `false` |
 `bool useDAdb`<br><br>Permite habilitar/desabilitar o uso do modo de depuração Android Debug Bridge (ADB). Recomendamos desabilitar o uso desses dispositivos por questões de segurança. O padrão é `false` |



| CaptureStage constructor |
| --------- |
| `int durationMillis`<br><br>Duração em milissegundos deste respectivo passo antes de passar para o próximo, se houver. `null` para infinito |
| `bool wantSensorCheck`<br><br>Flag que indica se este estágio deve/não deve passar pela validação dos sensores |
| `QualitySettings qualitySettings`<br><br>Configurações de verificação de qualidade do documento. O único parâmetro de `QualitySettings` é o limiar de aceitação da verificação da qualidade, de 1.0 a 5.0, onde 1.8 é o recomendado |
| `DetectionSettings detectionSettings`<br><br>Configurações de detecção do documento pela câmera. Os parâmetros de `DetectionSettings` são, respectivamente, o limiar de aceitação do documento, em um valor de 0.0 a 1.0 com 0.91 de recomendado e a quantidade de frames consecutivos corretos necessários, onde o recomendado é 5 |
| `CaptureMode captureMode`<br><br>Modo de captura da foto. Pode ser `CaptureMode.AUTOMATIC` para a captura automática ou `CaptureMode.MANUAL` para a aparição de um botão para o usuário efetuar a captura |

| DocumentDetectorCustomizationAndroid constructor |
| --------- |
| `String styleResIdName`<br><br>Nome do style resource que define as cores do DocumentDetector. Por exemplo, caso deseje mudar as cores do SDK, crie um style em `ROOT_PROJECT/android/app/src/main/res/values/styles.xml` com o nome `R.style.my_custom_style` seguindo o [template](https://gist.github.com/kikogassen/4b57db7139034ea2e85ea798eb88d248) e parametrize "my_custom_style" |
| `String layoutResIdName`<br><br>Nome do layout resource que substituirá o layout padrão do DocumentDetector. Por exemplo, caso deseje mudar o layout do SDK, crie um layout em `ROOT_PROJECT/android/app/src/main/res/layout/my_custom_layout.xml` seguindo o [template](https://gist.github.com/dbseitenfus/8597a31b212360d82a217656c5231aa7) e parametrize "my_custom_layout". Verifique as importações das bibliotecas mencionadas [aqui](#android) |
| `String greenMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara verde padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_green_mask.png` e parametrize "my_custom_green_mask" |
| `String redMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara vermelha padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_red_mask.png` e parametrize "my_custom_red_mask" |
| `String whiteMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara branca padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_white_mask.png` e parametrize "my_custom_white_mask" |
| `MaskType maskType`<br><br>Define o tipo de máscara utilizada nas capturas. Existem três tipos: `MaskType.DEFAULT`, com o padrão pontilhado no formato do documento; `MaskType.DETAILED`, que apresenta uma ilustração do documento solicitado, junto com a máscara pontilhada; `MaskType.NONE`, que remove totalmente a máscara. O padrão é `MaskType.DEFAULT` |


| SensorSettingsAndroid constructor |
| --------- |
| `SensorLuminositySettingsAndroid sensorLuminositySettings`<br><br>Configurações do sensor de luminosidade à ser aplicado em todos os passos do SDK |
| `SensorOrientationSettingsAndroid sensorOrientationSettings`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |
| `SensorStabilitySettingsAndroid sensorStabilitySettings`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |

| SensorLuminositySettingsAndroid constructor |
| --------- |
| `int luminosityThreshold`<br><br>Limiar inferior entre luminosidade aceitável/não aceitável, em lx. O padrão é `5` lx |

| SensorOrientationSettingsAndroid constructor |
| --------- |
| `double orientationThreshold`<br><br>Limiar inferior entre orientação correta/incorreta, em variação de m/s² da orientação totalmente horizontal. O padrão é `3` m/s² |

| SensorStabilitySettingsAndroid constructor |
| --------- |
| `int stabilityStabledMillis`<br><br>Quantos milissegundos o celular deve se manter no limiar correto para ser considerado estável. O padrão é `2000` ms |
| `double stabilityThreshold`<br><br>Limiar inferior entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `0.5` m/s² |

#### iOS

| DocumentDetectorIosSettings constructor |
| --------- |
| `double detectionThreshold`<br><br>Limiar de aceitação do documento, em um valor de 0.0 a 1.0. O padrão é 0.95 |
| `bool verifyQuality`<br><br>Flag que indica se deseja verificar a qualidade do documento capturado |
| `double qualityThreshold`<br><br>Limiar de aceitação da qualidade, entre 1.0 e 5.0. 1.8 é o recomendado para um futuro OCR |
| `DocumentDetectorCustomizationIos customization`<br><br>Customização visual do DocumentDetector |
| `SensorSettingsIos sensorSettings`<br><br>Configurações personalizadas dos sensores em iOS, null para desabilitar |
| `Bool enableManualCapture`<br><br>Habilita modo de captura manual |
| `double timeEnableManualCapture`<br><br>Tempo para habilitar o botão de captura manual |
| `double compressQuality`<br><br>Permite configurar a qualidade no processo de compressão. Por padrão, todas capturas passam por compressão. O método espera como parâmetro valores entre 0 e 1.0, sendo 1.0 a compressão com melhor qualidade (recomendado).O padrão é 1.0 |
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

| DocumentDetectorCustomizationIos constructor |
| --------- |
| `String colorHex`<br><br>Cor tema do SDK. Por exemplo, caso deseje usar a cor preta, utilize "#000000" |
| `String greenMaskImageName`<br><br>Nome da imagem à substituir a máscara verde padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String whiteMaskImageName`<br><br>Nome da imagem à substituir a máscara branca padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String redMaskImageName`<br><br>Nome da imagem à substituir a máscara vermelha padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String closeImageName`<br><br>Nome da imagem à substituir o botão de fechar o SDK. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `bool showStepLabel`<br><br>Flag que indica se deseja mostrar o label do passo atual |
| `bool showStatusLabel`<br><br>Flag que indica se deseja mostrar o label do status atual |
| `double? buttonSize`<br><br>Valor que define o tamanho do botão de "fechar" o SDK |
| `String? buttonContentMode`<br><br>Atributo que define o content mode do botão de "fechar" o SDK. Escolha entre [esses valores](https://docs.combateafraude.com/docs/mobile/flutter/release-notes/#27-de-maio-de-2022). |

| SensorSettingsIos constructor |
| --------- |
| `SensorLuminositySettingsIos sensorLuminosity`<br><br>Configurações do sensor de luminosidade à ser aplicado em todos os passos do SDK |
| `SensorOrientationSettingsIos sensorOrientation`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |
| `SensorStabilitySettingsIos sensorStability`<br><br>Configurações do sensor de estabilidade à ser aplicado em todos os passos do SDK |

| SensorLuminositySettingsIos constructor |
| --------- |
| `String message`<br><br>String à ser mostrada quando o ambiente estiver escuro |
| `double luminosityThreshold`<br><br>Limiar inferior entre luminosidade aceitável/não aceitável. O padrão é `-3` |

| SensorOrientationSettingsAndroid constructor |
| --------- |
| `String message`<br><br>String à ser mostrada quando o celular não estiver na horizontal |
| `double orientationThreshold`<br><br>Limiar inferior entre orientação correta/incorreta. O padrão é `0.3` |

| SensorStabilitySettingsAndroid constructor |
| --------- |
| `String message`<br><br>String à ser mostrada quando o celular não estiver estável |
| `double stabilityThreshold`<br><br>Limiar inferior entre estável/instável, em variação de m/s² entre as últimas duas coletas do sensor. O padrão é `0.3` m/s² |

### Coletando o resultado

O objeto de retorno do DocumentDetector é do tipo abstrato `DocumentDetectorResult`. Ele pode ser uma instância de `DocumentDetectorSuccess`, `DocumentDtetectorFailure` ou `DocumentDetectorClosed`.

#### DocumentDetectorSuccess

| Campo | Observação |
| --------- | --------- |
| `List<Capture> captures`<br><br>Lista de capturas dos documentos | Terá o mesmo tamanho e a mesma ordem do parâmetro `List<DocumentDetectorStep>` |
| `String type`<br><br>Tipo de documento detectado pelo próprio SDK, util para a integração com nossa rota externa de OCR. Por exemplo, se você capturar `DocumentType.CNH_FRONT` e `DocumentType.CNH_BACK`, este parâmetro será "cnh" | Será nulo se o SDK não conseguir verificar o tipo do documento ou se a detecção for desabilitada |
| `String trackingId`<br><br>Identificador dessa execução em nossos servidores. Se possível, salve este campo e mande-o junto para nossa API. Assim, teremos mais dados de como o usuário se comportou durante a execução | Será nulo se o usuário configurar useAnalytics = false ou as chamadas de analytics não funcionarem |

##### Capture

| Campo | Observação |
| --------- | --------- |
| `String imagePath`<br><br>Endereço completo da imagem no dispositivo | - |
| `String imageUrl`<br><br>URL da imagem armazenada temporariamente nos servidores da CAF | Será nulo se o SDK não conseguir verificar a qualidade ou se a mesma estiver desabilitada |
| `String label`<br><br>Label de detecção da captura. Por exemplo, se a captura for referente a um `DocumentType.RG_FRONT`, este label pode ser "rg_front" ou "rg_new_front", que se refere aos novos modelos de RG | Será nulo se a foto for coletada em um estágio onde a detecção está desativada |
| `double quality`<br><br>Qualidade da foto do documento, em um valor de 1.0 a 5.0 | Será nulo se a foto for coletada em um estágio onde a verificação de qualidade está desativada |

#### DocumentDtetectorFailure

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

[Clique aqui](https://github.com/combateafraude/Flutter/tree/ios-customization-example) e acesse um exemplo com um guia para utilização desse recurso.
