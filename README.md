# customization_ios_example

Esse repositório apresenta a implementação de um exemplo com a customização de view em SDK's iOS. Para executar o exemplo, informe o [mobile token](https://docs.combateafraude.com/docs/mobile/introduction/mobile-token/) em `lib/main.dart`.

## Informações inicias

1. Para customização iOS, é necessário que os plugins Flutter estejam adicionados localmente no projeto.
2. A customizção é realizada nativamente com a abordagem ViewCode.
3. Esse exemplo utiliza `document_detector` como base, mas os passos são os mesmos para `passive_face_liveness`.

## Customizando

1. Na pasta root do projeto, crie o diretório `document_detector`
2. Realize o download dos arquivos dos pacotes a serem utilizados em https://github.com/combateafraude/Flutter e insira em seu respectivo repositório
3. Declare o pacote como uma [dependência local](https://flutter.dev/docs/development/packages-and-plugins/using-packages#dependencies-on-unpublished-packages) e execute `flutter pub get`
```yml
dependencies:  
  document_detector:
    path: ./document_detector
```
4. No diretório `document_detector/ios/Classes` crie o arquivo `DocumentDetectorOverlay.swift` (o nome é opcional) e siga o guia nativo para customização https://docs.combateafraude.com/docs/mobile/ios/customization/

5. No arquivo `SwiftDocumentDetectorPlugin` em `document_detector/ios/Classes`, descomente a `linha 213` que realiza a vinculação da classe utilizada para personalização no builder.

6. Por último, caso seja necessário, execute o comando `pod install` em `ROOT_PROJECT/ios/`. 