#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Please supply the needed arguments\n"
    exit
fi

if [ $1 == '-local' ]
then
    sudo apt update
    echo -e "\n---- Installing Kernel Headers -----\n\n"
    sudo apt install -y linux-headers-$(uname -r)
elif [ $1 == '-virt' ]
    then

    # Install qemu for running the kernel Images
    sudo apt update
    echo -e "\n---- Installing QEMU -----\n\n"
    sudo apt-get install -y qemu qemu-user qemu-user-static

    echo -e "\n---- Installing Kernel Sources -----\n\n"
    mkdir kernel_source
    cd kernel_source
    wget -c  https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.18.16.tar.xz
    tar -xvf linux-4.18.16.tar.xz
    cd ../

    if [ $2 == '-arm'  ]
        then

        # GDB multiarch for Debugging
        sudo apt-get install -y gdb-multiarch
        # Cross Compiler for arm
        sudo apt-get install -y gcc-arm-linux-gnueabihf libc6-dev-armhf-cross libelf-dev gcc-aarch64-linux-gnu

        echo -e "\n---- Unpacking Kernel Image ----\n\n"
        tar -xvzf ./images/arm64/arm64-Image.tar.gz -C ./images/arm64/

        echo -e "\n---- Preparing Kernel for Module Compilation ----\n\n"
        cd ./kernel_source/linux-4.18.16/
        ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make defconfig
        ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make modules_prepare
        cd ../../

    elif [ $2 == '-x86' ]
        then
        echo "Building for x86"
    else
        echo "Unknown parameter $2"
    fi

else
    echo "Unknown parameter $1"
fi



