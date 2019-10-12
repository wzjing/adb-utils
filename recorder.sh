#!/bin/bash

device_id=$1
counter=0
lock_screen_counter=0

if ! $2; then
    output_file=$2
else
output_file=$(pwd)/${1}_service.log
fi

if test -e $output_file; then
    rm $output_file
fi
touch $output_file

yidui_proc=0
tantan_proc=0
momo_proc=0
soul_proc=0

updateProcInfo() {
    yidui_proc=$(adb -s ${device_id} shell ps -ef | grep yidui | grep -v grep | wc -l)
    tantan_proc=$(adb -s ${device_id} shell ps -ef | grep putong | grep -v grep | wc -l)
    momo_proc=$(adb -s ${device_id} shell ps -ef | grep momo | grep -v grep | wc -l)
    soul_proc=$(adb -s ${device_id} shell ps -ef | grep soulapp | grep -v grep | wc -l)
    cat <<EOF
yidui   $yidui_proc
tantan  $tantan_proc
momo    $momo_proc
soul    $soul_proc

EOF
    return 0
}

counter=0
yidui_deadline=0
tantan_deadline=0
momo_deadline=0
soul_deadline=0
while true; do
    sleep 1s
    let counter++
    updateProcInfo
    if (( $yidui_proc > 1 )); then
        yidui_deadline=$counter
    fi
    if (( $tantan_proc > 1 )); then
        tantan_deadline=$counter
    fi
    if (( $momo_proc > 1 )); then
        momo_deadline=$counter
    fi
    if (( $soul_proc > 1 )); then
        soul_deadline=$counter
    fi
    cat <<EOF >$output_file
App             Status          Clock/s
yidui_proc      $yidui_proc     ${yidui_deadline}
tantan_proc     $tantan_proc    ${tantan_deadline}
momo_proc       $momo_proc      ${momo_deadline}
soul_proc       $soul_proc      ${soul_deadline}

EOF

done

exit 0
