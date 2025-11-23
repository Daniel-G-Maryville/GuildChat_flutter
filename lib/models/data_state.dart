class DataState<T> {
  final T? data;
  final bool isLoading;
  final String? error;

  // Private constructor to enf
  const DataState._({this.data, this.isLoading = false, this.error});

  /// Factory constructor for a loading state.
  factory DataState.initalize() => const DataState._();

  /// Factory constructor for a loading state.
  factory DataState.loading({T? data}) {
    return DataState._(isLoading: true, data: data);
  }

  /// Factory constructor for a success state with loaded data.
  factory DataState.success(T data) => DataState._(data: data);

  /// Factory constructor for an error state with an error message.
  factory DataState.error(String error, {T? data}) {
    return DataState._(error: error, data: data);
  }

  /// Checks if this state represents a successful load with data.
  bool get hasData => data != null && error == null && !isLoading;

  /// Checks if this state represents an error.
  bool get hasError => error != null;

  @override
  String toString() {
    if (isLoading) return 'DataState: Loading';
    if (hasError) return 'DataState: Error - $error';
    if (hasData) return 'DataState: Success - $data';
    return 'DataState: Empty';
  }
}
