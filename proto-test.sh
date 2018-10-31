#!/bin/bash

# Author: Parth Thakkar (github.com/thakkarparth007)
#
# This script is used by travis-ci for building the proto files
# into Go packages. If this works well, we know that the proto
# files do not have compile-time errors, and the output
# is buildable in Go.

# You may run this manually to test before pushing.

export PATH=$PATH:$(pwd)/bin
rm -rf proto_build/
mkdir -p proto_build/
cp -r actions/ datastreams/ models/ DalalMessage.proto proto_build/
cd proto_build/
protoc --go_out=import_prefix=github.com/delta/dalal-street-proto/proto_build/,import_path=pb:. *.proto
protoc --go_out=import_prefix=github.com/delta/dalal-street-proto/proto_build/,import_path=actions_pb:. actions/*.proto
protoc --go_out=import_prefix=github.com/delta/dalal-street-proto/proto_build/,import_path=models_pb:. models/*.proto
protoc --go_out=import_prefix=github.com/delta/dalal-street-proto/proto_build/,import_path=datastreams_pb:. datastreams/*.proto
grep -rl "proto_build" . | grep -v ".sh" | xargs sed -r -i 's|github.com/delta/dalal-street-proto/proto_build/(google\|golang\|github)|\1|g'
find -type f -name "*.proto" -exec rm {} \;
go build
