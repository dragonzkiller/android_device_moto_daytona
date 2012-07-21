/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [MOT] qcf001: Ported changes from SKT build

#define LOG_TAG "bluedroid"

#include <errno.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <stdio.h>
#include <stdlib.h>

#include <sys/mman.h>

#include <cutils/log.h>
#include <cutils/properties.h>

#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>

#include <bluedroid/bluetooth.h>

#ifndef HCI_DEV_ID
#define HCI_DEV_ID 0
#endif

#define HCID_START_DELAY_SEC  1
#define HCID_STOP_DELAY_USEC 500000

#define MIN(x,y) (((x)<(y))?(x):(y))

#define BLUETOOTH_POWER_PATH "/proc/bt_power"

//////////////////////////////////////////////////////////////////////
static int rfkill_id = -1;
static char *rfkill_state_path = NULL;

static int init_rfkill()
{
    return(0);
}

//////////////////////////////////////////////////////////////////////
static int check_bluetooth_power() 
{
  char b[64];

  int fd = open(BLUETOOTH_POWER_PATH, O_RDONLY);

  if(fd == -1)
    {
      printf("Can't open %s for reading: %s\n", BLUETOOTH_POWER_PATH); 
      perror(BLUETOOTH_POWER_PATH); 
      return(-1);
    }

  if(0 == read(fd, b, 63))
    {
      printf("Can't read from %s\n", BLUETOOTH_POWER_PATH); 
      perror(BLUETOOTH_POWER_PATH); 
      close(fd);
      return(-1);
    }

  close(fd);

  int r=0; if('1' == *b){r = 1;}
  return(r);
}
//////////////////////////////////////////////////////////////////////
static int set_bluetooth_power(int on) 
{
  int ret = -1;
  int sz;

  const char buffer = (on ? '1' : '0');
  int fd = open(BLUETOOTH_POWER_PATH, O_WRONLY | O_APPEND);

  if (fd == -1) 
    {
      ALOGE("Can't open %s for write: %s (%d)", 
	   BLUETOOTH_POWER_PATH, strerror(errno), errno);
      goto out;
    }

  sz = write(fd, &buffer, 1);
  if ((sz != 1) && (sz != 0))
    {
      ALOGE("Can't write to %s: %s (%d)", 
	   BLUETOOTH_POWER_PATH, strerror(errno), errno);
      goto out;
    }
  ret = 0;

 out:
  if (fd >= 0) close(fd);
  return ret;
}

//////////////////////////////////////////////////////////////////////
static inline int create_hci_sock()
{
    int sk = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
    if (sk < 0) {
        ALOGE("Failed to create bluetooth hci socket: %s (%d)",
             strerror(errno), errno);
    }
    return sk;
}

struct RefBase_s{
    unsigned int magic;
    unsigned int base;
};

static const char const * REF_FILE = "/tmp/bluedroid_ref";
static const unsigned int MAGIC = 0x55665566;
static int bt_ref_fd = -1;
static int bt_ref_lock()
{
    int ret = -1;
    /*l_type l_whence l_start l_len l_pid*/
    struct flock fl = {F_WRLCK,    SEEK_SET,  0,        0,      0};

    ALOGI("Enter bt_ref_lock");
    if ((bt_ref_fd = open(REF_FILE, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP)) == -1)
    {
        ALOGW("open or create bluedroid_ref error");
        ret = -2;
        goto out;
    }

    ALOGI("Trying to get lock ....");

    if (fcntl(bt_ref_fd, F_SETLKW, &fl) == -1)
    {
        ALOGW("F_SETLKW failed");
        ret = -1;
        goto out;
    }

    ALOGI("got lock");
    ret = 0;
out:
    return ret;
}

static int bt_ref_unlock()
{
    int ret = -1;
    ALOGI("Enter bt_ref_unlock");
    if(bt_ref_fd != -1) close(bt_ref_fd);
    ret = 0;
    return ret;
}

static int bt_ref_modify(int change)
{
    struct RefBase_s ref = {magic : MAGIC, base : 0};
    int ret = -1;
    int magic = MAGIC;

    ALOGI("Enter bt_ref_modify");

    if (change != 1 && change != -1) {
        ALOGE("Invalid change, use only 1 or -1");
        ret = -1;
        goto out;
    }

    if (read(bt_ref_fd, (void *)&ref, sizeof(ref)) == -1)
    {
        ALOGW("read reference count error");
        ret = -1;
        goto out;
    }

    if(ref.magic != MAGIC)
    {
        ALOGV("reference file magic number is wrong, do reset");
        ref.magic = MAGIC;
        ref.base = 0;
    }

    if(ref.base > 3) ALOGE("reference count > 3 base = %d", ref.base);

    ref.base += change;

    lseek(bt_ref_fd, 0, SEEK_SET);

    if (write(bt_ref_fd, (const void*)&ref, sizeof(ref)) == -1)
    {
        ALOGE("write reference count failed");
        ret = -1;
        goto out;
    }

    ret = ref.base;
    ALOGI("Exit bt_ref_modify ref = %d", ret);
out:
    return ret;
}

int bt_enable() {
    ALOGV(__FUNCTION__);

    int ret = -1;
    int hci_sock = -1;
    int attempt;

    int refcount = 0;
    bt_ref_lock();
    //1. check whether bt has ben enabled.
    if(bt_is_enabled() == 1)
    {
        ALOGI("bt has been enabled already. inc reference count only");
        //2. Increase reference count
        refcount = bt_ref_modify(1);
        ALOGV("after inc : reference count = %d", refcount);
        bt_ref_unlock();
        return 0;
    }

    if (set_bluetooth_power(1) < 0) goto out;

    ALOGI("Starting bt_start");
    if (property_set("ctl.start", "bt_start") < 0) {
      ALOGE("Failed to start bt_start");
      goto out;
    }

    // Try for 15 seconds, this can only succeed once hciattach has sent the
    // firmware and then turned on hci device via HCIUARTSETPROTO ioctl
    hci_sock = create_hci_sock();
    if (hci_sock < 0) goto out;
    for (attempt = 1000; attempt > 0;  attempt--) {

        if (!ioctl(hci_sock, HCIDEVUP, HCI_DEV_ID)) {
            break;
        }
        usleep(10000);  // 10 ms retry delay
    }
    if (attempt == 0) {
        ALOGE("%s: Timeout waiting for HCI device to come up", __FUNCTION__);
        goto out;
    }

    ALOGI("Starting bluetoothd daemon");
    if (property_set("ctl.start", "bluetoothd") < 0) {
        ALOGE("Failed to start bluetoothd");
        goto out;
    }
    sleep(HCID_START_DELAY_SEC);

    ret = 0;

out:
    if (hci_sock >= 0) close(hci_sock);

    if(0 == ret)
    {
        //3. Increase reference count.
        refcount = bt_ref_modify(1);
        ALOGV("after inc : reference count = %d", refcount);
    }
    bt_ref_unlock();

    return ret;
}

//////////////////////////////////////////////////////////////////////
int bt_disable()
{
    ALOGV(__FUNCTION__);


    int ret = -1;
    int hci_sock = -1;

    ALOGV("bt_disable Entered");

    int refcount = 0;
    bt_ref_lock();
    
    //1. Decrease reference count
    refcount = bt_ref_modify(-1);

    //2. Check reference cout
    ALOGV("after dec : reference count = %d", refcount);
    if(refcount > 0)
    {
        ALOGV("bt_disable: other app using bt so just do noting");
        bt_ref_unlock();
        return 0;
    }
    //3. If reference cout == 0, disable bt
    //4. bt still used by other app, return then.

    ALOGI("Stopping bluetoothd deamon");
    if (property_set("ctl.stop", "bluetoothd") < 0) {
        ALOGE("Error stopping bluetoothd");
        goto out;
    }
    usleep(HCID_STOP_DELAY_USEC);

    hci_sock = create_hci_sock();
    if (hci_sock < 0) goto out;
    ioctl(hci_sock, HCIDEVDOWN, HCI_DEV_ID);

    ALOGI("Starting bt_stop");
    if (property_set("ctl.start", "bt_stop") < 0) {
        ALOGE("Failed to start bt_stop");
        goto out;
    }

    if (set_bluetooth_power(0) < 0) {goto out;}
    ret = 0;
    
out:
    if (hci_sock >= 0) close(hci_sock);

    bt_ref_unlock();

    return ret;
}

//////////////////////////////////////////////////////////////////////
int bt_is_enabled() {
    ALOGV(__FUNCTION__);

    int hci_sock = -1;
    int ret = -1;
    struct hci_dev_info dev_info;


    // Check power first
    ret = check_bluetooth_power();
    if (ret == -1 || ret == 0) goto out;

    ret = -1;

    // Power is on, now check if the HCI interface is up
    hci_sock = create_hci_sock();
    if (hci_sock < 0) goto out;

    dev_info.dev_id = HCI_DEV_ID;
    if (ioctl(hci_sock, HCIGETDEVINFO, (void *)&dev_info) < 0) {
        ret = 0;
        goto out;
    }

    //ret = hci_test_bit(HCI_UP, &dev_info.flags); // OLD WAY
    if (dev_info.flags & (1 << (HCI_UP & 31))) {
        ret = 1;
    } else {
        ret = 0;
    }

out:
    if (hci_sock >= 0) close(hci_sock);
    return ret;
}

//////////////////////////////////////////////////////////////////////
int ba2str(const bdaddr_t *ba, char *str) {
    return sprintf(str, "%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X",
                ba->b[5], ba->b[4], ba->b[3], ba->b[2], ba->b[1], ba->b[0]);
}

//////////////////////////////////////////////////////////////////////
int str2ba(const char *str, bdaddr_t *ba) {
    int i;
    for (i = 5; i >= 0; i--) {
        ba->b[i] = (uint8_t) strtoul(str, &str, 16);
        str++;
    }
    return 0;
}

//////////////////////////////////////////////////////////////////////
