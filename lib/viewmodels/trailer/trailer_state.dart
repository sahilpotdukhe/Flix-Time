class TrailerState {
  final bool isLoading;
  final String? movieKey;
  final String? tvKey;
  final String? error;
  TrailerState({this.isLoading = false, this.movieKey,this.tvKey, this.error});

  TrailerState copyWith({ bool? isLoading, String? movieKey,String? tvKey, String? error }) =>
      TrailerState(
        isLoading: isLoading ?? this.isLoading,
        movieKey: movieKey ?? this.movieKey,
        tvKey: tvKey ?? this.tvKey,
        error: error ?? this.error,
      );
}
