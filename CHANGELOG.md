# Release Notes

## Version 3.1.2 (December, 07 2023)

#### Android

- **New**: New `.setImageUrlExpirationTime(String time)` Used to customize the image url expiration time.
- **Enhancement**: Update iProov version from 8.5.0 to 9.0.2. This release includes all the features and fixes from the 9.0.2 version.

#### iOS

- **New**: New `.setImageUrlExpirationTime(String time)` Used to customize the image url expiration time.

## Version 3.0.0 (November, 14 2023)

### :wrench: Refactoring

#### :warning: **Breaking Changes** :warning:

- **Android & iOS Native Bridge**: The Android bridge has been refactored with Kotlin for enhanced performance and compatibility.

- **`PassiveFaceLiveness` to `FaceLiveness`**: We've revamped the `PassiveFaceLiveness` to a more streamlined `FaceLiveness` Dart class. This new class communicates seamlessly with the updated native bridges, ensuring a smoother integration experience.

- **`PassiveFaceLivenessResult` to `FaceLivenessEvent`**: To provide you with more insightful SDK events, we've transformed the `PassiveFaceLivenessResult` into `FaceLivenessEvent`. This change enhances the clarity and effectiveness of event handling.

### :bookmark_tabs: Documentation Updates

- **Integration Guidelines**: The documentation has been updated to reflect the changes in the SDK. Find comprehensive details on how to seamlessly integrate your applications with the latest version, ensuring a smooth transition and optimal performance.

## Version 2.0.3 (October, 27 2023)

#### Android

- **Fix**: Loading screen activity

## Version 2.0.2 (October, 26 2023)

#### Android

- **Fix**: Loading screen when network error occurs

#### iOS

- **Change**: Iproov update version and Starscream removed

## Version 2.0.1 (October, 10 2023)

- **Fix**: Apple updates improvements

## Version 2.0.0 (September, 15 2023)

- **Change**: New parameters to `PassiveFaceLivenessFailure` object
- **New**: Register fail attempts
- **New**: Adding loading screens

## Version 1.2.2 (August, 25 2023)

- **Fix**: Starscream update.

## Version 1.2.1 (August, 18 2023)

- **Fix**: Android SDK customizations.

## Version 1.2.0 (August, 18 2023)

- **new**: New method .setCameraFilter(String filter) to change the SDK camera filter type - Android & iOS
- **new**: New method .setEnableScreenshots(bool enable) to enable screenshots during the SDK scan - Android

## Version 1.1.2 (August, 02 2023)

- **Fix**: Fix Documentation erros.

## Version 1.1.1 (August, 02 2023)

- **Fix**: Fix on the android return of the SDK, it was returning null results in some scenarios.

## Version 1.1.0 (July, 17 2023)

- **Change**: Now the SDK's return a signed respose in case of success, you must access the parameter `signedResponse` in the `PassiveFaceLivenessSuccess` object.

## Version 1.0.0 (July, 03 2023)

- **New**: Hello World!!, first publish version.