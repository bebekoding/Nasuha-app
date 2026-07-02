allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // Workaround for older Flutter plugins (e.g. isar_flutter_libs)
    // that don't declare a namespace required by AGP 8+ and ship with
    // an outdated compileSdk.
    afterEvaluate {
        val androidExt = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (androidExt is com.android.build.gradle.LibraryExtension) {
            if (androidExt.namespace == null) {
                val manifestFile = file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val manifestText = manifestFile.readText()
                    val pkgMatch = Regex("""package=\"([^\"]+)\"""").find(manifestText)
                    if (pkgMatch != null) {
                        androidExt.namespace = pkgMatch.groupValues[1]
                    }
                }
            }
            androidExt.compileSdkVersion(36)
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
