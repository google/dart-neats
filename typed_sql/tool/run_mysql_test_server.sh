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

# Create directory for exposing sockets
SOCKET_DIR="${ROOT}/.dart_tool/run/mysql/"
mkdir -p "$SOCKET_DIR"

trap "docker stop typed_sql_mysql 2>/dev/null || true" EXIT

docker run \
  -t --rm \
  --name typed_sql_mysql \
  -e MYSQL_ROOT_PASSWORD=root \
  -v "$SOCKET_DIR":/run/mysqld/ \
  --mount type=tmpfs,destination=/var/lib/mysql \
  mysql:9 \
  --skip-log-bin \
  --innodb-doublewrite=0 \
  --innodb-flush-log-at-trx_commit=0 \
  --sync-binlog=0 \
  --skip-name-resolve &

wait
