plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.depi_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        // التعديل هنا: غيرنا الاسم من "debug" لـ "loginConfig" عشان ميتعارضش مع الافتراضي
        create("loginConfig") {
            storeFile = file("debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    defaultConfig {
        applicationId = "com.example.depi_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // هنا بنقوله استخدم الكونفيج اللي سميناه loginConfig
            signingConfig = signingConfigs.getByName("loginConfig")
        }
        debug {
            // وهنا برضو بنقوله استخدم نفس الكونفيج
            signingConfig = signingConfigs.getByName("loginConfig")
        }
    }
}

flutter {
    source = "../.."
}
