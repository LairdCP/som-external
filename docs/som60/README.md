# Introduction
## Purpose
The reference guide is intended to provide an embedded developer with the information needed to start evaluating and integrating the 60 Series SOM for their connectivity and embedded Linux processing needs.  The guide is designed to walk the developer integrating the 60 Series SOM through the same process Laird developers use to develop our own boxed products. This allows multiple levels of Laird's customer support team to assist with customer integrations.

# Software Information

## Prerequisites
The reference guide is designed to walk you through Laird Connectivity's development process for the 60 SOM, including the Laird Connectivity Linux board support package. The most seamless workflow for developing your application for the 60 SOM is to set up a GitHub account, configure your SSH keys, and then install and configure Git on your development PC.

### Ubuntu
Laird recommends Ubuntu 18.04 64-bit as the base operating system for your development. All instructions in this reference guide assume a developer on an Ubuntu 18.04 64-bit system. If using other than Ubuntu 18.04 64-bit, please ensure you Linux distribution is a 64-bit variant as the cross-compiling toolchain requires a 64-bit Linux environment.

### SSH
Laird makes extensive use of GitHub and having proper Secure Shell (SSH) access to our repositories on GitHub. If you haven't set up SSH, you can use the instructions below to enable SSH for use with GitHub.
1. Check whether your private key (~/.ssh/id_rsa) and public key (~/.ssh/id_rsa.pub) files exist
  1. `$ ls -1 ~/.ssh/id_rsa*`
2. If they do not, generate them
  1. `$ ssh-keygen`
    1. Accept default file paths
    2. Accept no passphrase
3. View your public key
  1. `$ cat ~/.ssh/id_rsa.pub`

### git
Laird delivers the Laird Linux board support package using git repositories. If you haven't set up git, you can use the instructions below to enable git for use with GitHub.
* Install and configure the "git" package
  1. `$ sudo apt install git`
  2. `$ git config --global user.name "John Doe"`
  3. `$ git config --global user.email "john.doe@yourcompany.com"`
  4. `$ git config --list`
    1. Expect user.name=John Doe
    2. Expect user.email=john.doe@yourcompany.com

### repo
Laird uses the repo tool from the Android project to pull down and correctly layout the git repositories that comprise the Laird Linux board support package. To install repo on Ubuntu, use the instructions below.
* `$ sudo apt install repo`

You can also get it by following the instructions here:
* (https://source.android.com/source/downloading.html#installing-repo)

### Github Account
Laird Linux board support packages are availabe on GitHub. The most seamless workflow throughout a integration is to set up a GitHub account (https://github.com/) and add your SSH public key to your GitHub account. Instructions for setting up a GitHub account and adding an SSH key are below.
1. Go to (https://github.com/join) and follow the instructions.
2. Once you have a GitHub account add your public SSH key generated previously.
  1. View your public key
    1. `$ cat ~/.ssh/id_rsa.pub`
  2. This should be similar to:
    1. `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDW5HxCJe56MZKkGxtHU2hkb1uyuJ3i+AFZNnSIApiDe1l1H9Y40YjBF+sE47GKgNuzQIMqKZ6xjRdb8KxvtjQIE/VcSiz9KIaFtKce/wKKxy0vOXbskSLzELlA9ovY9AJmp3qUaW+BEChnggERjPvq+1oyiKGRJzo51j/CQr+Yx8c2MtKubjHknKkQ2Th8kxL1bQj4lVgyfqNGj3DXUz9S+kTm+dLnmmOXlUfxx8Khrb7j0Dg+lk1lqeolqt6aFwpMnb8V2h5lDevJ0YSSyId01OnaAnIlx1lc+zauctsgtZf5Htl9cXS7Cp3OCMfSa+IKFeFL9/ku9C25EdA5zOnt your@email.com`
  3. Copy the contents of the above output to you clipboard
  4. Follow the instructions at
	 (https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/) starting with Step 2.

## Laird Linux
### Overview
Laird Linux is Laird's board support package specifically tailored for Laird's SOMs and customer's connectivity driven use cases. Laird regularly updates Laird Linux by merging in the upstream Linux kernel and Buildroot. We merge in major long-term support kernel releases which allow our SOMs to utilize the latest in drivers and kernel space functionality, performance enhancements, security, and bug fixes.  Also, we merge in major long-term support Buildroot releases which provide for the latest in over 2200 user space applications and libraries. Laird Linux takes this solid upstream heritage and integrates our custom platform enhancements for connectivity, security, and power consumption.

### Buildroot
The core piece of Laird Linux is [Buildroot](https://buildroot.org/). Buildroot is a from source build system designed to allow the customer to create a customized Linux image for a target embedded computing module. Buildroot is capable of configuring and building the bootloader, kernel, and rootfs for Laird's SOMs. Buildroot's core build system technologies are the well-known and easy to understand [make](https://en.wikipedia.org/wiki/Make_(software)) build tool and [kconfig](https://www.kernel.org/doc/Documentation/kbuild/kconfig-language.txt) configuration tool. This enables easy build customization through the user interface tools [menuconfig](https://en.wikipedia.org/wiki/Menuconfig) or xconfig and Buildroot make commands. The [Linux kernel](https://www.kernel.org/), [U-Boot bootloader](http://www.denx.de/wiki/U-Boot/WebHome), and [Busybox core userspace ulilities toolkit](https://en.wikipedia.org/wiki/BusyBox) all use make, Kconfig, and menuconfig. Build and configuration concepts found in one translate nicely to another. Buildroot has easy to read and extensive documentation available at (https://buildroot.org/docs.html) in pdf, html, and ascii form.  If time permits, Laird highly recommends following the Training section of the documentation landing page.

Laird's Buildroot is a fork of the upstream [Buildroot stable](https://git.busybox.net/buildroot/). Starting with and merging upstream allows Laird to know the authenticity of Buildroot's source code and better verify the security of our fork. Laird targets [long-term support releases (LTS)](https://buildroot.org/download.html) for merging into our Buildroot fork.

### Linux Kernel
Laird's kernel is a fork the upstream [Linux stable kernel](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/). Starting with and merging upstream allows Laird to know the authenticity of the kernel's source code and better verify the security of our fork. Laird targets [long-term support releases (LTS)](https://www.kernel.org/category/releases.html) for merging into our kernel fork.

### Toolchain
Laird preselects prebuilt toolchains for each release of Laird Linux for our SOMs. The advantage of using a preselected and prebuilt toolchain is the high level of QA verification on common components between stock Laird development images and customer images. We are currently ultilizing prebuilt toolchains from [Bootlin’s toolchain program](https://toolchains.bootlin.com).  Bootlin, who is major contributor to Buildroot, provides a variety of prebuilt toolchains created from Buildroot's toolchain building capabilties. Laird selects toolchains that have been marked stable by the Buildroot community and use proven components. Beyond the toolchains themselves, Bootlin also stores the following artifacts for reference from their Buildroot based toolchain generation process: README of all essential information, defconfig fragment to generate toolchain, build log, software bill-of-material (SBOM), test system image, and test system defconfig. Laird configures each Laird Linux release to automatically download and use the correct toolchain.

## Getting Started with Laird Linux
This section will walk a developer through following:

* [Downloading a developer's SD card image](#downloading-a-developers-sd-card-image)
* [Flashing a developer's SD card image](#flashing-a-developers-sd-card-image)
* [Using a prebuilt SDK](#using-a-prebuilt-sdk)
* [Manifest file](#Manifest-file)
* [Downloading the board support package source code](#downloading-the-board-support-package-source-code)
* [Building the developer's SD card image](#building-the-sd-card-developers-image)
* [Building the NAND image](#building-the-NAND-image)
* [Software update](#Software-update)
* [Setup web server](#Setup-web-server)
* [Buildroot cache](#Buildroot-cache)
* [Creating a custom SDK](#create-a-custom-sdk)

### Downloading a developer's SD card image
Laird Linux releases include a prebuilt SD card image as a starting point for evaluating and integrating a Laird Linux release on a Laird SOM. For the 60 SOM, these prebuilt images are found on at [60 SOM release page](https://github.com/LairdCP/SOM60-Release-Packages/releases). These releases are named som60sd-laird-A.B.C.D.tar.bz2. These prebuilt SD card images are good for quickly testing a SOM running the latest software.

### Flashing a developer's SD card image
Once the image is downloaded. Extract the image:
```
~/Downloads/som60sd$ tar -xvf som60sd-laird-7.x.y.z.tar.bz2
som60sd-laird-7.x.y.z/
som60sd-laird-7.x.y.z/target-sbom
som60sd-laird-7.x.y.z/host-sbom
som60sd-laird-7.x.y.z/u-boot-spl.bin
som60sd-laird-7.x.y.z/u-boot.itb
som60sd-laird-7.x.y.z/rootfs.tar
som60sd-laird-7.x.y.z/som60sd-sdk.tar.bz2
som60sd-laird-7.x.y.z/legal-info.tar.bz2
som60sd-laird-7.x.y.z/kernel.itb
som60sd-laird-7.x.y.z/mksdcard.sh
som60sd-laird-7.x.y.z/mksdimg.sh

```
To flash the image to an SD card use the mksdcard.sh script. The mksdcard.sh script takes the target device as an argument and will ask if you'd like to proceed with removing all data on your SD card and flashing a new image.  This is shown below:
```
~/Downloads/som60sd-laird-7.x.y.z$ sudo ./mksdcard.sh /dev/sdc
[sudo] password for user:
*************************************************************************
WARNING: All data on /dev/sdc now will be destroyed! Continue? [y/n]
*************************************************************************
[Partitioning /dev/sdc...]
1024+0 records in
1024+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.653846 s, 1.6 MB/s
DISK SIZE - 1967128576 bytes
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 1.9 GiB, 1967128576 bytes, 3842048 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Created a new DOS disklabel with disk identifier 0x59c337f4.
Created a new partition 1 of type 'W95 FAT16 (LBA)' and of size 48 MiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 1.8 GiB.
/dev/sdc3:
New situation:

Device     Boot  Start     End Sectors  Size Id Type
/dev/sdc1  *      2048  100351   98304   48M  e W95 FAT16 (LBA)
/dev/sdc2       100352 3842047 3741696  1.8G 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
[Making filesystems...]
[Copying files...]
[Done]
```
You can now insert your SD card into the SOM hardware development kit and press the reset button to boot into the new SD card image.

### Flashing a developer's SD card image on Windows 7 or later

If you are not able to access USB flash drives on a virtual machine, here is a way to flash the image on windows. You have to download and install [balenaEtcher](https://www.balena.io/etcher/) first.
```
1. Build an image on ubuntu after download and extract som60sd-laird-7.x.y.z.tar.bz2:
   ~/Downloads/som60sd-laird-7.x.y.z$ sudo ./mksdimg.sh sdimage
   and copy sdimage.xz to Windows.

3. Go to Windows Start menu and click `balenaEtcher`, then select sdimage.xz as source file and sd card as the target.

4. Click `Flash` and wait until it finishes.
```

### Using a prebuilt SDK

Laird Linux releases include a prebuilt SDK to start doing application development for a Laird SOM. For the 60 SOM, this prebuilt SDK is called som60sd-sdk-A.B.C.D.tar.bz2 and can be found with each release at the [60 SOM release page](https://github.com/LairdCP/SOM60-Release-Packages/releases). The prebuilt SDK includes the toolchain and all development files of the software packages used to generate the prebuilt SD card image from that release. The SDK can be set up for use with an IDE to allow application developers to not need a full BSP on their system. To use the SDK, extract the SDK tarball then run the script relocate-sdk.sh (located at the top directory of the SDK), to make sure all paths are updated with the new location. For more information on using SDKs generated from Laird's Buildroot fork, see the [Buildroot manual's section on the SDK](https://buildroot.org/downloads/manual/manual.html#_advanced_usage).

### Manifest file

Laird provides manifest files for customers to obtain released resources. Each manifest file describes the projects that are available and how to fetch them. A typical manifest file has `remote`, `default` and `project` elements. The `remote` element specifies the git url and revision shared by one or more projects. The `default` element specifies the the default `remote` element to be used by projects. The `project` element specifies the repository to be cloned. Its `name` attribute will be appended to the `remote` git url to generate the actual address. The `path` attribute defines the relative path to the top working directory to place the project. Following is an example of the manifest file:
```
<?xml version="1.0" encoding="UTF-8">
<manifest>
    <remote name="origin" fetch="ssh://git@github.com/LairdCP" />
    <default remote="origin" revision="refs/tags/LRD-REL-7.x.y.z" />
    <project path="som-external" name="som-external.git" />
 </manifest>
```
A `remote` element is defined here, which is also the default. Project `som-external.git` will be fetched from `https://github.com/LairdCP/som-external.git` with revision `refs/tags/LRD-REL-7.x.y.z`.

### Downloading the board support package source code

First step, pick which release you want. Odds are you want the most recent of your release.

Next, use repo to initalize and fetch your release. This is a two-step process: first you tell repo which manifest to use and then you tell it to fetch everything.

    mkdir lrd-7.x.y.z
    cd lrd-7.x.y.z
    repo init -u git@github.com:LairdCP/SOM60-Release-Packages.git -m som60_7.x.y.z.xml
    repo sync

_Note: Repo will initialize a .repo directory and then place all files directly in the directory that you are in when you run the `repo` command. So we recommend making a subdirectory and working in there._

### Building the SD Card developer's image
Once your repo sync is finished, you are ready to build your own SD card image. This can be achieved by the following:

    make -C som-external/ som60sd

Once your build completes, you will find the output similar to below:
```
~/git/lrd-7.x.y.z$ cd buildroot/output/som60sd/images/
~/git/lrd-7.x.y.z/buildroot/output/som60sd/images$ ls -al
at91-dvk_som60.dtb
boot.scr -> ../../../board/laird/configs-common/image/boot_mmc.scr
Image
Image.gz
kernel.itb
kernel.its
mksdcard.sh -> ../../../board/laird/scripts-common/mksdcard.sh
mksdimg.sh -> ../../../board/laird/scripts-common/mksdimg.sh
rootfs.tar
som60sd-laird.tar.bz2
u-boot.dtb
u-boot.itb
u-boot.its -> ../../../board/laird/configs-common/image/u-boot.its
u-boot-nodtb.bin
u-boot.scr -> ../../../board/laird/configs-common/image/u-boot_mmc.scr
u-boot.scr.itb
u-boot.scr.its -> ../../../board/laird/configs-common/image/u-boot.scr.its
u-boot-spl.bin
u-boot-spl.dtb
u-boot-spl-nodtb.bin

```
Go to images/ and run `sudo ./mksdcard.sh /dev/sd-device` to flash the SD card.

### Building the NAND image
NAND image can be built by the following:

    make -C som-external/ som60

Once your build completes, you will find the output similar to below:
```
~/git/lrd-7.x.y.z$ cd buildroot/output/som60/images/
~/git/lrd-7.x.y.z/buildroot/output/som60/images$ ls -al
at91-dvk_som60.dtb
boot.bin
boot.scr
erase_data.sh -> ../../../board/laird/scripts-common/erase_data.sh
Image
Image.gz
kernel.itb
kernel-nosig.itb
keys/
pmecc.bin
rootfs.bin
rootfs.squashfs
rootfs.verity
rootfs.verity.header
som60-laird.tar.bz2
som60.swu
sw-description
u-boot.dtb
u-boot.dtb.enc
u-boot-env.tgz -> ../../../board/laird/configs-common/image/u-boot-env.tgz
u-boot.itb
u-boot.its -> ../../../board/laird/configs-common/image/u-boot-enc.its
u-boot-nodtb.bin
u-boot-nodtb.bin.enc
u-boot.scr -> ../../../board/laird/configs-common/image/u-boot.scr
u-boot.scr.itb
u-boot.scr.itb.enc
u-boot.scr.its -> ../../../board/laird/configs-common/image/u-boot.scr.its
u-boot-spl.bin
u-boot-spl.dtb
u-boot-spl-nodtb.bin

```
`som60.swu` is the image for software update.

### Software update
SOM60 adopts the concept of double copy(A/B system) to improve safety and reliability. Each copy contains both the kernel and rootfs images. The u-boot envirnoment variable 'bootside' determines the working copy.

Software update is performed efficiently with SWUpdate. All images and scripts are appended to a single .swu file by the Buildroot. In addition, it must have a description file to specify software collections and operation modes to implement the double copy strategy. By default the SOM60 description file has five collections: `main-a`, `main-b`, `full-a`, `full-b` and `complete`. `main-a(b)` is to update kernel and rootfs images of copy `a(b)`. `full-a(b)` will also update bootstrap and u-boot images. `complete` is for SOM60SD only. It will re-partition and then program the entire NAND, thus to initialize a SOM60 device.

SOM60 supports 4 ways to update software: `local update`, `auto update`, `download update` and `upload update`. Update is performed according to the selected collection. However, it is not allowed to update the kernel and rootfs of the working copy. We have to run `fw_printenv bootside` to get the correct standby copy information for local update and download update. The u-boot environment variable 'bootside' will be automatically updated when it is completed. Reboot is required to run the new image.
1. Local update

   Insert a USB disk with .swu file(USB disk must be formatted to fat32 or ext4), which will be automatically mounted to `/media/`. Perform software update by setting the collection, i.g 'main-a', 'full-b':

       swupdate -e stable,<collection>  -i </path/to/swu/file>

2. Auto update(secure update service needs to be enabled)
   Insert a USB disk with .swu file(USB disk must be formatted to fat32 or ext4). The secure update service checks whether file `/media/sda1/swupdate.swu` exists, and then starts an update;

3. Download update

    Software can be updated remotely if a http server is available. Make sure .swu file is already in the web directory before update begins.

        swupdate -e stable,<collection> -d "-u <url of .swu file>"

4. Upload update(web service needs to be enabled)

   Login as `root`, and then go to software update page by clicking `Firmware Update`. Select the .swu file for update and click 'Update' button. Wait until flashing is completed or failed.

### Setup web server
Python's simple built-in web server here. Go to the dir where images are saved, and run following command to start the web service
```
python -m SimpleHTTPServer 8000
```
For python3, the command is
```
python3 -m http.server 8000
```

### Buildroot cache
In order to speed up builds, set up a Buildroot cache to store sources that Buildroot will download. Off your home directory:

    mkdir ~/.br2_dl_dir

Then add it to your build environment:

    export BR2_DL_DIR="${HOME}/.br2_dl_dir"

### Create a custom SDK
If you'd like to create a custom SDK from your customized source build, while in the target's output directory, issue a `make sdk`:
```
~/git/lrd-7.x.y.z/buildroot/output/som60sd$ make sdk
```
## NetworkManager
Laird uses its own customized fork of NetworkManager for networking configuration, including WiFi profile management. For more information on using NetworkManager please see our [Laird NetworkManager User Guide](https://github.com/LairdCP/SOM60-Release-Packages/releases/download/LRD-REL-6.0.0.138/user_guide_laird_networkmanager_0.1.pdf).

## Firewalld
Laird uses `firewalld` as its network security system. Firewalld provides a dynamically managed firewall, which allows updating rules without breaking existing connections. Firewalld uses zones and services instead of tables and chains. A firewalld zone defines the trust level for a connection, an interface etc., while a firewalld service is mainly a list of local ports and destinations. `firewalld` has predefined zones and services located in `$(TARGET_DIR)/usr/lib/firewalld/zones` and `$(TARGET_DIR)/usr/lib/firewalld/services`. The default zone is set to `trusted` on SOM60, which will accept all network connections. Default zone can be changed in `$(TARGET_DIR)/etc/firewalld/firewalld.conf`.

`firewall-cmd` is the command line tool of the firewalld daemon. It provides interface to manage runtime and permanent rule sets. By default, it applies to the runtime set; with the --permanent flag it applies to the permanent set. These permanent rules will be saved in corresponding xml files in /etc/firewalld/. To activate a permanent rule, either add the rule to both sets, or add the rule to the permanent set only and then reload firewalld configuration.
```
To start firewalld: systemctl start firewalld
To stop firewalld: systemctl stop firewalld
To check the firewalld status: firewall-cmd --state
To save runtime rules as permanent: firewall-cmd --runtime-to-permanent
To reload firewalld configuration: firewall-cmd --reload
```
Port forwarding

If we want to access the webserver through `wlan0` interface (http service not enabled in 'external' zone), port forwarding can be used:

firewall-cmd --zone=external --add-forward-port=port=80:proto=tcp:toport=80:toaddr=10.42.0.1 ('10.42.0.1' is the ip address of eth1 interface)

This can be removed by

firewall-cmd --zone=external --remove-forward-port=port=80:proto=tcp:toport=80:toaddr=10.42.0.1

Make sure `masquerade` is enabled for the zone needs port forwarding.

Rich Rules

Rich Rules allows to add fully custom firewall rules to any zone for any port, protocol, address and action. `--add-rich-rule`, `--list-rich-rules` and `--remove-rich-rule` are used to manage rich rules. The following rule will reject all connections from wifi client '10.42.0.122':

	firewall-cmd --zone=internal --add-rich-rule='rule family="ipv4" source address="10.42.0.122" reject'

This can be removed by

	firewall-cmd --zone=internal --remove-rich-rule='rule family="ipv4" source address="10.42.0.122" reject'

### Firewalld example 1
The first example is about sharing WIFI Internet (wlan0) through ethernet interface (eth1).
```
1. Create a connection "eth1" for ethernet interface "eth1"; create a connection "wlan0" for wifi
   interface "wlan0". Set connection.zone for both connections:
       nmcli c mod eth1 connection.zone internal
       nmcli c mod wlan0 connection.zone external
   "internal" and "external" are firewalld’s predefined zones.
   Set ipv4.method to "shared" for "eth1" connection:
       nmcli c mod eth1 ipv4.method shared
   Reload connections:
       nmcli c reload
2. Change default firewalld zone to "internal". Changes will be applied to the default zone if "--zone" not
   specified in the firewall-cmd tool.
       firewall-cmd --set-default-zone=internal
   Check the default zone is changed by
       firewall-cmd --get-default-zone
   Zone infomation can be listed by
       firewall-cmd --zone=internal --list-all
3. Add interface "wlan0" to "external" zone, and interface "eth1" to "internal" zone:
       firewall-cmd --zone=external --add-interface=wlan0
       firewall-cmd --zone=internal --add-interface=eth1
       firewall-cmd --get-active-zones should show `internal` and `external` as active zones.
4. "firewall-cmd --get-services --zone=internal" will show the services already added to the zone:
   Here we need to enable "dhcp" service so that wifi clients can get IP address:
       firewall-cmd --add-service=dhcp
   DNS needs to be enabled if clients want to access webs
       firewall-cmd --add-service=dns
   Services can be removed by
       firewall-cmd --remove-service=service_name --permanent
5. For the "external" zone, "masquerade" should be already enabled. This can be queried by:
       firewall-cmd --query-masquerade --zone=external
   If not enabled, enable it by:
       firewall-cmd --add-masquerade --zone=external
7. In order to access the webserver on SOM60 via "eth1" interface, "http" servcie needs to be
   added to the "internal" zone:
       firewall-cmd --add-service=http
```
   Now clients should be able to connect to Internet via `wlan0`. You can save runtime rules as permanent so they will be applied automatically after reboot.

### Firewalld example 2
The second example is about sharing eth0 Internet through a bridge interface. Interface eth1 and wlan0 will be bridged so the device connected to eth1 and wifi stations connected to "somtouer"
will be in the same network.
```
1. Create a bridge master "br-master":
       nmcli con add type bridge con-name br-master autoconnect no ifname br0
       nmcli con mod br-master ipv4.method shared connection.zone internal
2. Create a wifi AP as a bridge slave:
        nmcli conn add con-name br-slave-wlan0 ifname wlan0 type wifi autoconnect yes ssid somrouter master br0
        nmcli conn modify br-slave-wlan0 802-11-wireless.mode ap 802-11-wireless.band bg 802-11-wireless.channel 6
        nmcli conn modify br-slave-wlan0 802-11-wireless-security.key-mgmt wpa-psk 802-11-wireless-security.psk 12345678
3. Create a eth1 connection as bridge slave:
        nmcli conn add con-name br-slave-eth1 ifname eth1 type 802-3-ethernet autoconnect yes master br0
4. Create eth0 connection for Internet access:
        nmcli conn add con-name eth0 ifname eth0 type 802-3-ethernet autoconnect no
        nmcli conn mod eth0 connection.zone external
5. Set firewall rules:
        firewall-cmd --set-default-zone=internal
        firewall-cmd --add-service=dhcp --add-service=dns --add-service=http --add-service=https
        firewall-cmd --add-masquerade --zone=external
6. Activate bridge master and eth0
        nmcli c up eth0
        nmcli c up br-master
```
Make sure all other connections that use `eth1` interface and `wlan0` interface are already disconnected. Otherwise bridge slaves won't be activated.

## Laird Buildroot br2-external
The br2-external mechanism provides a convenient way to customize project specific configure files, packages etc. outside of the Buildroot source tree. Following is an example layout of Laird Buildroot br2-external tree:
```
|--Config.in
|--external.desc
|--external.mk
|--Makefile
|--configs/
|    |--buildroot_defconfig
|--board/
|    |--rootfs-additions/
|    |--kernel_defconfig
|    |--u-boot_defconfig
|    |--u-boot.scr
|    |--post_build.sh
|    |--post_image.sh
|    |--kernel-dts/
|    |    |--kernel.dts
|    |--uboot-dts/
|    |    |--uboot.dts
|--package/
|    |--package-1/
|    |    |--Config.in
|    |    |--package-1.mk
|    |    |--src/
|    |--package-2/
|         |--Config.in
|         |--package-2.mk
|         |--package-2.hash
|--README
```
`external.desc`: provides the `name` and an optional short description for the br2-external tree:
```
name: DEMO
desc: Laird Custom Project Demo
```
 The full path of the br2-external tree will be set to `BR2_EXTERNAL_$(NAME)_PATH` automatically so that it can be used in both Buildroot Kconfig and Makefile. In this case `BR2_EXTERNAL_DEMO_PATH` is set to the full path of `demo` project.

`Config.in`: define custom package recipes with `external.mk` so they are visible to the top-level Buildroot configuration menu:
```
source "$BR2_EXTERNAL_DEMO_PATH/package/package-1/Config.in"
source "$BR2_EXTERNAL_DEMO_PATH/package/package-2/Config.in"
```
`external.mk`: define custom package recipes with `Config.in` so they can be built by the Buildroot make logic.
```
include $(sort $(wildcard $(BR2_EXTERNAL_DEMO_PATH)/package/*/*.mk))
```

`Makefile`: defines the build targets
```
TARGETS = demo

MK_DIR = $(realpath $(dir $(firstword $(MAKEFILE_LIST)))))
BR_DIR = $(realpath $(MK_DIR)/../buildroot)

include $(BR_DIR)/board/laird/build-rules.mk
```
Run `make -C <custom-project-dir> demo` to invoke the build.

`configs`: where Buildroot configure files for the custom project are saved. Run `make menuconfig` to configure kernel, u-boot, packages etc. Run `make savedefconfig` to save it.

`board`: where custom board support files and configures are saved, including kernel and u-boot configures, scripts, files need installed to the target rootfs, etc.

Board support files and configures

Board support files and configures are used to customize kernel, uboot, target rootfs and even the images.

To customize kernel with kernel_defconfig, go to `Buildroot-->Kernel-->Configuration file path` and set it to `($(BR2_EXTERNAL_$(DEMO)_PATH)/board/kernel_defconfig`.

To customize uboot with uboot_defconfig, go to `Buildroot-->Bootloaders-->Configuration file path` and set it to `($(BR2_EXTERNAL_$(DEMO)_PATH)/board/u-boot_defconfig`.

To customize kernel device tree with kernel.dts, go to `Buildroot-->Kernel`, enable `Build a Device Tree Blob (DTB)` and set `Out-of-tree Device Tree Source file paths` to `($(BR2_EXTERNAL_$(DEMO)_PATH)/board/kernel-dts/kernel.dts`. If there are more than one dts files, a list of dts paths separated by space needs to be provided.

To customize uboot device tree with uboot.dts, go to `Buildroot-->Bootloaders-->Device Tree Source file paths` and set it to `($(BR2_EXTERNAL_$(DEMO)_PATH)/board/uboot-dts/uboot.dts`. If there are more than one dts files, a list of dts paths separated by space needs to be provided.

To customize target rootfs, go to
`Buildroot-->System configuration-->Custom scripts to run before creating filesystem images` and set it to `($(BR2_EXTERNAL_$(DEMO)_PATH)/board/post_build.sh`. A typical usage of post_build.sh is to install custom materials to the target rootfs:
```
1 rsync -rlptDWK --exclude=.empty "${BR2_EXTERNAL_DEMO_PATH}/board/rootfs-additions/" "${TARGET_DIR}"
2
3 ${BASE_DIR}/../../board/laird/som60/post_build.sh ${1} ${2}
```
Line 3 is to invoke the post-build script in the Buildroot source tree.

To customize images, go to `Buildroot-->System configuration-->Custom scripts to run after creating filesystem images` and set it to `($(BR2_EXTERNAL_$(DEMO)_PATH)/board/post_image.sh`. However, this is not encouraged as it may result in corrupted images and boot faiulre.

To customize u-boot environment, the u-boot script file `u-boot.scr` in the Buildroot source tree needs to be overridden. This can be done by appending a line to the post_build.sh:
```
ln -rsf ${BR2_EXTERNAL_DEMO_PATH}/board/u-boot.scr ${BINARIES_DIR}/u-boot.scr
```
The custom `u-boot.scr` must contain following information to boot the device. New environment varaibles should be added to the begin of the script.
```
if test ${bootside} = a;
then
    setenv bootvol 1
else
    setenv bootvol 4
fi

ubi part ubi
ubi read 0x21000000 kernel_${bootside}
source 0x21000000:script
bootm 0x21000000
```

Add a custom package

Here is the instruction to add a custom package `test`, assuming its source code is saved in `package/test/src`:
1. Go to the `demo` project and run `mkdir -p package/test/`;
2. Go to `package/test/` and create Config.in, which basically contains:
```
    config BR2_PACKAGE_TEST
        bool "test"
        depends on BR2_PACKAGE_LIBA
        select BR2_PACKAGE_LIBB
        help
            This is an example to add a package to the br2-external tree.
```
3. Create test.mk, which describes how to copy/download, configure, build and install the package:
```
    TEST_VERSION = 1.0.0
    TEST_SITE = $(BR2_EXTERNAL_DEMO_PATH)/package/test/src
    TEST_SITE_METHOD = local
    TEST_LICENSE = GPL-3.0+
    TEST_LICENSE_FILES = COPYING
    TEST_DEPENDENCIES = liba libb

    define TEST_BUILD_CMDS
        $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
    endef

    define TEST_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 0755 $(@D)/test $(TARGET_DIR)/usr/sbin/
    endef

    $(eval $(generic-package))
```
4. Append following line to demo/Config.in

    source "$BR2_EXTERNAL_DEMO_PATH/package/test/Config.in"

Now the package can be configured and built within the Buildroot.
More information is available at (https://buildroot.org/downloads/manual/manual.html#adding-packages).

Add a package from manifest

To add a custom package from github etc, a `project` elemenent needs to be added to the manifest file .repo/manifests/custom.xml:

    <project path="demo/package/externals/test" name="test.git">

where `externals/test` is the place to save the source code of the package. If the project is in a repository other than the default, a `remote` element also needs to be added

    <remote name="custom" fetch="ssh://git@github.com/custom" />
    <project remote="custom" path="demo/package/externals/test" name="test.git" revision="custom-7.x.y.z">

Run `repo sync` to fetch the source code, and then follow the instruction of `Add a custom package` to make it configurable and buildable.

## Filesystem
This section describes the filesystem and booting strategies for all products based on the 60 Series SOM. These products introduce a new set of features that changes the way the embedded Linux filesystems are built and programmed onto the embedded NAND flash.

### What's Changed?
The following is a brief description of the changes from Laird's previous system on module (the WB50NBT) to the 60 Series SOM:

    AT91Bootstrap has been replaced with U-Boot SPL
    U-Boot is now programmed as a FIT (flattened device tree) image
    The kernel is now programmed as FIT image
    The kernel, rootfs, and overlay filesystems are now stored as UBI volumes inside of a single UBI disk
    (Optional) FIT image signing is enabled to verify both U-Boot and the kernel
    (Optional) DM-Verity is enabled to verify the data stored on the rootfs is authentic

### Detailed Description
The following is a detail description of the new components & strategies.

#### U-Boot SPL
AT91Bootstrap has been replaced as the first-level bootloader, by U-Boot SPL. This is pretty much a transparent change for developers; the new bootloader resides in the same location in NAND flash (0x00000000 - 0x00020000). The change was made to enable the use of FIT image signing, so that U-Boot SPL can verify U-Boot.

#### U-Boot FIT Image
U-Boot (the second-stage bootloader) is now built as a FIT (flattened image tree) image. (For this reason, the name of the artifact is now u-boot.itb, which denotes a binary FIT image). This enables U-Boot to contain its own device tree, which can also be used to contain keys that are used to verify the kernel image.

#### Kernel FIT Image
The kernel is now built as a FIT (flattened image tree) image. (For this reason, the name of the artifact is now kernel.itb, which denotes a binary FIT image). The kernel's device tree is now contained within the FIT image, so that it can be signed inside of a configuration (verified using the key stored in U-Boot). The kernel FIT image may also contain a script file that is used to mount the rootfs. This is done so that the script can (optionally) verify the root hash of the rootfs (known as the "verity" hash, provided by the verity module). For this reason, when verity is enabled, the kernel FIT image and the rootfs are paired and must always be flashed together.

#### UBI Disk Layout
The kernel, rootfs, and overlay file systems are now stored as UBI ''volumes'' contained within a single (large) UBI disk. This change improves wear-leveling and fault tolerance, since the volumes are stored in blocks across the entire disk. This changes the way the kernel and rootfs are flashed on the device. Both U-Boot and the kernel are informed (via their device trees) of the single UBI disk. The volume information (size, etc.) is contained within the UBI disk itself (not stored in the device configuration). For convenience, U-Boot has a script, `_ubiformat`, which performs formatting of the UBI disk and creation of all the named volumes required for an A/B kernel and rootfs.

### Tips & Tricks
#### Custom UBI Volume Sizes
Since the UBI volumes are dynamic (stored in the UBI disk), you can easily change the formatting (for example, if you don't need a "B" configuration during development, then you can reclaim that space for development use in the "A" side.) Just use the `_ubiformat` script as a template to format the UBI disk and create the partitions.

