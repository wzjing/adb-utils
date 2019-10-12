#!/bin/bash

origin=weixin_origin

rm ${origin}.apk

rm ${origin}_resigned.apk

apktool b yidui -o ${origin}.apk || exit -1

apksigner sign --ks ./hack/resigner/official.jks --ks-key-alias me.yidui --ks-pass pass:me.yidui --key-pass pass:me.yidui --out ${origin}_resigned.apk ${origin}.apk || exit -2

adb install -t -r ${origin}_resigned.apk || exit -3

# adb shell am start me.yidui/com.yidui.activity.MainActivity