part of document_detector_sdk;

class DocumentDetector {
  static Map<String, dynamic> _params = {};
  final bool uploadImages;

  DocumentDetector.builder(
      {@required String mobileToken,
      @required DocumentType documentType,
      this.uploadImages = false})
      : assert(mobileToken != null),
        assert(documentType != null) {
    _params['mobileToken'] = mobileToken;
    _params['documentType'] = documentType.code;
  }

  /// replace default SDK Mask
  void setAndroidMask(
      {String drawableGreenName,
      String drawableWhiteName,
      String drawableRedName}) {
    if (drawableGreenName != null) _params['setGreenMask'] = drawableGreenName;
    if (drawableWhiteName != null) _params['setWhiteMask'] = drawableWhiteName;
    if (drawableRedName != null) _params['setRedMask'] = drawableRedName;
  }

  /// replace the SDK layout with yours with the respectively template : https://gist.github.com/kikogassen/62068b6e5bc7988d28594d833b125519
  void setAndroidLayout(String layoutName) {
    _params['setLayout'] = layoutName;
  }

  /// set the SDK color style for Android
  void setAndroidStyle(String styleName) {
    _params['setStyle'] = styleName;
  }

  /// set the SDK color style for iOS
  void setIOSColorTheme(Color color) {
    _params['colorTheme'] = '#${color.value.toRadixString(16)}';
  }

  /// Show/hides the step label
  void setIOSShowStepLabel(bool show) {
    _params['showStepLabel'] = show;
  }

  /// Show/hides the status label
  void setIOSShowStatusLabel(bool show) {
    _params['showStatusLabel'] = show;
  }

  /// Sets some layout options to customize the screen.
  void setIOSSLayout(DocumentDetectorLayout layout) {
    _params['layout'] = layout.toMap();
  }

  /// Enables/disables the sound and sound icon
  void hasSound(bool hasSound) {
    _params['hasSound'] = hasSound;
  }

  /// Sets the server request timeout. The default is 15 seconds
  void setRequestTimeout(int requestTimeout) {
    _params['requestTimeout'] = requestTimeout;
  }

  Future<DocumentDetectorResult> build() async {
    final response = await DocumentDetectorSdk._messageChannel
        .invokeMethod('getDocuments', _params);
    if (response.containsKey('success') && response['success']) {
      if (!uploadImages) {
        return DocumentDetectorResult(
            type: response['capture_type'],
            captureFront: Capture(
                imagePath: response['captureFront_imagePath'],
                missedAttemps: response['captureFront_missedAttemps']),
            captureBack: Capture(
                imagePath: response['captureBack_imagePath'],
                missedAttemps: response['captureBack_missedAttemps']));
      } else {
        try {
          print('${DateTime.now().toLocal()} - Obtendo url Front');
          final ImageResponse urlFront = await getUrlImage();
          print(urlFront.toString());

          final captureFront = Capture(
              imagePath: response['captureFront_imagePath'],
              imageUrl: urlFront.getUrl,
              missedAttemps: response['captureFront_missedAttemps']);

          print('${DateTime.now().toLocal()} - Enviando imagens Front');
          await sendImageToAPI(
              imageResponse: urlFront,
              imagePath: response['captureFront_imagePath']);
          print('${DateTime.now().toLocal()} - Front enviado com sucesso');

          print('${DateTime.now().toLocal()} - Obtendo url Back');
          final ImageResponse urlBack = await getUrlImage();
          print(urlBack.toString());

          final captureBack = Capture(
              imagePath: response['captureBack_imagePath'],
              imageUrl: urlBack.getUrl,
              missedAttemps: response['captureBack_missedAttemps']);
          print('${DateTime.now().toLocal()} - Enviando imagens Back');
          await sendImageToAPI(
              imageResponse: urlBack,
              imagePath: response['captureBack_imagePath']);
          print('${DateTime.now().toLocal()} - Back enviado com sucesso');

          return DocumentDetectorResult(
              type: response['capture_type'],
              captureFront: captureFront,
              captureBack: captureBack);
        } catch (error) {
          return DocumentDetectorResult(
              sdkFailure: (SDKFailure(
                  'Falha ao realizar upload das imagens: ${error.toString()}')));
        }
      }
    } else if (response.containsKey('success') && !response['success']) {
      if (response.containsKey('cancel')) {
        return DocumentDetectorResult(
            sdkFailure: (SDKFailure('Cancelado pelo usuário')));
      }
      switch (response['errorType']) {
        case 'InvalidTokenReason':
          return DocumentDetectorResult(
              sdkFailure: InvalidTokenReason(response['errorMessage']));
          break;
        case 'PermissionReason':
          return DocumentDetectorResult(
              sdkFailure: PermissionReason(response['errorMessage']));
          break;
        case 'NetworkReason':
          return DocumentDetectorResult(
              sdkFailure: NetworkReason(response['errorMessage']));
          break;
        case 'ServerReason':
          return DocumentDetectorResult(
              sdkFailure: ServerReason(
                  response['errorMessage'], response['errorCode']));
          break;
        case 'StorageReason':
          return DocumentDetectorResult(
              sdkFailure: StorageReason(response['errorMessage']));
          break;
        case 'LibraryReason':
          return DocumentDetectorResult(
              sdkFailure: LibraryReason(response['errorMessage']));
          break;
        default:
          return DocumentDetectorResult(
              sdkFailure: (SDKFailure(response['errorMessage'])));
      }
    }
  }

  Future<ImageResponse> getUrlImage() async {
    final endpointURL = 'https://api.combateafraude.com/image-upload';
    try {
      Response response = await Dio().post(endpointURL);

      if (response.statusCode != 200) {
        throw ("Erro ao chamar image-upload: ${response.statusMessage}");
      }

      return ImageResponse(
        getUrl: response.data["body"]["getUrl"],
        uploadUrl: response.data["body"]["uploadUrl"],
      );
    } catch (e) {
      throw ("Erro ao chamar image-upload: ${e.toString()}");
    }
  }

  Future<void> sendImageToAPI(
      {@required ImageResponse imageResponse, String imagePath}) async {
    try {
      // read image bytes from disk as a list
      List<int> imageBytes = File(imagePath).readAsBytesSync();
      String imageString = base64Encode(imageBytes);

      Response response = await Dio()
          .put(imageResponse.uploadUrl, data: {"image": imageString});

      if (response.statusCode != 200) {
        throw ("Erro ao enviar para image-upload: ${response.statusMessage}");
      }

      return;
    } catch (error) {
      throw ("Erro ao enviar para image-upload: ${error.toString()}");
    }
  }
}
