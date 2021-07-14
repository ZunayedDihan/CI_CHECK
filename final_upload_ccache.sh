#!/bin/bash

cd /tmp

# sorting final zip
ZIP=$(find $(pwd)/rom/out/target/product/${T_DEVICE}/ -maxdepth 1 -name "*${T_DEVICE}*.zip" | perl -e 'print sort { length($b) <=> length($a) } <>' | head -n 1)
ZIPNAME=$(basename ${ZIP})


# final ccache upload
zst_tar ()
{
    time tar "-I zstd -1 -T16" -cf $rom.tar.zst $rom
    rclone copy --drive-chunk-size 256M --stats 1s $rom.ccache.tar.zst remote:ccache/ -P
}


# Let session sleep on error for debug
sleep_on_error()
{
 if [ -f $(pwd)/rom/out/target/product/${T_DEVICE}/${ZIPNAME} ]; then
	zst_tar ccache
 else
	zst_tar ccache
	sleep 2h
 fi
}

sleep_on_error
