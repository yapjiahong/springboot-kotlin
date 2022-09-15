import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
	id("jacoco")
	id("pmd")
	id("com.diffplug.spotless") version "5.13.0"
	id("org.springframework.boot") version "2.7.3"
	id("io.spring.dependency-management") version "1.0.13.RELEASE"
	kotlin("jvm") version "1.6.21"
	kotlin("plugin.spring") version "1.6.21"
}

group = "com.example"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_1_8

repositories {
	mavenCentral()
}

//pmd {
//	ruleSetFiles = files("static_analysis/pmd.xml")
//	ruleSets = []
//}

//spotless {
//	format 'yaml', {
//	target '*.yml', 'src/*/resources/*.yaml'
//	prettier().config(['parser': 'yaml'])
//
//	indentWithSpaces()
//	trimTrailingWhitespace()
//	endWithNewline()
//}
//
//	format 'xml', {
//	target 'src/*/resources/*.xml', 'static_analysis/*.xml'
//	eclipseWtp('xml')
//
//	indentWithSpaces()
//	trimTrailingWhitespace()
//	endWithNewline()
//}
//
//	format 'md', {
//	target '*.md'
//	prettier()
//
//	indentWithSpaces()
//	trimTrailingWhitespace()
//	endWithNewline()
//}
//
//	format 'sh', {
//	target 'scripts/*.sh'
//	prettier(['prettier': '2.3.1', 'prettier-plugin-sh': '0.6.1'])
//
//	indentWithSpaces()
//	trimTrailingWhitespace()
//	endWithNewline()
//}
//
//	format 'properties', {
//	target 'lombok.config', 'gradle/wrapper/gradle-wrapper.properties'
//	prettier(['prettier': '2.3.1', 'prettier-plugin-properties': '0.1.0']).config(['parser': 'dot-properties'])
//
//	indentWithSpaces()
//	trimTrailingWhitespace()
//	endWithNewline()
//}
//
//	format 'json', {
//	target '*.json'
//	prettier()
//
//	indentWithSpaces()
//	trimTrailingWhitespace()
//	endWithNewline()
//}
//
//	//    sql {
//	//        target 'src/*/resources/*.sql'
//	//
//	//        dbeaver()
//	//
//	//        indentWithSpaces()
//	//        trimTrailingWhitespace()
//	//        endWithNewline()
//	//    }
//	groovyGradle {
//		target '*.gradle'
//		greclipse()
//
//		indentWithSpaces()
//		trimTrailingWhitespace()
//		endWithNewline()
//	}
//
//	java {
//		googleJavaFormat()
//		importOrder()
//		removeUnusedImports()
//		indentWithSpaces()
//		trimTrailingWhitespace()
//		endWithNewline()
//	}
//}


dependencies {
//	implementation("org.springframework.boot:spring-boot-starter")

//	implementation group: 'org.springframework.boot', name: 'spring-boot-starter-webflux'
	implementation("org.springframework.boot:spring-boot-starter-webflux")

	implementation("org.jetbrains.kotlin:kotlin-reflect")
	implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
}

tasks.withType<KotlinCompile> {
	kotlinOptions {
		freeCompilerArgs = listOf("-Xjsr305=strict")
		jvmTarget = "1.8"
	}
}

tasks.withType<Test> {
	useJUnitPlatform()
}
