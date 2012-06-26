#!/bin/sh

# Copyright (C) 2011 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VENDOR=moto
DEVICE=olympus

alias adb='adb.sh'

rm -rf ../../../vendor/$VENDOR/$DEVICE/* #dont delete the git folder
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/app
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/framework
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/firmware
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/flex
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wifi
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/ppp/peers
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/touchpad/20
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/touchpad/21
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/touchpad/22
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/permissions
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl
mkdir -p ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw

# system apps
#adb pull /system/app/PhoneConfig.apk ../../../vendor/motorola/$DEVICE/proprietary
#adb pull /system/app/ProgramMenu.apk ../../../vendor/motorola/$DEVICE/proprietary
#adb pull /system/app/ProgramMenuSystem.apk ../../../vendor/motorola/$DEVICE/proprietaryadb

# fingerprint stuff
#adb pull /system/bin/am2server ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
#adb pull /system/app/GfxEngine.apk ../../../vendor/$VENDOR/$DEVICE/proprietary/app
#adb pull /system/etc/am2server.pubkey ../../../vendor/$VENDOR/$DEVICE/proprietary/etc
#adb pull /system/lib/libAuthUDMDrv_1750A100.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
#adb pull /system/lib/libam2app.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
#adb pull /system/lib/libam2server.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib

# system libs
adb pull /system/lib/libmirror.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libextdisp.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libaudio.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libaudiopolicy.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libcgdrv.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_author.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_common.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_download.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_downloadreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_mp4local.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_mp4localreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_net_support.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_player.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_rtsp.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_rtspreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libOpenSLES.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libhwmediarecorder.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libhwmediaplugin.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libpppd_plugin-ril.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libpppd_plugin.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib


# video
adb pull /system/lib/libnvomx.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvomxilclient.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_aacdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_amrdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_avcdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_m4vdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_mp3dec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib

# Pull needed NV libs
adb pull /system/lib/librds_util.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libril.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libril_rds.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libtpa.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libtpa_core.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvddk_aes_user.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvddk_2d.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvddk_2d_v2.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvodm_dtvtuner.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvsm.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_utils.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvomxilclient.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_video.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvrm_channel.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvdispatch_helper.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_misc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_contentpipe.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvodm_misc.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_tracklist.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libctest.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libsensortest.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libam2app.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_service.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvodm_imager.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvodm_query.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvidia_display_jni.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvwsi.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_image.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_vp6_video.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvdispmgr_d.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_parser.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvomx.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvos.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvddk_audiofx.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvddk_2d.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvrm_graphics.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvwinsys.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvrm.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_manager.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvddk_aes_user.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_writer.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_videorenderer.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvidia_display_jni.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_audio.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libbattd.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_manager.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libmoto_ril.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnmea.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib


# Pull nvidia framework libs
#adb pull /system/framework/com.nvidia.display.jar ../../../vendor/$VENDOR/$DEVICE/proprietary/lib


# Pull nvidia EGL libs
adb pull /system/lib/egl/libEGL_tegra.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl
adb pull /system/lib/egl/libGLESv1_CM_tegra.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl
adb pull /system/lib/egl/libGLESv2_tegra.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/egl

# Pull HW libs
adb pull /system/lib/hw/gps.olympus.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw
adb pull /system/lib/hw/gralloc.tegra.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw
adb pull /system/lib/hw/overlay.tegra.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw
adb pull /system/lib/hw/lights.tegra.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw
adb pull /system/lib/hw/sensors.olympus.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw

# Pull bin files
adb pull /system/bin/mot_boot_mode ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/charge_only_mode ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_vc1dec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_wmaprodec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_h264dec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_service.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_adtsdec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_wavdec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_reference.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_sorensondec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_mp3dec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvddk_audiofx_core.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_sw_mp3dec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_aacdec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvrm_daemon ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_jpegenc.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvddk_audiofx_transport.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_mp2dec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/ap_gain.bin ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_mpeg4dec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_wmadec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_audiomixer.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_manager.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_jpegdec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvrm_avp.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/tund ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/battd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/touchpad ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/mdm_panicd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/rild ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/pppd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/testpppd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/secclkd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/pppd-ril ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/chat-ril ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/ftmipcd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/usbd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/akmd2 ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/whisperd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin

# LP Added----

# BIN 

adb pull /system/bin/fmradioserver ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/memtest_mode ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nv_hciattach ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/nvmm_wmaprodec.axf ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/remountpds ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/slateipcd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/tcmd ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/tegrastats ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/vpnclientpm ../../../vendor/$VENDOR/$DEVICE/proprietary/bin

# LIB

adb pull /system/lib/libfmradio_jni.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libfmradioplayer.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvidia_display_jni.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvec.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvwinsys.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_amrenc_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_author.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_common.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_download.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_downloadreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_mp4local.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_mp4localreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_net_support.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_player.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_rtsp.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_rtspreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libpixelflinger.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib

#-----------

# Pull BT files
adb pull /system/bin/bt_init ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/bin/bt_downloader ../../../vendor/$VENDOR/$DEVICE/proprietary/bin
adb pull /system/etc/bt_init.config ../../../vendor/$VENDOR/$DEVICE/proprietary/etc
adb pull /system/etc/BCM4329B1_002.002.023.0757.0780.hcd ../../../vendor/$VENDOR/$DEVICE/proprietary/etc

# Pull Wifi userland firmware
adb pull /system/etc/firmware/wifi/nvram.txt ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl
adb pull /system/etc/firmware/wifi/sdio-ag-cdc-11n-mfgtest-roml-seqcmds.bin ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl
adb pull /system/etc/firmware/wifi/sdio-ag-cdc-full11n-minioctl-roml-pno-wme-aoe-pktfilter-keepalive.bin ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl
adb pull /system/etc/firmware/wifi/sdio-g-cdc-roml-reclaim-wme-apsta-idauth-minioctl.bin ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/wl

# Pull camera files
adb pull /system/lib/libcamera.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libnvmm_camera.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib

# Pull OMX libs
adb pull /system/lib/libomx_aacdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_amrdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_amrenc_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_avcdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_m4vdec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_mp3dec_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libomx_sharedlibrary.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib

#pull subsystem configuration settings
adb pull /system/etc/touchpad/20/touchpad.cfg ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/touchpad/20
adb pull /system/etc/touchpad/21/touchpad.cfg ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/touchpad/21
adb pull /system/etc/touchpad/22/touchpad.cfg ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/touchpad/22
adb pull /system/etc/pvplayer.cfg ../../../vendor/$VENDOR/$DEVICE/proprietary/etc
adb pull /system/etc/ppp/peers/pppd-ril.options ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/ppp/peers

# Pull permissions
adb pull /system/etc/permissions/com.motorola.android.imirrorservice.xml ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/permissions
adb pull /system/etc/permissions/com.motorola.android.iextdispservice.xml ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/permissions

# Pull Opencore libs
adb pull /system/lib/libopencore_author.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_common.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_downloadreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_download.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_mp4localreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_mp4local.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_net_support.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_player.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_rtspreg.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib
adb pull /system/lib/libopencore_rtsp.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib

# Pull Stage Fright
adb pull /system/lib/libstagefrighthw.so ../../../vendor/$VENDOR/$DEVICE/proprietary/lib

#wgetable proprietaries
BASEURL="http://atrix-dev-team.github.com/android_vendor_motorola_olympus/"
wget "${BASEURL}touchpad.cfg" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/etc/touchpad/22/touchpad.cfg
wget "${BASEURL}FastDormancy.apk" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/app/FastDormancy.apk
wget "${BASEURL}AudioEffectSettings.apk" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/app/AudioEffectSettings.apk
wget "${BASEURL}battd" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/bin/battd
wget "${BASEURL}libbattd.so" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libbattd.so
wget "${BASEURL}libnmea.so" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libnmea.so
wget "${BASEURL}gps.olympus.so" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw/gps.olympus.so
wget "${BASEURL}libmoto_ril.so" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libmoto_ril.so
wget "${BASEURL}com.motorola.android.iextdispservice.jar" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/framework/com.motorola.android.iextdispservice.jar
wget "${BASEURL}com.motorola.android.imirrorservice.jar" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/framework/com.motorola.android.imirrorservice.jar
wget "${BASEURL}libmirrorjni.so" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libmirrorjni.so
wget "${BASEURL}MirrorService.apk" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/app/MirrorService.apk
wget "${BASEURL}ExtDispService.apk" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/app/ExtDispService.apk
wget "${BASEURL}libhdmi.so" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/libhdmi.so
wget "${BASEURL}overlay.tegra.so" -O ../../../vendor/$VENDOR/$DEVICE/proprietary/lib/hw/overlay.tegra.so

./setup-makefiles.sh
