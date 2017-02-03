#!/bin/bash

# Author: Parth Thakkar (github.com/thakkarparth007)
#
# This script is used by travis-ci for building the proto files
# into Go packages. If this works well, we know that the proto
# files do not have compile-time errors, and the output
# is buildable in Go.

# You may run this manually to test before pushing.

mkdir -p proto_build/ &&
cp -r actions/ datastreams/ errors/ models/ DalalMessage.proto proto_build/ &&
cd proto_build/ &&
protoc --go_out=import_prefix=github.com/thakkarparth007/dalal-street-proto/proto_build/,import_path=socketapi:. *.proto &&
protoc --go_out=import_prefix=github.com/thakkarparth007/dalal-street-proto/proto_build/,import_path=socketapi/actions:. actions/*.proto &&
protoc --go_out=import_prefix=github.com/thakkarparth007/dalal-street-proto/proto_build/,import_path=socketapi/models:. models/*.proto &&
protoc --go_out=import_prefix=github.com/thakkarparth007/dalal-street-proto/proto_build/,import_path=socketapi/errors:. errors/*.proto &&
protoc --go_out=import_prefix=github.com/thakkarparth007/dalal-street-proto/proto_build/,import_path=socketapi/datastreams:. datastreams/*.proto &&
grep -rl "github.com/golang/protobuf/proto" . | grep -v ".sh" | xargs sed -i 's|github.com/thakkarparth007/dalal-street-proto/proto_build/github.com/golang/protobuf/proto|github.com/golang/protobuf/proto|g' &&
find -type f -name "*.proto" -exec rm {} \; &&
go build
