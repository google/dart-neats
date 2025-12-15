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

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT="${SCRIPT_DIR}/.."

cleanup() {
  echo "🛑 Shutting down all test databases"
  kill $(jobs -p) 2>/dev/null
  wait
  echo "✅ All test databases stopped"
}

trap cleanup SIGINT EXIT

echo "🚀 Launching all test databases"

"$ROOT/tool/run_postgres_test_server.sh" 2>&1 | sed "s/^/[Postgres] /" &
"$ROOT/tool/run_mariadb_test_server.sh"  2>&1 | sed "s/^/[MariaDB]  /" &

wait
