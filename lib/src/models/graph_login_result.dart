import 'package:graph_login/src/models/graph_access_token.dart';
import 'package:graph_login/src/models/graph_error.dart';

/// Login status.
enum GraphLoginStatus { success, cancel, error }

/// Result for login request.
class GraphLoginResult {
  final GraphLoginStatus status;
  final GraphAccessToken? accessToken;
  final GraphError? error;

  GraphLoginResult(this.status, GraphAccessToken this.accessToken,
      {this.error});

  GraphLoginResult.error({this.error})
      : status = GraphLoginStatus.error,
        accessToken = null;

  GraphLoginResult.fromMap(Map<String, dynamic> map)
      : status = _parseStatus(map['status'] as String),
        accessToken = map['accessToken'] != null
            ? GraphAccessToken.fromMap(
                (map['accessToken'] as Map).cast<String, dynamic>())
            : null,
        error = map['error'] != null
            ? GraphError.fromMap(
                (map['error'] as Map).cast<String, dynamic>())
            : null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status.toString().split('.').last,
      'accessToken': accessToken,
      'error': error?.toMap(),
    };
  }

  static GraphLoginStatus _parseStatus(String status) {
    switch (status) {
      case 'Success':
        return GraphLoginStatus.success;
      case 'Cancel':
        return GraphLoginStatus.cancel;
      case 'Error':
        return GraphLoginStatus.error;
    }

    throw StateError('Invalid status: $status');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GraphLoginResult &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          accessToken == other.accessToken &&
          error == other.error;

  @override
  int get hashCode =>
      status.hashCode ^ (accessToken?.hashCode ?? 0) ^ (error?.hashCode ?? 0);

  @override
  String toString() =>
      'FacebookLoginResult(status: $status, accessToken: $accessToken, '
      'error: $error)';
}
