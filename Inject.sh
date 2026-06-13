#!/bin/bash

shopt -s nullglob

EXT=""

for TARGET in HMCL-*.jar HMCL-*.sh HMCL-*.deb HMCL-*.exe; do
    EXT="${TARGET##*.}"
done

JAR=""
JAR_NAME=""
PATCHED_JAR_NAME=""

mkdir Temp Out

case "$EXT" in
    jar)
        JAR="HMCL-*.jar"
        JAR_NAME=($JAR)
        PATCHED_JAR_NAME="${JAR_NAME//.jar/-patched.jar}"

        jar xvf HMCL-*.jar -C Temp/HMCL
        ;;
    sh)
        JAR="HMCL-*.sh"
        JAR_NAME=($JAR)
        PATCHED_JAR_NAME="${JAR_NAME//.sh/-patched.sh}"

        jar xvf HMCL-*.sh -C Temp/HMCL
        ;;
    deb)
        JAR="HMCL-*.deb"
        JAR_NAME=($JAR)
        PATCHED_JAR_NAME="${JAR_NAME//.deb/-patched.deb}"

        dpkg-deb -R HMCL-*.deb Temp/Deb
        jar xvf Temp/Deb/usr/share/java/hmcl/HMCL-*.sh -C Temp/HMCL
        rm Temp/Deb/usr/share/java/hmcl/HMCL-*.sh
        ;;
    exe)
        JAR="HMCL-*.exe"
        JAR_NAME=($JAR)
        PATCHED_JAR_NAME="${JAR_NAME//.exe/-patched.exe}"

        jar xvf HMCL-*.exe -C Temp/HMCL
        ;;
    *)
        exit 1
        ;;
esac

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

if [ "$EXT" = "deb" ]; then
    PATCHED_JAR_NAME="${JAR_NAME//.deb/.sh}"
    cd Temp/HMCL
    jar cvfm ../Deb/usr/share/java/hmcl/$PATCHED_JAR_NAME META-INF/MANIFEST.MF *
    PATCHED_JAR_NAME="${JAR_NAME//.sh/.deb}"

    cd ../..
    dpkg-deb --build Temp/Deb
    mv Temp/*.deb Out/$PATCHED_JAR_NAME

    exit 1
fi

cd Temp/HMCL
jar cvfm ../../Out/$PATCHED_JAR_NAME META-INF/MANIFEST.MF *

cd ../..
rm -rf Temp