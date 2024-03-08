# Creating the Project
```bash
# Create project
mvn archetype:generate \
    -DgroupId=com.company.app \
    -DartifactId=maven-test \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 \
    -DinteractiveMode=false \
    -DoutputDirectory=../
```
## Add exec:java plugin
```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>exec-maven-plugin</artifactId>
  <version>3.2.0</version>
  <configuration>
    <mainClass>com.company.app.App</mainClass>
  </configuration>
</plugin>
```
# Other Stuff
```bash
# Compile the classes into multiple class files
mvn compile
# Compile classes and package into 1 jar file
mvn package

# Run tests
mvn test

# Run
mvn exec:java

# Create website from project
mvn site

# Remove artifacts
mvn clean
```
