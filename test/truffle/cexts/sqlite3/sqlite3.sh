#!/usr/bin/env bash

source test/truffle/common.sh.inc

gem_test_pack=$(jt gem-test-pack)

jt ruby -S gem install --local "$gem_test_pack/gem-cache/sqlite3-1.4.2.gem" -V -N --backtrace

jt ruby test/truffle/cexts/sqlite3/test.rb
