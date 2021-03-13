import 'dart:math' as math;

import '../../models/tuple.dart';

typedef MapFunc<T,V> = V Function(T item);
typedef MapIndexFunc<T,V> = V Function(T item, int idx); 
typedef MapReduceFunc<T,V> = V Function(V prev, T curr, int idx);
typedef CompFunc<T> = int Function(T a, T b);

extension FbfIterableExtensionsGeneric on Iterable {
  /// Return a new iterable of unique items
  Iterable<T> distinctBy<T,V>(MapFunc<T,V> selector) sync* {
    final values = Set<V>();

    for (T item in this) {
      final v = selector(item);
      if (!values.contains(v)) {
        values.add(v);
        yield item;
      }
    }
  }


  /// Get a slice of this iterable from [start] to [len],
  /// filling out with [val] (or this.last) if this iterable is shorter
  /// than [len]
  Iterable<T> extend<T>(int len, [T val, int start = 0]) sync* {
    if (start < this.length) {
      yield len >= this.length ? (val ?? this.last) : this.elementAt(len);
      yield* extend<T>(len, val, start + 1);
    }
  }


  /// Map iterable to an iterable of map entries, where each items
  /// index is the key
  Iterable<MapEntry<int,T>> indexEntries<T>([int start = 0]) sync* {
    yield* mapIndex<T,MapEntry<int,T>>(
      (item, idx) => MapEntry<int,T>(idx, item),
      start
    );
  }

  /// Get an iterable of ratios representing positions within
  /// this iterable
  Iterable<double> indicesToRatios([int start = 0]) sync* {
    if (start < length) {
      yield start == 0 ? 0.0 : (start + 1) / length;
      yield* indicesToRatios(start + 1);
    }
  }


  /// like [map], except also supplies index to callback
  Iterable<V> mapIndex<T,V>(MapIndexFunc<T,V> f, [int start = 0]) sync* {
    if (start < length) {
      yield f.call(this.elementAt(start), start);
      yield* mapIndex<T,V>(f, start + 1);
    }
  }


  /// MapReduce with running reduction, or something like that.
  Iterable<Tuple3<V,T,int>> mapReduceIterable<T,V>(
    MapReduceFunc<T,V> f, [
      V inval,
      int start = 0
  ]) sync* {
    if (start < length) {
      final current = elementAt(start);
      final result = f.call(inval, current, start);

      yield Tuple3<V,T,int>(result, current, start);
      yield* mapReduceIterable<T,V>(f, result, start+1);
    }
  }


  /// More javascripty reduce
  V mapReduce<T,V>(MapReduceFunc<T,V> f, [V inval])
    => mapReduceIterable<T,V>(f, inval).last.item1;


  /// Map and call to list, ensuring casts to right types
  List<V> mapToList<T,V>(MapFunc<T,V> f)
    => this.map<V>((item) => f.call(item)).toListOf<V>();
    

  /// Sort iterable, returning result as a list
  List<T> order<T>(CompFunc<T> f)
    => (
     this.toListOf<T>()
        ..sort(f)
      ).toList();


  /// Decorate, sort, undecorate
  List<T> schwartz<T,D>({MapFunc<T,D> decorator, CompFunc<D> comparer}) => (
    this.toListOf<T>()
      .mapToList<T,Tuple2<T,D>>((v) => Tuple2<T,D>(v, decorator.call(v)))
        ..sort((a,b) => comparer.call(a.item2, b.item2))
    ).mapToList<Tuple2<T,D>,T>((t) => t.item1);


  /// Cast all items in this iterable to [T] and call
  /// toList on the result
  List<T> toListOf<T>()
    => (this ?? <T>[]).cast<T>().toList();
}
