# [AddressCheck](https://docs.combateafraude.com/docs/mobile/introduction/home/#addresscheck) - Flutter Plugin

Plugin que chama os SDKs nativos em [Android](https://docs.combateafraude.com/docs/mobile/android/address-check/) e [iOS](https://docs.combateafraude.com/docs/mobile/ios/address-check/). Caso tenha alguma dúvida, envie um email para o nosso [Head of Mobile](mailto:daniel.seitenfus@combateafraude.com)

# Políticas de privacidade e termos e condições de uso

Ao utilizar nosso plugin, certifique-se que você concorda com nossas [Políticas de privacidade](https://www.combateafraude.com/politicas/politicas-de-privacidade) e nossos [Termos e condições de uso](https://www.combateafraude.com/politicas/termos-e-condicoes-de-uso).

## Pré requisitos

| Configuração mínima | Versão |
| ------------------- | ------ |
| Flutter             | 1.12+  |
| Android API         | 21+    |
| iOS                 | 11.0+  |
| Swift               | 5      |
| XCode               | 9.0+   |
| CocoaPods           | 1.2.0+ |

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
	<key>NSLocationWhenInUseUsageDescription</key>
	<string></string>
	<key>NSLocationUsageDescription</key>
	<string></string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string></string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string></string>
```

### Permissões

Para o funcionamento correto, o seu aplicativo Flutter deve solicitar a permissão `locationAlways` em tempo de execução. 

### Flutter

Adicione o plugin no seu arquivo `ROOT_PROJECT/pubspec.yaml`:

```yml
dependencies:  
  address_check:
    git:
      url: https://github.com/combateafraude/Flutter.git
      ref: address-check-v1.0.0
```

## Utilização

```dart
AddressCheck addressCheck = new AddressCheck(mobileToken: mobileToken);

Address address = new Address(locale: new Locale("pt", "BR"));
address.setCountryName(mCountryName);
address.setCountryCode(mCountryCode);
address.setAdminArea(mAdminArea);
address.setSubAdminArea(mSubAdminArea);
address.setLocality(mLocality;
address.setSubLocality(mSubLocality);
address.setThoroughfare(mThoroughfare);
address.setSubThoroughfare(mSubThoroughfare);
address.setPostalCode(mPostalCode);

addressCheck.setAddress(address);
addressCheck.setPeopleId(cpf);

// Inicializando SDK e registrando endereço
AddressCheckResult addressCheckResult = await addressCheck.start();
    if (addressCheckResult.success) {
      // O SDK registrou o endereço com sucesso
    }else{
      // O SDK foi encerrado devido à alguma falha
    }
```

### Customizações gerais

| PassiveFaceLiveness |
| --------- |
| `.setPeopleId(String peopleId)`<br><br>CPF do usuário que está utilizando o plugin à ser usado para detecção de fraudes via analytics |
| `.setAnalyticsSettings(bool useAnalytics)`<br><br>Habilita/desabilita a coleta de dados para maximização da informação antifraude. O padrão é `true` |
| `.setNetworkSettings(int requestTimeout)`<br><br>Altera as configurações de rede padrão. O padrão é `60` segundos |

### Definição de endereço

| Address |
| --------- |
| `.setCountryName()`<br><br>Nome do país	"Brasil" |
| `.setCountryCode()`<br><br>Código do país	"BR"|
| `.setAdminArea()`<br><br>Estado	"Rio Grande do Sul"|
| `.setSubAdminArea()`<br><br>Região do estado	"Porto Alegre"|
| `.setLocality()`<br><br>Cidade	"Porto Alegre"|
| `.setSubLocality()`<br><br>Bairro	"Azenha"|
| `.setThoroughfare()`<br><br>Rua/Av.	"Av. Azenha"|
| `.setSubThoroughfare()`<br><br>Número	"200"|
| `.setPostalCode()`<br><br>CEP	"51110-100"|

## Verificando o status da validação do endereço

Confira [aqui](https://docs.combateafraude.com/docs/mobile/android/address-check/#body).



















