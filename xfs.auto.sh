sdlist="sdf sdg sdh sdi sdk sdl"
for sdx in $sdlist
  do
    devpath="/dev/"$sdx
    devpathn=$devpath"1"
    mntpath="/mnt/"$sdx"1"

    # partitioning
    parted -s $devpath mktable gpt
    parted -s -a optimal $devpath mkpart primary 0% 100%

    # formatting
    mkfs.xfs -f $devpathn

    # mount
    mkdir -p $mntpath
    mount $devpathn $mntpath 

    # update /etc/fstab
    echo "$devpathn   $mntpath   xfs   defaults  0 0" >> /etc/fstab

  done

