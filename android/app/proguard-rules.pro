# Retrofit & Dio
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-keep class com.squareup.moshi.** { *; }

# Your models (adjust package name)
-keep class com.your.package.models.** { *; }

# Prevent obfuscation of your API interfaces and models
-keepclassmembers class * {
    @retrofit2.http.* <methods>;
}
