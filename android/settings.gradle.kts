pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    // Firebase Cloud Messaging (2026-09-16) - el classpath del plugin va acá
    // (no en android/build.gradle.kts, que en este template de Flutter ya
    // no tiene bloque plugins{}) porque este proyecto usa el patrón
    // declarativo de plugins de Gradle moderno.
    id("com.google.gms.google-services") version "4.5.0" apply false
}

include(":app")
