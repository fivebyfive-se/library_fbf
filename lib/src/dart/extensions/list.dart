
extension FbfListExtensions on List {
  /// Remove and return first value, or [orElse]
  T unshiftOr<T>(T orElse) 
    => this.isEmpty ? orElse : this.removeFirst<T>();


  /// Remove and return last value, or [orElse]
  T popOr<T>(T orElse)
    => this.isEmpty ? orElse : this.removeLast() as T;


  /// Shorthand for removeAt(0)
  T removeFirst<T>() 
    => this.removeAt(0) as T;
}
