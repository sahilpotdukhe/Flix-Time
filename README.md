# 🎬 TMDB Movies App

A Flutter application that fetches and displays movies using **The Movie Database (TMDB) API**, featuring:
- Trending & Now Playing movies
- Offline caching using **Hive**
- Bookmark favorite movies
- View detailed movie info
- Search movies
- MVVM + BLoC architecture

---

## 🧱 Architecture

The app follows **MVVM** and uses **BLoC** for state management.

```
lib/
├── data/
│   ├── api/             // API service classes
│   └── repositories/    // Repository implementations
├── models/              // Hive + JSON serializable models
├── viewmodels/          // BLoC files: state, events, bloc
├── views/
│   ├── home/            // Home screen UI
│   ├── search/          // Search screen UI
│   ├── movie_details/   // Movie details UI
│   └── widgets/         // Reusable UI widgets
```

---

## 📦 Features

✅ Trending Movies  
✅ Now Playing Movies  
✅ Movie Details Page  
✅ Offline Caching (Hive)  
✅ Bookmarking Movies  
✅ Bookmark Screen  
✅ Search Movies  
✅ Network Aware UI Banner  
✅ Error Handling + Fallback UI  
✅ Shimmer Effect on Loading

---

## 🚀 Getting Started

### ✅ Prerequisites

- Flutter 3.x
- TMDB API key (https://www.themoviedb.org/documentation/api)
- Android/iOS emulator or real device

---

### 🛠️ Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/sahilpotdukhe/Flix-Time.git
   cd tmdb_movies
   ```

2. **Create `.env` file**
   ```env
   TMDB_API_KEY=your_tmdb_api_key_here
   ```

3. **Install packages**
   ```bash
   flutter pub get
   ```

4. **Generate Hive adapters (if not already)**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 📂 Local Database (Hive)

Boxes used:

| Box Name         | Description                      |
|------------------|----------------------------------|
| `trendingBox`    | Caches trending movies           |
| `nowPlayingBox`  | Caches now playing movies        |
| `movieDetailsBox`| Caches fetched movie details     |
| `bookmarksBox`   | Stores bookmarked movies         |

---

## 🧠 State Management

Using [flutter_bloc](https://pub.dev/packages/flutter_bloc):

- `HomeBloc`: Fetches trending & now playing
- `MovieDetailsBloc`: Fetches full movie info
- `BookmarksBloc`: Toggle & load bookmarks
- `SearchBloc`: Handles live search queries

---

## 🧪 Offline Support

- If API fails (no network), fallback to Hive cache
- `NetworkStatusBanner` shown at top when offline
- Bookmark data fully accessible offline

---

## 🔎 Search Functionality

- Type in the search bar
- Live TMDB API call for matching movies
- Click on result to go to Movie Details screen

---
