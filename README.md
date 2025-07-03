# TMDB Movies & TV Shows Flutter App 🎬📺

A beautiful Flutter app showcasing trending, popular, top-rated movies and TV shows using the TMDB API. Built with **Bloc**, **Hive**, **Retrofit (Dio)**, and a **clean MVVM architecture**.

---

## 📦 Features

### 🏠 Home Tab
- Trending Movies (Carousel)
- Now Playing, Popular, Top Rated, Upcoming Movies

### 📺 TV Shows Tab
- Trending TV Shows (Carousel)
- Popular & Top Rated TV Shows

### 🔍 Search
- Search for Movies

### 📄 Details Screen (Movie & TV Show)
- Poster, Title, Rating, Release Date, Overview
- Trailer (YouTube player)
- Casts (with images)
- Similar Movies/TV Shows
- Bookmark toggle

### 🔖 Bookmarks
- Add/remove movies and TV shows to bookmarks
- Offline persistence using Hive

### 🛰 Offline Support
- Movie & TV data cached locally via Hive
- Works offline once data is cached

### 🧭 Deep Linking (for test/dev)
- Navigate to specific movie using custom scheme: `tmdbmovies://movie?id=123`

---

## 🗂 Architecture

```
lib/
├── data/
│   ├── api/                 # TMDB API (Retrofit/Dio)
│   ├── repositories/        # MovieRepository & TvShowRepository
│
├── models/                  # MovieModel, TvShowModel, CastModel etc.
│
├── viewmodels/              # Bloc, Events, States
│   ├── home/
│   ├── bookmarks/
│   ├── movie_details/
│   ├── tv_shows/
│   ├── trailer/
│   └── casts/
│
├── views/
│   ├── home/
│   ├── movies/
│   ├── tv/
│   ├── search/
│   ├── widgets/             # Shared widgets (QuietBox, Carousel, etc.)
│   └── splash/
│
├── main.dart
└── ...
```

---

## 🔑 Requirements

- Flutter SDK (3.13+)
- Dart SDK
- Android/iOS Emulator or Device
- `.env` file with TMDB API key

```
TMDB_API_KEY=your_tmdb_api_key_here
```

---

## 🚀 Getting Started

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 🔐 Build Release APK

1. Set your keystore in `key.properties` & `build.gradle`
2. Run:

```bash
flutter build apk --release
```

---

## 📚 Packages Used

- `flutter_bloc`
- `hive`, `hive_flutter`
- `retrofit`, `dio`
- `json_serializable`
- `flutter_dotenv`
- `youtube_player_flutter`
- `equatable`

---

## ❤️ Contributions

Pull Requests are welcome! Let's make this app even better.

---

## 📸 Screenshots

_(Add your own screenshots here)_

---
