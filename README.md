# Face Authenticator Cs - Flutter Plugin

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Dart                | 2.12+  |
| Android API         | 21+    |
| CompileSdkVersion   | 31+    |

## Configurações

### Android

No arquivo `./android/build.gradle`, adicione:

``` gradle
allprojects {
    repositories {
        ...

        maven { url 'https://repo.combateafraude.com/android/release' }
        maven {
            url  '' //Valor fornecido pela Caf
            name  '' //Valor fornecido pela Caf
            credentials {
                username '' //Valor fornecido pela Caf
                password  '' //Valor fornecido pela Caf
            }
            authentication {
                basic(BasicAuthentication)
            }
        }
    }
}
```


## Flutter

Adicione o plugin no seu arquivo `./pubspec.yaml`:

#### Estável
```yml
dependencies:  
  face_authenticator_cs:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: face-authenticator-cs-v0.0.1
```

### Exemplo

```dart
import 'package:face_authenticator_cs/face_authenticator_cs.dart';

void main() async {
  String clientId = 'your_client_id';
  String clientSecret = 'your_client_secret';
  String token = 'your_token';
  String personId = 'your_person_id';

  FaceAuthenticatorCs faceAuthenticator = FaceAuthenticatorCs(clientId, clientSecret, token, personId);
  FaceAuthenticatorCs result = await faceAuthenticator.start();

  print('isMatch: ${result.isMatch}');
  print('isAlive: ${result.isAlive}');
  print('responseMessage: ${result.responseMessage}');
  print('sessionId: ${result.sessionId}');
}
```

## FaceAuthenticatorCs

A classe `FaceAuthenticatorCs` é usada para configurar e inicializar o SDK.

| Parâmetro | Descrição |
|-----------|-----------|
| `String clientId`<br><br>ClientId fornecido pela Caf. |
| `String clientSecret`<br><br>ClientSecret fornecido pela Caf. |
| `String token`<br><br>Token de acesso para o serviço. |
| `String personId`<br><br>ID da pessoa a ser verificada. |

### Métodos

| Método | Parâmetros | Retorno | Descrição |
|--------|------------|---------|-----------|
| `start()` | - | `Future<FaceAuthenticatorCsResult>`<br><br>Objeto `FaceAuthenticatorCsResult` contendo os resultados da verificação. | Inicia o processo de verificação de prova de vida da face e retorna um objeto `FaceAuthenticatorCsResult` com os resultados. |

### FaceAuthenticatorCsResult

A classe `FaceAuthenticatorCsResult` contém os resultados da verificação de autenticidade da face.

| Propriedade       | Tipo    | Descrição                                                                 |
|-------------------|---------|---------------------------------------------------------------------------|
| `isMatch`         | `bool`  | Indica se a autenticação facial foi bem-sucedida (rosto correspondente). |
| `isAlive`         | `bool`  | Indica se a pessoa é uma pessoa viva (detecção de liveness).             |
| `responseMessage` | `String?` | Mensagem de resposta indicando o resultado da verificação.             |
| `sessionId`       | `String?` | ID da sessão.                                                          |


A variável `responseMessage` conterá a String `Real` em caso de sucesso. Caso ocorra algum erro, a variável poderá conter algum dos seguintes valores: 

| `responseMessage` | Descrição |
|-------------------|-----------|
| `SessionUnsuccessful` | Sessão do usuário não foi bem sucedida |
| `UserCancelled` | Sessão cancelada pelo usuário |
| `UserCancelledViaHardwareButton` | Sessão cancelada pelo usuário que clicou no botão de voltar do Android |
| `SessionCompletedSuccessfully` | Sessão do usuário bem sucedida |
| `CameraPermissionDenied` | Usuário negou a permissão da câmera |
| `Timeout` | Quando o tempo de resposta do servidor é excedido |
| `LandscapeModeNotAllowed` | Quando o celular está em modo landscape |
| `ReversePortraitNotAllowed` | Quando o celular está em modo reverse portrait |
| `EncryptionKeyInvalid` | Sessão cancelada pois a chave é inválida |
| `ContextSwitch` | Quando ocorre uma mudança de contexto durante a sessão |
| `NonProductionModeNetworkRequired` | Sessão cancelada porque uma conexão de rede é necessária em aplicativos que não são de produção |
| `LockedOut` | FaceTec SDK está em um estado de bloqueio |
| `MissingGuidanceImages` | Sessão não completada, pois não tem imagens de orientação |
| `UserCancelledViaClickableReadyScreenSubtext` | Sessão cancelada porque o usuário pressionou a mensagem de subtexto da tela Prepare-se |
| `UnknownError` | Erro desconhecido |
| `ServerError` | Erro no servidor |
| `AuthError` | Erro de autenticação |
| `SessionTokenError` | Token de sessão inválido |
| `GetSessionTokenError` | Erro ao pegar o token de sessão |
| `JsonParseError` | Erro ao ler o Json |
| `ImageCaptureFailed` | Falha na captura da imagem |
| `CameraInitializationIssue` | Erro inesperado da câmera |

