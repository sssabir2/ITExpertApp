#!/usr/bin/env bash
set -euo pipefail

# ===== Config (change if you want) =====
GRADLE_VERSION=${GRADLE_VERSION:-8.7}
ANDROID_PLATFORM=${ANDROID_PLATFORM:-"platforms;android-34"}
ANDROID_BUILD_TOOLS=${ANDROID_BUILD_TOOLS:-"build-tools;34.0.0"}
PROJECT_DIR=${PROJECT_DIR:-"/workspaces/ITExpertApp"}   # adjust if your path differs
# ======================================

echo "==> Starting Android CI build in: $PROJECT_DIR"
cd "$PROJECT_DIR"

# 1) Android SDK root
export ANDROID_SDK_ROOT="${HOME}/android-sdk"
mkdir -p "${ANDROID_SDK_ROOT}"
echo "==> ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}"

# 2) Install command-line tools with the correct layout
echo "==> Installing Android command-line tools..."
rm -rf "${ANDROID_SDK_ROOT}/cmdline-tools" "${ANDROID_SDK_ROOT}/cmdline-tools-temp"
curl -fsSL -o "${ANDROID_SDK_ROOT}/cmdline-tools.zip" \
  https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip -q "${ANDROID_SDK_ROOT}/cmdline-tools.zip" -d "${ANDROID_SDK_ROOT}/cmdline-tools-temp"
rm -f "${ANDROID_SDK_ROOT}/cmdline-tools.zip"
mkdir -p "${ANDROID_SDK_ROOT}/cmdline-tools/latest"
mv "${ANDROID_SDK_ROOT}"/cmdline-tools-temp/* "${ANDROID_SDK_ROOT}/cmdline-tools/latest/"
rm -rf "${ANDROID_SDK_ROOT}/cmdline-tools-temp"

# 3) Ensure tools are on PATH
export PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"
echo "==> PATH updated."

# 4) Accept licenses + install SDK packages
echo "==> Accepting licenses & installing SDK packages..."
yes | sdkmanager --licenses >/dev/null
sdkmanager "platform-tools" "${ANDROID_PLATFORM}" "${ANDROID_BUILD_TOOLS}"

# 5) Write local.properties so Gradle knows the SDK path
echo "==> Writing local.properties..."
printf "sdk.dir=%s\n" "${ANDROID_SDK_ROOT}" > "${PROJECT_DIR}/local.properties"
cat "${PROJECT_DIR}/local.properties"

# 6) Ensure Gradle wrapper exists and is a compatible version
if [[ ! -f ./gradlew ]]; then
  echo "==> Gradle wrapper not found, installing Gradle ${GRADLE_VERSION} and generating wrapper..."
  if ! command -v gradle >/dev/null 2>&1; then
    curl -s "https://get.sdkman.io" | bash
    # shellcheck disable=SC1091
    source "${HOME}/.sdkman/bin/sdkman-init.sh"
    sdk install gradle "${GRADLE_VERSION}"
  fi
  gradle wrapper --gradle-version "${GRADLE_VERSION}"
fi

chmod +x ./gradlew
./gradlew --version

# 7) Build APK (debug)
echo "==> Building APK..."
./gradlew assembleDebug --stacktrace --warning-mode all

# 8) Show result
echo "==> APK(s) produced:"
ls -lh app/build/outputs/apk/debug/ || true
echo "==> Done."
