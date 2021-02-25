abstract class Tuple {
  /// Number of items in this tuple
  final int numItems;

  /// Constructor
  Tuple(this.numItems);
}


class Tuple2<T,V> extends Tuple {
  /// The first item
  final T item1;

  /// The second item
  final V item2;

  /// Create a new instance
  Tuple2([this.item1, this.item2])
    : super(2); 

  /// Create a new instance from MapEntry
  Tuple2.fromMapEntry(MapEntry<T,V> entry)
    : this(entry.key, entry.value);

  /// Convert to MapEntry
  MapEntry toMapEntry()
    => MapEntry(item1, item2);
}


class Tuple3<T,V,U> extends Tuple2<T,V> {
  /// Third item
  final U item3;

  /// Create a new instance
  Tuple3([T item1, V item2, this.item3])
    : super(item1, item2);

  /// Create a new instance from MapEntry
  Tuple3.fromMapEntry(MapEntry<T,MapEntry<V,U>> entry)
    : this(entry.key, entry.value.key, entry.value.value);

  /// Convert to MapEntry
  @override
  MapEntry toMapEntry()
    => MapEntry(item1, MapEntry(item2, item3));
}
