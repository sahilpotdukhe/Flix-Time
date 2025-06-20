# Core Flutter engine
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Common Flutter plugins
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**

# Keep main activity
-keep class com.example.tmdb_movies.MainActivity { *; }

# Model classes (adjust this if your package is different)
-keep class com.example.tmdb_movies.models.** { *; }

# Keep Hive adapters (optional)
-keep class **.TypeAdapter { *; }

-keep class retrofit2.** { *; }
-dontwarn retrofit2.**


# AndroidX
-dontwarn androidx.**
