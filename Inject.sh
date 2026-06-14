#!/bin/bash

shopt -s nullglob

EXT=""

for TARGET in HMCL-*.jar HMCL-*.sh HMCL-*.deb HMCL-*.exe; do
    EXT="${TARGET##*.}"
done

JAR=""
JAR_NAME=""
PATCHED_JAR_NAME=""

mkdir Temp

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

        offset=$(LC_ALL=C grep -ab -m1 $'\x50\x4b\x03\x04' $JAR_NAME | cut -d: -f1)
        if [ -z "$offset" ]; then
            echo "出错啦：未找到 Jar 数据起始位置喵" >&2
            exit 1
        fi

        dd if="$JAR_NAME" of=Temp/Script/Header.bin bs=1 count=$offset 2>/dev/null

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
        rm -rf Temp

        echo "没找到 HMCL 或者格式不支持喵"
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

mkdir Out

case "$EXT" in
    sh)
        cd Temp/HMCL
        PATCHED_JAR_NAME="${JAR_NAME//.sh/.jar}"
        jar cvfm ../Script/$PATCHED_JAR_NAME META-INF/MANIFEST.MF *

        cd ../..
        PATCHED_JAR_NAME="${JAR_NAME//.jar/-patched.sh}"
        cat Temp/Script/Header.bin Temp/Script/*.jar>Temp/Script/$PATCHED_JAR_NAME
        chmod +x Temp/Script/$PATCHED_JAR_NAME
        mv Temp/Script/$PATCHED_JAR_NAME Out
        ;;
    deb)
        PATCHED_JAR_NAME="${JAR_NAME//.deb/.sh}"
        cd Temp/HMCL
        jar cvfm ../Deb/usr/share/java/hmcl/$PATCHED_JAR_NAME META-INF/MANIFEST.MF *
        PATCHED_JAR_NAME="${JAR_NAME//.sh/.deb}"

        cd ../..
        dpkg-deb --build Temp/Deb
        PATCHED_JAR_NAME="${JAR_NAME//.deb/-patched.deb}"
        mv Temp/*.deb Out/$PATCHED_JAR_NAME
        ;;
    *)
        cd Temp/HMCL
        jar cvfm ../../Out/$PATCHED_JAR_NAME META-INF/MANIFEST.MF *

        cd ../..
        ;;
esac

rm -rf Temp

echo "完成啦"