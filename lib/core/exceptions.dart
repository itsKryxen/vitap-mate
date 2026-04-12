class FeatureDisabledException implements Exception {
  final String message;
  FeatureDisabledException([this.message = 'Invalid user input']);
  @override
  String toString() => 'FeatureDisabledException: $message';
}

class DiscontinuedException implements Exception {
  final String message;
  const DiscontinuedException(this.message);

  @override
  String toString() => 'DiscontinuedException: $message';
}

class GoogleReauthRequiredException implements Exception {
  final String message;
  final Object? cause;

  const GoogleReauthRequiredException(this.message, {this.cause});

  @override
  String toString() =>
      'GoogleReauthRequiredException: $message${cause == null ? '' : ' ($cause)'}';
}
