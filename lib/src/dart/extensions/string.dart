
const Pattern whitespaceRexPattern = r'^\s+$';

extension FbfStringExtensions on String {
  /// Returns true if this string consists only of
  /// whitespace characters
  bool isWhitespace() 
    => RegExp(whitespaceRexPattern).hasMatch(this);

  /// If this is null, an empty string or only whitespace
  bool isFalsy() => this == null || this == "" || this.isWhitespace();

  /// if !falsy
  bool isTruthy() => !this.isFalsy();

  /// add [suffix] to the end of this string
  String append(String suffix)  => this + suffix;

  /// Add [prefix] to the start of this string
  String prepend(String prefix) => prefix + this;

  /// Truncate this string at [maxLength] characters
  String truncate({int maxLength = 50, String ellipsis = "..."}) {
    if (this != null && this.length >= maxLength) {
      final keepLength = maxLength - ellipsis.length;
      return this.substring(0, keepLength).append(ellipsis);
    }
    return this;
  }
}