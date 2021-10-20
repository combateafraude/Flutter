# [DocumentDetector](https://docs.combateafraude.com/docs/mobile/introduction/home/#documentdetector) - Flutter Plugin

Plugin que chama os SDKs nativos em [Android](https://docs.combateafraude.com/docs/mobile/android/document-detector/) e [iOS](https://docs.combateafraude.com/docs/mobile/ios/document-detector/). Caso tenha alguma dúvida, envie um email para o nosso [Head of Mobile](mailto:daniel.seitenfus@combateafraude.com)

Atualmente, os documentos suportados são RG, CNH, RNE e CRLV. Caso tenha alguma sugestão de outro documento, contate-nos!

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
| Swift               | 5.4    |

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
<string>To read the documents</string>
```

Para habilitar texto e voz em Português, em seu projeto, no diretório ROOTPROJECT/ios, abra o arquivo .xcworkspace no Xcode e adicione em Project > Info > Localizations o idioma Portuguese (Brazil).

### Flutter

Adicione o plugin no seu arquivo `ROOT_PROJECT/pubspec.yaml`:

```yml
dependencies:  
  document_detector:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: document-detector-v4.9.2
```

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
| `.setMessageSettings(MessageSettings messageSettings)`<br><br> Permite personalizar mensagens exibidas no balão de "status" durante o processo de captura e análise. |
| `.setAndroidSettings(DocumentDetectorAndroidSettings androidSettings)`<br><br>Customizações somente aplicadas em Android |
| `.setIosSettings(DocumentDetectorIosSettings iosSettings)`<br><br>Customizações somente aplicadas em iOS |

| DocumentDetectorStep constructor |
| --------- |
| `DocumentType document`<br><br>Documento a ser escaneado neste respectivo passo |
| `DocumentDetectorStepCustomizationAndroid android`<br><br>Customizações visuais do respectivo passo aplicados em Android |
| `DocumentDetectorStepCustomizationIos ios`<br><br>Customizações visuais do respectivo passo aplicados em iOS |

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
        subTitle: "Veja se a foto está nítida",
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
| `String? openDocumentWrongMessage`<br><br>Padrão: "Esse é o {'document'} aberto, você deve fecha-lo"|
| `String? showOpenDocumentMessage`<br><br>Padrão: ""|
| `String? unsupportedDocumentMessage`<br><br>Padrão: "Ops, parece que este documento não é suportado. Contate-nos!"|
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
documentDetector.setShowPreview(showPreview);
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
| `bool enableSwitchCameraButton`<br><br>Permite habilitar ou desabilitar o botão de inversão da câmera. O padrão é `True` |

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
| `String layoutResIdName`<br><br>Nome do layout resource que substituirá o layout padrão do DocumentDetector. Por exemplo, caso deseje mudar o layout do SDK, crie um layout em `ROOT_PROJECT/android/app/src/main/res/layout/my_custom_layout.xml` seguindo o [template](https://gist.github.com/dbseitenfus/8597a31b212360d82a217656c5231aa7) e parametrize "my_custom_layout" |
| `String greenMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara verde padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_green_mask.png` e parametrize "my_custom_green_mask" |
| `String redMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara vermelha padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_red_mask.png` e parametrize "my_custom_red_mask" |
| `String whiteMaskResIdName`<br><br>Nome do drawable resource à substituir a máscara branca padrão. **Caso for usar este parâmetro, use uma máscara com a mesma área de corte, é importante para o algoritmo de detecção**. Por exemplo, salve a imagem da máscara em `ROOT_PROJECT/android/app/src/main/res/drawable/my_custom_white_mask.png` e parametrize "my_custom_white_mask" |

| SensorSettingsAndroid constructor |
| --------- |
| `SensorLuminositySettingsAndroid sensorLuminositySettings`<br><br>Configurações do sensor de luminosidade à ser aplicado em todos os passos do SDK |
| `SensorOrientationSettingsAndroid sensorOrientationSettings`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |
| `SensorStabilitySettingsAndroid sensorStabilitySettings`<br><br>Configurações do sensor de orientação à ser aplicado em todos os passos do SDK |

| SensorLuminositySettingsAndroid constructor |
| --------- |
| `String messageResourceIdName`<br><br>Nome do string resource à ser mostrado quando o ambiente estiver escuro. A mensagem padrão é "Ambiente muito escuro". Por exemplo, caso deseje mostrar a String "Teste", crie uma String em `ROOT_PROJECT/android/app/src/main/res/values/strings.xml` com o nome `R.string.my_custom_luminosity_string` e valor "Teste" e parametrize "my_custom_luminosity_string" |
| `int luminosityThreshold`<br><br>Limiar inferior entre luminosidade aceitável/não aceitável, em lx. O padrão é `5` lx |

| SensorOrientationSettingsAndroid constructor |
| --------- |
| `String messageResourceIdName`<br><br>Nome do string resource à ser mostrado quando o celular não estiver na horizontal. A mensagem padrão é "Celular não está na horizontal". Por exemplo, caso deseje mostrar a String "Teste", crie uma String em `ROOT_PROJECT/android/app/src/main/res/values/strings.xml` com o nome `R.string.my_custom_orientation_string` e valor "Teste" e parametrize "my_custom_orientation_string" |
| `double orientationThreshold`<br><br>Limiar inferior entre orientação correta/incorreta, em variação de m/s² da orientação totalmente horizontal. O padrão é `3` m/s² |

| SensorStabilitySettingsAndroid constructor |
| --------- |
| `String messageResourceIdName`<br><br>Nome do string resource à ser mostrado quando o celular não estiver estável. A mensagem padrão é "Mantenha o celular parado". Por exemplo, caso deseje mostrar a String "Teste", crie uma String em `ROOT_PROJECT/android/app/src/main/res/values/strings.xml` com o nome `R.string.my_custom_stability_string` e valor "Teste" e parametrize "my_custom_stability_string" |
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

| DocumentDetectorCustomizationIos constructor |
| --------- |
| `String colorHex`<br><br>Cor tema do SDK. Por exemplo, caso deseje usar a cor preta, utilize "#000000" |
| `String greenMaskImageName`<br><br>Nome da imagem à substituir a máscara verde padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String whiteMaskImageName`<br><br>Nome da imagem à substituir a máscara branca padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String redMaskImageName`<br><br>Nome da imagem à substituir a máscara vermelha padrão. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `String closeImageName`<br><br>Nome da imagem à substituir o botão de fechar o SDK. Lembre de adicionar a imagem em `Assets Catalog Document` no seu projeto do XCode |
| `bool showStepLabel`<br><br>Flag que indica se deseja mostrar o label do passo atual |
| `bool showStatusLabel`<br><br>Flag que indica se deseja mostrar o label do status atual |

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
