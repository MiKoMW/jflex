#!/bin/bash

# Multi-platform hack for:
#SCRIPT_PATH=$(dirname "$(readlink -f $0)")
CWD=$PWD
SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)"
cd $CWD

# Provides the logi function
source $SCRIPT_PATH/logger.sh

# fail on error
set -e

logi "Powered by Maven wrapper"
./mvnw --version

if [[ ! $TRAVIS ]]; then
  # clean existing artefacts
  # note that mvn could fail if POM are incorrects
  logi "Clean target directories"
  find . -name target -type d -exec rm -rf {} \; || true

  # Travis steps
  # See https://docs.travis-ci.com/user/languages/java/#Projects-Using-Maven"

  # Travis installs dependencies
  #mvn install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
  #./mvnw install -DskipTests=true -Dmaven.javadoc.skip=true -B -V
  # Skipped because .travis.yml has `installation: true`

  # Travis runs tests
  # Implemented by this script because `script: ./run-tests`
fi

logi "Compile and install all"
# Install jflex in local repo
# implies: validate, compile, test, package, verify
./mvnw install

logi "Run regression test cases"
# regression test suite must run in its own directory
cd testsuite/testcases; ../../mvnw test
cd ../..

logi "Run jflex examples"
# Each line must end with the test command to make the script exit
# in case of error (see #242)
cd jflex/examples
cd simple-maven; mvn test; cd ..
cd standalone-maven; mvn test; cd ..
# don't assume byacc/j is installed, just run lexer
cd byaccj; make clean; make Yylex.java; cd ..
cd cup; make clean; make; cd ..
cd interpreter; make clean; make; cd ..
cd java; make clean; make; cd ..
cd zero-reader; make clean; make; cd ..
cd ../..

# also check ant build
logi "Re-compile with ant"
cd jflex; ant gettools build test; cd ..

logi "Success"
