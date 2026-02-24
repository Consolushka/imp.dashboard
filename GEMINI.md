# IMP Basketball Stats Dashboard

## Project Overview
**IMP** is a Flutter-based dashboard designed to visualize basketball statistics, specifically focusing on the **Imp (Impact) index**. This index calculates a player's impact on the game based on their plus-minus (+/-), time played, and the final score differential.

The application provides a clean, minimalist interface for browsing leagues, tournaments, games, and player leaderboards across various professional basketball competitions.

### Key Technologies
- **Framework:** Flutter (Dart)
- **State Management/DI:** `get_it` for dependency injection.
- **Networking:** `http` for REST API communication.
- **Styling:** Custom Material 3 theme with a stark black-and-white aesthetic.
- **Utilities:** `flutter_dotenv` for environment configuration.

---

## Project Structure
- `lib/core/`: Core utilities and setup (e.g., Dependency Injection).
- `lib/infra/`: Infrastructure layer containing the `StatisticsClient` and API models.
- `lib/models/`: Domain models (Game, League, Player, Team, Tournament).
- `lib/screens/`: Main UI screens (Home, Leaderboard, Games, Details).
- `lib/widgets/`: Reusable UI components (Cards, AppDrawer, Tables).
- `lib/library/`: Generic helper functions (e.g., sorting).
- `assets/`: Project assets (images, fonts).

---

## Building and Running

### Prerequisites
- Flutter SDK (version specified in `pubspec.yaml`, currently `^3.7.2`)
- Android Studio / VS Code with Flutter extension
- A running instance of the [IMP Backend API](https://hfhq-a10d-zqqo.gw-1a.dockhost.net/api) (or local equivalent)

### Key Commands
- **Install Dependencies:** `flutter pub get`
- **Run the App:** `flutter run`
- **Build for Web:** `flutter build web`
- **Build for Android:** `flutter build apk`
- **Build for iOS:** `flutter build ios`
- **Run Tests:** `flutter test`

---

## Development Conventions

### Architecture
- **Centralized API Access:** All network calls must go through `StatisticsClient` located in `lib/infra/statistics/`.
- **Dependency Injection:** Use `GetIt` (via `DependencyInjection` class in `lib/core/di.dart`) to access the `StatisticsClient` and other services.
- **Models:** Use factory constructors (`fromJson`) for data deserialization.

### UI & Styling
- **Minimalism:** Adhere to the black-and-white theme defined in `lib/main.dart`. Avoid introducing unauthorized colors.
- **Responsiveness:** Use `MediaQuery` or `LayoutBuilder` to ensure the dashboard works on mobile, tablet, and desktop (see `HomeScreen` for grid examples).
- **Material 3:** Leverage Material 3 components but styled to match the project's aesthetic (no shadows, borders instead of elevation).

### Environment Configuration
- The API base URL is currently hardcoded in `lib/main.dart` but can be configured via environment variables if `dotenv` is fully integrated.
- Default API: `https://hfhq-a10d-zqqo.gw-1a.dockhost.net/api`

---

## Key Files
- `lib/main.dart`: App entry point, theme definition, and global configuration.
- `lib/infra/statistics/client.dart`: The primary interface for data fetching.
- `lib/models/ranked_player_model.dart`: Contains the logic for the Imp metric representation in leaderboards.
- `lib/screens/home_screen.dart`: The entry point for browsing leagues.
