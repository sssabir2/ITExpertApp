@ECHO OFF
SET APP_HOME=%~dp0
SET JAVA_EXE=java
SET WRAPPER_JAR=%APP_HOME%gradle\wrapper\gradle-wrapper.jar
IF NOT EXIST "%WRAPPER_JAR%" (
  ECHO gradle-wrapper.jar not found.
  EXIT /B 1
)
"%JAVA_EXE%" -jar "%WRAPPER_JAR%" %*
