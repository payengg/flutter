// Jangan deklarasi ulang plugin kotlin jika sudah otomatis di-manage Flutter!

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Custom lokasi folder build ke luar direktori android/
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

// Terapkan lokasi build baru untuk semua subprojects
subprojects {
    layout.buildDirectory.set(newBuildDir.dir(name))
}

// Pastikan evaluasi project app dilakukan dulu
subprojects {
    evaluationDependsOn(":app")
}

// Task untuk membersihkan folder build
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
