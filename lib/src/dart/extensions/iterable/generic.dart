import '../../models/tuple.dart';

typedef MapIndexFunction<T,V> = V Function(T item, int index); 
typedef MapReduceFunction<T,V> = V Function(V previous, T current, int index);

extension FbfIterableExtensionsGeneric on Iterable {
  /// Return a new iterable of unique items
  Iterable<T> distinctBy<T,V>(V Function(T item) selectValue) sync* {
    final values = Set<V>();

    for (T item in this) {
      final v = selectValue(item);
      if (!values.contains(v)) {
        values.add(v);
        yield item;
      }
    }
  }


  /// Get a slice of this iterable from [start] to [length],
  /// filling out with [value] (or this.last) if this iterable is shorter
  /// than [length]
  Iterable<T> extend<T>(int length, [T value, int start = 0]) sync* {
    if (start < this.length) {
      yield length >= this.length ? (value ?? this.last) : this.elementAt(length);
      yield* extend<T>(length, value, start + 1);
    }
  }


  /// Map iterable to an iterable of map entries, where each items
  /// index is the key
  Iterable<MapEntry<int,T>> indexEntries<T>([int start = 0]) sync* {
    yield* mapIndex<T,MapEntry<int,T>>(
      (item, index) => MapEntry<int,T>(index, item),
      start
    );
  }

  /// like [map], except also supplies index to callback
  Iterable<V> mapIndex<T,V>(MapIndexFunction<T,V> action, [int start = 0]) sync* {
    if (start < length) {
      yield action.call(this.elementAt(start), start);
      yield* mapIndex<T,V>(action, start + 1);
    }
  }

  /// MapReduce with running reduction, or something like that.
  Iterable<Tuple3<V,T,int>> mapReduceIterable<T,V>(
    MapReduceFunction<T,V> reducer, 
    [
      V initialValue,
      int start = 0
    ]
  ) sync* {
    if (start < length) {
      final current = elementAt(start);
      final result = reducer.call(initialValue, current, start);

      yield Tuple3<V,T,int>(result, current, start);
      yield* mapReduceIterable<T,V>(reducer, result, start+1);
    }
  }


  /// More javascripty reduce
  V mapReduce<T,V>(MapReduceFunction<T,V> reducer, [V initialValue])
    => mapReduceIterable<T,V>(reducer, initialValue).last.item1;


  /// Map and call to list, ensuring casts to right types
  List<V> mapToList<T,V>(V Function(T item) f)
    => this.map<V>(f).toListOf<V>();
    

  /// Sort iterable, returning result as a list
  List<T> order<T>(int Function(T a, T b) comparator)
    => (
     this.toListOf<T>()
        ..sort(comparator)
      ).toList();


  /// Decorate, sort, undecorate
  List<T> schwartz<T,D>({
    D Function(T item) decorator,
    int Function(D a, D b) comparer,
  }) => (
    this.toListOf<T>()
      .mapToList<T,Tuple2<T,D>>((v) => Tuple2<T,D>(v, decorator.call(v)))
        ..sort((a,b) => comparer.call(a.item2, b.item2))
    ).mapToList<Tuple2<T,D>,T>((t) => t.item1);


  /// Cast all items in this iterable to [T] and call
  /// toList on the result
  List<T> toListOf<T>()
    => (this ?? <T>[]).cast<T>().toList();
}
