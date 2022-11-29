#!/bin/bash

( cd tool && dart pub get)

( cd tool && dart pub run mono_repo "$@" )
