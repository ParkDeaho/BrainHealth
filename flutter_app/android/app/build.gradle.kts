import java.util.Properties

/** pubspec.yaml 의 version: x.y.z+code — Gradle만 써도 Play용 versionCode 가 맞게 나가도록 함 */
fun loadPubspecVersion(projectDir: java.io.File): Pair<String, Int> {
    val pubspec = projectDir.resolve("../pubspec.yaml").canonicalFile
    require(pubspec.exists()) { "pubspec.yaml 없음: ${pubspec.absolutePath}" }
    val line =
        pubspec.readLines().map { it.trim() }.firstOrNull { it.startsWith("version:") }
            ?: error("pubspec 에 version: 줄이 없습니다")
    val raw = line.removePrefix("version:").trim().removeSurrounding("\"")
    return if ("+" in raw) {
        val parts = raw.split("+", limit = 2)
        parts[0].trim() to parts[1].trim().toInt()
    } else {
        raw to 1
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

val (pubVersionName, pubVersionCode) = loadPubspecVersion(rootProject.projectDir)

android {
    namespace = "com.parker.mybrainhealth"
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
        applicationId = "com.parker.mybrainhealth"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = pubVersionCode
        versionName = pubVersionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
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
            signingConfig =
                if (keystorePropertiesFile.exists()) {
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
