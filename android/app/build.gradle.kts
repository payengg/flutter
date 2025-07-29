plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // pakai versi full
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.terraserve_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.terraserve_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        minSdkVersion 21
        targetSdkVersion 34
    }

    buildTypes {
        getByName("release") {
            // TODO: Tambahkan konfigurasi signing release-mu jika sudah ada
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
