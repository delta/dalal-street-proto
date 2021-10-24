#!/bin/bash

# Author: Parth Thakkar (github.com/thakkarparth007)
#
# This script is used by CirclCI for building the proto files
# into Go packages. If this works well, we know that the proto
# files do not have compile-time errors, and the output
# is buildable in Go.

# You may run this manually to test before pushing.

rm -rf proto_build/
mkdir -p proto_build/
cp -r actions/ datastreams/ models/ DalalMessage.proto proto_build/

protoc -I=. --go_out=proto_build --go_opt=paths=source_relative \
--go-grpc_out=proto_build --go-grpc_opt=require_unimplemented_servers=false --go-grpc_opt=paths=source_relative *.proto
protoc -I=. --go_out=proto_build --go_opt=paths=source_relative actions/*.proto
protoc -I=. --go_out=proto_build --go_opt=paths=source_relative models/*.proto
protoc -I=. --go_out=proto_build --go_opt=paths=source_relative datastreams/*.proto

cd proto_build/
grep -rl "proto_build" . | grep -v ".sh" | xargs sed -r -i 's|github.com/delta/dalal-street-proto/proto_build/(google\|golang\|github)|\1|g'
find -type f -name "*.proto" -exec rm {} \;
