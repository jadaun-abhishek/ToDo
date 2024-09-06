# ToDo App

## Overview
The ToDo App is a Flutter-based application designed to manage and organize tasks efficiently. It features a modern user interface with both light and dark modes and leverages multiple Flutter packages for enhanced functionality and performance.

## Features
- **Task Management**: Create, update, delete, and view tasks.
- **Dark and Light Modes**: Toggle between dark and light themes for better visibility and user experience.
- **Local Storage**: Uses SQLite for storing tasks locally and GetStorage for theme preferences.
- **State Management**: Managed using GetX for efficient state handling and updates.
- **Notifications**: Local notifications to remind users about their tasks.
- **Persistent Theme**: The theme mode (dark or light) is preserved across app restarts.

## Demo
![Demo Video](https://github.com/user-attachments/assets/674a7848-e74a-4487-95e0-ebc13dea1dcf)


## Screenshots
**Dark Mode** **Light Mode**
![44A45CCB-15A8-4BC0-AC39-2EEC7512D177](https://github.com/user-attachments/assets/b628a89b-808d-445e-adba-9148c2a9c2a8)



## Getting Started

To get a local copy of the project up and running, follow these steps:

### Prerequisites
- Flutter SDK
- Dart SDK
- SQLite plugin for Flutter
- `get`, `get_storage`, and `shared_preferences` packages

### Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/rajput-asj/ToDo.git
    ```
2. Navigate to the project directory:
    ```bash
    cd ToDo
    ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Run the app:
    ```bash
    flutter run
    ```

## Usage
- **Switching Themes**: Tap the theme toggle button in the app to switch between dark and light modes. The app will remember your choice across sessions.
- **Managing Tasks**: Add, update, and delete tasks from the main screen. Notifications will alert you about upcoming tasks based on your settings.

## Built With
- **Flutter**: The framework used
- **shared_preferences**: For storing theme preferences
- **get_storage**: For additional storage management
- **get**: For state management and dependency injection
- **sqflite**: For local database storage
- **flutter_local_notifications**: For local notifications
