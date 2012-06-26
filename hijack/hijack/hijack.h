#ifndef __HIJACK_H__
#define __HIJACK_H__

// declare all of our includes
#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <limits.h>
#include <linux/input.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <dirent.h>
#include <signal.h>
#include <sys/reboot.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/limits.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <cutils/properties.h>

// sleepwait time (we default to MAX_INT fur die lulz)
#ifndef HIJACK_SLEEPWAIT_SEC
#define HIJACK_SLEEPWAIT_SEC UINT_MAX
#endif

// file that throws us into recovery mode
#ifndef RECOVERY_MODE_FILE
#define RECOVERY_MODE_FILE "/data/.recovery_mode"
#endif

// if we enable logging...
#ifdef LOG_ENABLE
// log device
#ifndef LOG_DEVICE
#define LOG_DEVICE "/dev/block/mmcblk1p1" // default to SD card
#endif
// log mount point
#ifndef LOG_MOUNT
#define LOG_MOUNT "/sdlog" // default to SD logging
#endif
// log file name (will be placed under SDLOG_MOUNT)
#ifndef LOG_FILE
#define LOG_FILE "hijack.log" // this works
#endif
// script that dumps dmesg/logcat/etc
#ifndef LOG_DUMP_BINARY
#define LOG_DUMP_BINARY "/system/bin/hijack.log_dump"
#endif
// frequency of indefinite log
#define LOG_INDEF_FREQ "10s"
// convenience define
#define LOG_PATH LOG_MOUNT"/"LOG_FILE
#endif

// update-binary executable
#ifndef BOARD_HIJACK_UPDATE_BINARY
#define BOARD_HIJACK_UPDATE_BINARY "/preinstall/update-binary"
#endif

// boot update.zip
#ifndef BOARD_HIJACK_BOOT_UPDATE_ZIP
#define BOARD_HIJACK_BOOT_UPDATE_ZIP "/system/etc/hijack-boot.zip"
#endif

// recovery update.zip
#ifndef BOARD_HIJACK_RECOVERY_UPDATE_ZIP
#define BOARD_HIJACK_RECOVERY_UPDATE_ZIP "/preinstall/update-recovery.zip"
#endif

// function prototypes! :D
int exec_and_wait(char ** argp);
int remount_root(const char * hijack_exec, int rw);
int hijack_mount(const char * hijack_exec, const char * dev, const char * mount_point);
int hijack_umount(const char * hijack_exec, const char * mount_point);
void hijack_log(char * format, ...);
int mark_file(char * filename);

#endif
