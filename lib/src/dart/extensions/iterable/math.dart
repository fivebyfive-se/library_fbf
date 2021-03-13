import '../_helper.dart';

import 'generic.dart';

extension FbfIterableExtensionsNum on Iterable {
  T randomElement<T>()
    => this.elementAt(FbfExtensionsHelper.rng.nextInt(length));

  /// Get average value of iterable of numbers
  double avg<T extends num>()
    => sum<T>() / length.toDouble();

  /// Get maximum value from iterable of numbers
  T max<T extends num>()
    => mapReduce<T,T>((p, c, _) => p == null || c > p ? c : p);


  /// Get minimum value from iterable of numbers
  T min<T extends num>()
    => mapReduce<T,T>((p, c, _) => p == null || c < p ? c : p);


  /// Get sum of iterable of numbers
  T sum<T extends num>()
    => mapReduce<num,num>((p, c, _) => p + c, 0) as T;
}
