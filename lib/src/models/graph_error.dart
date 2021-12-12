/// Error object from Facebook.
///
/// See https://developers.facebook.com/docs/ios/errors/.
class GraphError {
  /// An error message for the developer.
  final String? developerMessage;

  /// A localized user facing message, if available
  final String? localizedDescription;

  /// A localized user facing title, if available
  final String? localizedTitle;

  GraphError(
      {this.developerMessage, this.localizedDescription, this.localizedTitle});

  factory GraphError.fromMap(Map<String, dynamic> map) => GraphError(
        developerMessage: map['developerMessage'] as String?,
        localizedDescription: map['localizedDescription'] as String?,
        localizedTitle: map['localizedTitle'] as String?,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'developerMessage': developerMessage,
      'localizedDescription': localizedDescription,
      'localizedTitle': localizedTitle,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GraphError &&
        other.developerMessage == developerMessage &&
        other.localizedDescription == localizedDescription &&
        other.localizedTitle == localizedTitle;
  }

  @override
  int get hashCode =>
      developerMessage.hashCode ^
      localizedDescription.hashCode ^
      localizedTitle.hashCode;

  @override
  String toString() => 'FacebookError(developerMessage: $developerMessage, '
      'localizedDescription: $localizedDescription, '
      'localizedTitle: $localizedTitle)';
}
