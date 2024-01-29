typedef FilterChangedCallback<T> = void Function(T? newValue);

class Filter {
  final String? catID;



  Filter({
    this.catID,
  });
}
