#!/bin/bash

JAR="HMCL-*.jar"
JAR_NAME=($JAR)
PATCHED_JAR_NAME="${JAR_NAME//.jar/-patched.jar}"

mkdir Temp Out

jar xvf HMCL-*.jar -C Temp/HMCL
mkdir Temp/Lang
mv Temp/HMCL/assets/lang/boot_zh.properties Temp/HMCL/assets/lang/I18N_zh_CN.properties Temp/Lang

sed -i 's/。/喵。/g' Temp/Lang/*
sed -i -E 's/([a-zA-z])喵/\1 喵/g' Temp/Lang/*
sed -i 's/吗/喵/g' Temp/Lang/*
sed -i 's/？/喵？/g' Temp/Lang/*
sed -i 's/！/喵！/g' Temp/Lang/*
sed -i 's/：/喵：/g' Temp/Lang/*
sed -i 's/；/喵；/g' Temp/Lang/*

mv Temp/Lang/* Temp/HMCL/assets/lang
cd Temp/HMCL
jar cvfm ../../Out/$PATCHED_JAR_NAME META-INF/MANIFEST.MF *

cd ../..
rm -rf Temp