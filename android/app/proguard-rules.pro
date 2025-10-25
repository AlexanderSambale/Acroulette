-keep class com.sun.jna.* { *; }
-keepclassmembers class * extends com.sun.jna.* { public *; }
# Ignore missing java.awt classes
-dontwarn java.awt.**
-dontwarn com.sun.jna.Native$AWT
