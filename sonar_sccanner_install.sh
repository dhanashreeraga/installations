#!/bin/bash

# Config
DEFAULT_VERSION="7.0.2.4839"
SONAR_SCANNER_VERSION="${1:-$DEFAULT_VERSION}"
INSTALL_BASE="/opt/sonar-scanner"
BIN_DIR="/usr/local/bin"

echo "🔧 Installing SonarScanner version ${SONAR_SCANNER_VERSION}..."

# Prerequisite
if ! command -v unzip &> /dev/null; then
  echo "'unzip' not found. Installing..."
  sudo apt update -y && sudo apt install -y unzip
fi

# Download
TMP_ZIP="/tmp/sonar-scanner-cli.zip"
wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip -O "$TMP_ZIP" || {
  echo "Failed to download SonarScanner. Check version or internet connection."; exit 1;
}

# Create directory
sudo mkdir -p "${INSTALL_BASE}"

# Unzip
sudo unzip -q "$TMP_ZIP" -d "${INSTALL_BASE}" || {
  echo "Failed to unzip. Exiting."; exit 1;
}
rm -f "$TMP_ZIP"

# Rename (only if dir found)
EXTRACTED_DIR=$(find "${INSTALL_BASE}" -maxdepth 1 -type d -name "sonar-scanner-*")
if [[ -d "$EXTRACTED_DIR" ]]; then
  sudo rm -rf "${INSTALL_BASE}/sonar-scanner" 2>/dev/null
  sudo mv "$EXTRACTED_DIR" "${INSTALL_BASE}/sonar-scanner"
else
  echo "Extracted folder not found. Exiting."
  exit 1