import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

application {
    mainClassName = "MainKt"
}

plugins {
    kotlin("jvm") version "1.4.0"
    application
}
group = "testinpubsublib"
version = "0.9.0"

repositories {
    mavenCentral()
    jcenter()
}
dependencies {
    implementation(platform("com.google.cloud:libraries-bom:20.4.0"))
    implementation("com.google.cloud:google-cloud-pubsub")
}

tasks.jar {
    // names the jar app.jar
    archiveFileName.set("gcppubsubtest.jar")
    manifest {
        // helps make the jar executable by telling where the entry method is
        attributes["Main-Class"] = "MainKt"
    }

    // adds all deps into the jar making it a "fat jar", runable on its own
    from { configurations.runtimeClasspath.get().map { if (it.isDirectory) it else zipTree(it) } }
}

tasks.withType<KotlinCompile>() {
    kotlinOptions.jvmTarget = "14"
}

