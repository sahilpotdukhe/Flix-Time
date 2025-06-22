class TrailerState {
  final bool isLoading;
  final String? key;
  final String? error;
  TrailerState({this.isLoading = false, this.key, this.error});

  TrailerState copyWith({ bool? isLoading, String? key, String? error }) =>
      TrailerState(
        isLoading: isLoading ?? this.isLoading,
        key: key ?? this.key,
        error: error ?? this.error,
      );
}
