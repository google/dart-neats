#!/usr/bin/env bash

# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT="${SCRIPT_DIR}/.."

if [ -z "$(git status --porcelain --untracked-files=no)" ]; then
  echo '✅ Tracked files in git are clean, use `git restore .` to restore'
else
  echo "⚠️  Tracked files have been modified:"
  # Display the files that are dirty
  git status --porcelain --untracked-files=no
  exit 1
fi

echo '# Generate test scripts'
dart ./tool/generate_crud_tests.dart
dart ./tool/generate_custom_type_tests.dart
dart ./tool/generate_default_tests.dart
dart ./tool/generate_nullable_tests.dart

echo '# Generate doc exampls/lints'
dart ./tool/update_doc_examples.dart
dart ./tool/update_doc_links.dart

echo '# Run build_runner
dart run build_runner build
