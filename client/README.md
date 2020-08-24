# ktg_client

This is the **Know the Game** client source code.

## Usage

### Prerequisites

Install the following on your system:

- [Flutter](https://flutter.dev)
- [Android Studio](https://developer.android.com/studio), for the Android Virtual Device (AVD) Manager

## Running

To create a virtual device using Android Studio please refer to the following link:  https://developer.android.com/studio/run/managing-avds
 
List all installed AVDs by running

```
flutter emulators
```

Then launch a specific emulator with

```
flutter emulators --launch <emulator id>
```

Using the shell move to the folder where the project exists, then move to client folder

With an Android Virtual Device connected, you can run the application using:

```shell
flutter run
```

## Debugging (Using Flutter DevTools)
**what can be done?**

1. Inspect the UI layout and state of a Flutter app.
2. Diagnose UI jank performance issues in a Flutter app.
3. Source-level debugging of a Flutter or Dart command-line app.
4. Debug memory issues in a Flutter or Dart command-line app.
5. View general log and diagnostics information about a running Flutter or Dart command-line app.

For more information please visit the following link:   https://flutter.dev/docs/development/tools/devtools/overview

## Testing

First, using the command shell move to the client folder inside the project directory

To run a specific test file execute

```shell
flutter test test/<filename>_test.dart
```

To automatically find and run all files named *_test.dart inside a package's test/ subdirectory execute

```shell
flutter test
```

## Developing

You can use Android Studio, IntelliJ or VSCode to work on the project. See [this page](https://flutter.dev/docs/get-started/editor?tab=vscode) on instructions for setting up a local Flutter development environment.

### Linting and formatting

Your editor should automatically warn you about linting errors if you are using an editor that has Flutter tooling, as it will check the [analsys_options](./analysis_options.yaml) file. In order to keep your code passing the CI pipeline, we require you to fix all analysis elements found. To see if your code needs changing, run 

```
flutter analyze
```

For good measure, to format the source code run

```
flutter format lib/*
```
