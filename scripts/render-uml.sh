#!/usr/bin/env bash
set -euo pipefail

# Supply a local official PlantUML JAR; no diagrams are uploaded.
jar=${1:?Usage: bash scripts/render-uml.sh /absolute/path/to/plantuml.jar}
jar=$(realpath "$jar")
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_dir"
java -Djava.awt.headless=true -jar "$jar" -charset UTF-8 -failfast2 -tpng docs/*.puml
