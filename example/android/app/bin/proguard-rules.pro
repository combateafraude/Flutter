#=== Flutter Wrapper ===#
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep the classes that are deserialized by GSON
-keep class com.combateafraude.demo.report.model.** { <fields>; }
-keep class com.combateafraude.helpers.server.api.** { <fields>; }

# Keep - Library. Keep all public and protected classes, fields, and methods.
-keep public class * {
    public protected <fields>;
    public protected <methods>;
}

# Keep all enums. Removing this causes a crash in the Document enum
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep native methos. Removing this causes a crash
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}
