# Task Manager App

## Overview
The Task Manager App is a Flutter application that allows users to manage their tasks efficiently. The app includes user authentication, task management with CRUD operations, pagination, state management using Provider, local storage for persistent data, and comprehensive unit tests.

## Features
- **User Authentication**: Secure login using username and password via the [DummyJSON API](https://dummyjson.com/docs/auth).
- **Task Management**: View, add, edit, and delete tasks using the [DummyJSON API](https://dummyjson.com/docs/todos).
- **Pagination**: Efficiently fetch a large number of tasks using pagination.
- **State Management**: Manage state using the Provider pattern.
- **Local Storage**: Persist tasks locally using SharedPreferences.
- **Unit Tests**: Comprehensive unit tests for CRUD operations, input validation, state management, and network requests using mock responses.

## Design Decisions
1. **State Management with Provider**: Provider was chosen for state management due to its simplicity and efficiency in managing state updates and dependencies in Flutter applications.
2. **Local Storage with SharedPreferences**: SharedPreferences was used for local storage to keep the app lightweight and easy to manage. It stores tasks locally to ensure persistence across app restarts.
3. **User Authentication**: Implemented secure user authentication using the DummyJSON API, allowing users to log in and manage their tasks.
4. **Task Management**: Used the DummyJSON API for CRUD operations to manage tasks efficiently. This approach ensures that the app remains stateless and relies on server-side data management.

## Challenges Faced
- **API Integration**: Integrating with the DummyJSON API for authentication and task management required handling various edge cases and ensuring secure data transmission.
- **State Management**: Ensuring efficient state updates and synchronization between local storage and server-side data was challenging. This required careful handling of asynchronous operations and state updates.
- **Persistent Storage**: Managing persistent storage using SharedPreferences posed challenges, especially when synchronizing local data with server-side updates. Ensuring data consistency and reliability was crucial.
- **Unit Testing**: Writing comprehensive unit tests for network requests and state management involved creating mock responses and handling asynchronous operations. Ensuring high test coverage and reliability was essential.

## Additional Features
- **User-friendly Interface**: Designed a clean and intuitive user interface to enhance user experience.
- **Robust Error Handling**: Implemented robust error handling and user feedback mechanisms to ensure a smooth user experience.

## Getting Started

Install Dependencies:
flutter pub get

Run the App:
flutter run

Run Tests:
flutter test

Usage:
Login: Use the username kminchelle and password 0lelplR to log in.
Manage Tasks: Add, edit, delete, and view tasks. Tasks are persisted locally and synchronized with the server.
Conclusion
The Task Manager App demonstrates efficient state management, local storage, and integration with external APIs. It provides a robust and user-friendly platform for managing tasks while ensuring data persistence and reliability.
