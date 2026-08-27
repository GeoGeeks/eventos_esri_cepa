import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Credenciales de la keystore de producción (Android). El archivo real
// `key.properties` NO se versiona (ver android/.gitignore) — cada quien lo
// crea localmente a partir de `key.properties.example`. Mientras no exista,
// el build de release sigue firmando con la keystore de debug, para no
// bloquear `flutter run --release` en máquinas sin la keystore de subida.
val keystorePropertiesFile = rootProject.file("key.properties")
val hasReleaseKeystore = keystorePropertiesFile.exists()
val keystoreProperties = Properties()
if (hasReleaseKeystore) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // El namespace es solo el paquete interno de compilación (R class, etc.)
    // y no necesita coincidir con el applicationId de tienda — cambiarlo
    // implicaría mover el paquete de MainActivity.kt, así que se deja igual.
    namespace = "com.example.esri_eventos"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // ID definitivo de la app en tiendas. Debe coincidir con el Bundle ID
        // configurado en Xcode para iOS (ver ios/Runner, target Runner ->
        // Signing & Capabilities -> Bundle Identifier).
        applicationId = "com.esrico.eventoscepa"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Usa la keystore de producción en cuanto exista android/key.properties
            // (ver key.properties.example); mientras tanto sigue en debug.
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
