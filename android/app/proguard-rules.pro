# shared_preferences_android 2.5.x invokes generated Kotlin APIs through JNI.
# Preserve the reflected entry points and their parameter type names under R8.
-keep,includedescriptorclasses class io.flutter.plugins.sharedpreferences.** { *; }

# JNI's Kotlin suspend-function bridge resolves these runtime classes by name.
-keep,includedescriptorclasses class kotlin.coroutines.** { *; }
-keep,includedescriptorclasses class kotlin.Result** { *; }
-keep,includedescriptorclasses class kotlin.Unit { *; }
