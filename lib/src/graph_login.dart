import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'models/graph_access_token.dart';
import 'models/graph_login_result.dart';
import 'models/graph_permission.dart';
import 'models/graph_user_profile.dart';

/// Class for implementing login via Facebook.
class GraphLogin {
  // Methods
  static const _methodLogIn = 'logIn';
  static const _methodExpressLogIn = 'expressLogin';
  static const _methodLogOut = 'logOut';
  static const _methodGetAccessToken = 'getAccessToken';
  static const _methodGetUserProfile = 'getUserProfile';
  static const _methodGetUserEmail = 'getUserEmail';
  static const _methodGetProfileImageUrl = 'getProfileImageUrl';
  static const _methodGetSdkVersion = 'getSdkVersion';
  static const _methodSetAppId = 'setAppId';

  static const _permissionsArg = 'permissions';
  static const _appIdArg = 'appIdArg';

  static const _widthArg = 'width';
  static const _heightArg = 'height';

  static const _channel = MethodChannel('graph_login');

  /// If `true` all requests and results will be printed in console.
  late final bool debug;
  /// Initialize with Facebook App ID
  late final String appId;

  GraphLogin({this.debug = false, required this.appId}) {
    if (debug) sdkVersion.then((v) => _log('SDK version: $v'));

    setAppId(appId: appId);
  }

  Future<GraphAccessToken?> get accessToken async {
    final tokenData = await _channel.invokeMethod<Map>(_methodGetAccessToken);

    return tokenData != null
        ? GraphAccessToken.fromMap(tokenData.cast<String, dynamic>())
        : null;
  }

  /// Returns currently used Facebook SDK.
  Future<String> get sdkVersion async {
    final res = await _channel.invokeMethod<String>(_methodGetSdkVersion);
    return res ?? 'n/a';
  }

  Future<bool> get isLoggedIn async {
    final token = await accessToken;
    return _isLoggedIn(token);
  }

  /// Set Application ID.
  Future<void> setAppId({String? appId}) {
    if (debug) _log('Set App ID: $appId');

    if (appId != null) {
      return _channel.invokeMethod(_methodSetAppId, {_appIdArg: appId});
    }

    return Future.value();
  }

  /// Get user profile information.
  ///
  /// If not logged in or error during request than return `null`.
  Future<GraphUserProfile?> getUserProfile() async {
    if (await isLoggedIn == false) {
      if (debug) _log('Not logged in. User profile is null');
      return null;
    }

    try {
      final profileData =
      await _channel.invokeMethod<Map>(_methodGetUserProfile);

      if (debug) _log('User profile: $profileData');

      if (profileData != null) {
        return GraphUserProfile.fromMap(profileData.cast<String, dynamic>());
      }
    } on PlatformException catch (e) {
      if (debug) _log('Get profile error: $e');
    }
    return null;
  }

  /// Get user profile image url.
  ///
  /// If not logged in or error during request than return `null`.
  ///
  /// [width] of picture is required, but [height] is optional,
  /// and by default is equals to [widht].
  Future<String?> getProfileImageUrl({required int width, int? height}) async {
    if (await isLoggedIn == false) {
      if (debug) _log('Not logged in. Profile image url is null');
      return null;
    }

    try {
      final url = await _channel.invokeMethod<String>(
        _methodGetProfileImageUrl,
        {
          _widthArg: width,
          _heightArg: height ?? width,
        },
      );

      if (debug) _log('Profile image url: $url');

      return url;
    } on PlatformException catch (e) {
      if (debug) _log('Get profile image url error: $e');
    }

    return null;
  }

  /// Get user email.
  ///
  /// Attention! User need to be logged in with
  /// accepted [FacebookPermission.email] permission.
  ///
  /// If not logged in, decline [FacebookPermission.email] permission
  /// or error during request occured, than returns `null`.
  Future<String?> getUserEmail() async {
    final token = await accessToken;
    if (!_isLoggedIn(token)) {
      if (debug) _log('Not logged in. Email is null');
      return null;
    }

    if (!token!.permissions.contains(GraphPermission.email.name)) {
      if (debug) _log('User did not accept `email` permission. Email is null');
      return null;
    }

    try {
      final email = await _channel.invokeMethod<String>(_methodGetUserEmail);

      if (debug) _log('User email: $email');
      return email;
    } on PlatformException catch (e) {
      if (debug) _log('Get user email error: $e');
    }
    return null;
  }

  /// Start log in Facebook process.
  ///
  /// [permissions] Array of read permissions. Default: `[FacebookPermission.publicProfile]`
  /// If required permission is not in enum [FacebookPermission], than use [customPermissions].
  Future<GraphLoginResult> logIn(
      {List<GraphPermission> permissions = const [
        GraphPermission.publicProfile
      ],
        List<String> customPermissions = const []}) async {
    final permissionsArg = permissions.map((e) => e.name).toList();
    if (customPermissions.isNotEmpty) permissionsArg.addAll(customPermissions);

    if (debug) _log('Log In with permissions $permissionsArg');
    return _invokeLoginMethod(_methodLogIn, {_permissionsArg: permissionsArg});
  }

  /// Start Express log in Facebook process
  ///
  /// Express Login is an **[Android only option](https://developers.facebook.com/docs/facebook-login/android/#expresslogin)**
  ///
  /// If Login is successful, returns [FacebookLoginResult] with Success Status.
  /// ```
  /// var fbUser = await FacebookLogin().expressLogin();
  /// ```
  Future<GraphLoginResult> expressLogin() async {
    assert(Platform.isAndroid);
    if (debug) _log('Trying to expressLogin');
    return _invokeLoginMethod(_methodExpressLogIn);
  }

  Future<void> logOut() {
    if (debug) _log('Log Out');
    return _channel.invokeMethod(_methodLogOut);
  }

  bool _isLoggedIn(GraphAccessToken? token) =>
      token != null && DateTime.now().isBefore(token.expires);

  Future<GraphLoginResult> _invokeLoginMethod(String method,
      [Map<String, Object>? arguments]) async {
    final loginResultData =
    await _channel.invokeMethod<Map>(_methodLogIn, arguments);

    if (debug) _log('Result: $loginResultData');
    return loginResultData != null
        ? GraphLoginResult.fromMap(loginResultData.cast<String, dynamic>())
        : GraphLoginResult.error();
  }

  void _log(String message) {
    if (debug) debugPrint('[FB] $message');
  }
}
