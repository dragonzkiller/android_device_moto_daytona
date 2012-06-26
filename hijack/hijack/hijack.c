#include "hijack.h"

#ifdef USE_RECOVERY_HIJACK
#undefine USE_RECOVERY_HIJACK
#endif

int exec_and_wait(char ** argp)
{
    pid_t pid;
    sig_t intsave, quitsave;
    sigset_t mask, omask;
    int pstat;

    sigemptyset(&mask);
    sigaddset(&mask, SIGCHLD);
    sigprocmask(SIG_BLOCK, &mask, &omask);
    switch (pid = vfork()) {
    case -1:            /* error */
        sigprocmask(SIG_SETMASK, &omask, NULL);
        return(-1);
    case 0:                /* child */
        sigprocmask(SIG_SETMASK, &omask, NULL);
        execve(argp[0], argp, environ);
        _exit(127);
    }

    intsave = (sig_t)  bsd_signal(SIGINT, SIG_IGN);
    quitsave = (sig_t) bsd_signal(SIGQUIT, SIG_IGN);
    pid = waitpid(pid, (int *)&pstat, 0);
    sigprocmask(SIG_SETMASK, &omask, NULL);
    (void)bsd_signal(SIGINT, intsave);
    (void)bsd_signal(SIGQUIT, quitsave);
    return (pid == -1 ? -1 : pstat);
}

int remount_root(const char * hijack_exec, int rw) {
    char * remount_root_args[5];
    remount_root_args[0] = strdup(hijack_exec);
    remount_root_args[1] = strdup("mount");
    if (rw > 0) {
        remount_root_args[2] = strdup("-orw,remount");
    } else {
        remount_root_args[2] = strdup("-oro,remount");
    }
    remount_root_args[3] = strdup("/");
    remount_root_args[4] = NULL;
    return exec_and_wait(remount_root_args);
}

int hijack_mount(const char * hijack_exec, const char * dev, const char * mount_point) {
    char * mount_args[5];
    mount_args[0] = strdup(hijack_exec);
    mount_args[1] = strdup("mount");
    mount_args[2] = strdup(dev);
    mount_args[3] = strdup(mount_point);
    mount_args[4] = NULL;
    return exec_and_wait(mount_args);
}

int hijack_umount(const char * hijack_exec, const char * mount_point) {
    char * umount_args[5];
    umount_args[0] = strdup(hijack_exec);
    umount_args[1] = strdup("umount");
    umount_args[2] = strdup("-l");
    umount_args[3] = strdup(mount_point);
    umount_args[4] = NULL;
    return exec_and_wait(umount_args);
}

void hijack_log(char * format, ...) {
#ifdef LOG_ENABLE
    FILE * log = fopen(LOG_PATH, "a");
    if (log != NULL) {
        // start our va list
        va_list args;
        va_start(args, format);

        // some buffers :D
        char * new_format = (char *)malloc(sizeof(char) * PATH_MAX);
        char * time_buffer = (char *)malloc(sizeof(char) * PATH_MAX);
        char * out_buffer = (char *)malloc(sizeof(char) * PATH_MAX);

        // get the time
        time_t * ts = (time_t *)malloc(sizeof(time_t));
        time(ts);
        struct tm * t = localtime(ts);
        strftime(time_buffer, PATH_MAX, "%Y-%m-%d %H:%M:%S", t);
        free(ts);

        sprintf(new_format, "hijack [%s]: %s\n", time_buffer, format);
        vsprintf(out_buffer, new_format, args);
        fputs(out_buffer, log);
        va_end(args);
        fclose(log);

        free(new_format);
        free(time_buffer);
        free(out_buffer);
    }
#endif
}

int mark_file(char * filename) {
    FILE *f = fopen(filename, "wb");
    fwrite("1", 1, 1, f);
    if (f != NULL) {
        fclose(f);
        return 0;
    } else {
        return -1;
    }
}

int main(int argc, char ** argv) {
    char * hijacked_executable = argv[0];
    struct stat info;
    int result = 0;
    int i;

    if (NULL != strstr(hijacked_executable, "hijack")) {
        // no op
        if (argc >= 2) {
            return busybox_driver(argc - 1, argv + 1);
        }

        return 0;
    }

#ifdef LOG_ENABLE
    // SCREW THE RULES, IF WE GET HERE WE'RE HIJACKING, AND FROM HERE ON OUT
    // WE'RE FUCKING WITH ROOT (/) NO MATTER WHAT AT THIS POINT
    remount_root("/system/bin/hijack", 1);

    // OH FUCK YEAH MOUNT
    mkdir(LOG_MOUNT, S_IRWXU);
    hijack_mount("/system/bin/hijack", LOG_DEVICE, LOG_MOUNT);

    // time to create our log file and jam our header into it!
hijack_log("Hijack called with the following arguments:");
    for (i = 0; i < argc; i++) {
hijack_log("    argv[%d] = \"%s\"", i, argv[i]);
    }

hijack_log("  Executing log dumper script:");
    char * log_dump_args[] = { LOG_DUMP_BINARY, LOG_PATH, NULL };
hijack_log("    exec(\"%s %s\") executing...", LOG_DUMP_BINARY, LOG_PATH);
    result = exec_and_wait(log_dump_args);
hijack_log("      returned: %d", result);
#endif

    // check to see if hijack was already run, and if so, just continue on.
    if (argc >= 5 && 0 == strcmp(argv[4], "rw")) {

hijack_log("  Entering testing for hijacking!");

hijack_log("    hijack_mount(%s, %s, %s) executing...", "/system/bin/hijack", "/dev/block/mmcblk0p16", "/data");
            result = hijack_mount("/system/bin/hijack", "/dev/block/mmcblk0p16", "/data");
hijack_log("      returned: %d", result);

#ifdef USE_RECOVERY_HIJACK
        if (0 == stat(RECOVERY_MODE_FILE, &info)) {

hijack_log("  Recovery mode detected!");

            // don't boot into recovery again
hijack_log("    remove(%s) executing...", RECOVERY_MODE_FILE);
            result = remove(RECOVERY_MODE_FILE);
hijack_log("      returned: %d", result);

hijack_log("    remount_root(%s, %d) executing...", "/system/bin/hijack", 1);
            result = remount_root("/system/bin/hijack", 1);
hijack_log("      returned: %d", result);

hijack_log("    mkdir(%s, %d) executing...", "/preinstall", S_IRWXU);
            result = mkdir("/preinstall", S_IRWXU);
hijack_log("      returned: %d", result);

hijack_log("    mkdir(%s, %d) executing...", "/tmp", S_IRWXU);
            result = mkdir("/tmp", S_IRWXU);
hijack_log("      returned: %d", result);

hijack_log("    mkdir(%s, %d) executing...", "/res", S_IRWXU);
            result = mkdir("/res", S_IRWXU);
hijack_log("      returned: %d", result);

hijack_log("    mkdir(%s, %d) executing...", "/res/images", S_IRWXU);
            result = mkdir("/res/images", S_IRWXU);
hijack_log("      returned: %d", result);

hijack_log("    remove(%s) executing...", "/etc");
            result = remove("/etc");
hijack_log("      returned: %d", result);

hijack_log("    mkdir(%s, %d) executing...", "/etc", S_IRWXU);
            result = mkdir("/etc", S_IRWXU);
hijack_log("      returned: %d", result);

hijack_log("    rename(%s, %s) executing...", "/sbin/adbd", "/sbin/adbd.old");
            result = rename("/sbin/adbd", "/sbin/adbd.old");
hijack_log("      returned: %d", result);

hijack_log("    property_set(%s, %s) executing...", "ctl.stop", "runtime");
            result = property_set("ctl.stop", "runtime");
hijack_log("      returned: %d", result);

hijack_log("    property_set(%s, %s) executing...", "ctl.stop", "zygote");
            result = property_set("ctl.stop", "zygote");
hijack_log("      returned: %d", result);

hijack_log("    property_set(%s, %s) executing...", "persist.service.adb.enable", "1");
            result = property_set("persist.service.adb.enable", "1");
hijack_log("      returned: %d", result);

hijack_log("    hijack_mount(%s, %s, %s) executing...", "/system/bin/hijack", "/dev/block/mmcblk0p17", "/preinstall");
            result = hijack_mount("/system/bin/hijack", "/dev/block/mmcblk0p17", "/preinstall");
hijack_log("      returned: %d", result);

            // this will prevent hijack from being called again
hijack_log("    hijack_umount(%s, %s) executing...", "/system/bin/hijack", "/system");
            result = hijack_umount("/system/bin/hijack", "/system");
hijack_log("      returned: %d", result);

            char * updater_args[] = { BOARD_HIJACK_UPDATE_BINARY, "2", "0", BOARD_HIJACK_RECOVERY_UPDATE_ZIP, NULL };
hijack_log("    exec(\"%s %s %s %s\") executing...", BOARD_HIJACK_UPDATE_BINARY, "2", "0", BOARD_HIJACK_RECOVERY_UPDATE_ZIP);
            result = exec_and_wait(updater_args);
hijack_log("      returned: %d", result);

            return result;

        } else {
	 
#endif
	  
hijack_log("  Boot mode detected!");

#ifdef LOG_ENABLE_LDSKFJLSFDSKFL
            // since we are in log mode we want to ensure we reboot to recovery in the event of failure
hijack_log("    mark_file(%s) executing...", RECOVERY_MODE_FILE);
            result = mark_file(RECOVERY_MODE_FILE);
hijack_log("      returned: %d", result);
#endif

hijack_log("    remount_root(%s, %d) executing...", "/system/bin/hijack", 1);
            result = remount_root("/system/bin/hijack", 1);
hijack_log("      returned: %d", result);

hijack_log("    rename(%s, %s) executing...", "/sbin/adbd", "/sbin/adbd.old");
            result = rename("/sbin/adbd", "/sbin/adbd.old");
hijack_log("      returned: %d", result);

hijack_log("    property_set(%s, %s) executing...", "ctl.stop", "runtime");
            result = property_set("ctl.stop", "runtime");
hijack_log("      returned: %d", result);

hijack_log("    property_set(%s, %s) executing...", "ctl.stop", "zygote");
            result = property_set("ctl.stop", "zygote");
hijack_log("      returned: %d", result);

hijack_log("    property_set(%s, %s) executing...", "persist.service.adb.enable", "1");
            result = property_set("persist.service.adb.enable", "1");
hijack_log("      returned: %d", result);

hijack_log("    mkdir(%s, %d) executing...", "/newboot", S_IRWXU);
            result = mkdir("/newboot", S_IRWXU);
hijack_log("      returned: %d", result);

hijack_log("    mkdir(%s, %d) executing...", "/preinstall", S_IRWXU);
            result = mkdir("/preinstall", S_IRWXU);
hijack_log("      returned: %d", result);

            // get access to our preinstall
hijack_log("    hijack_mount(%s, %s, %s) executing...", "/system/bin/hijack", "/dev/block/mmcblk0p17", "/preinstall");
            result = hijack_mount("/system/bin/hijack", "/dev/block/mmcblk0p17", "/preinstall");
hijack_log("      returned: %d", result);

            // have updater unpack our boot partition (will create /newboot/sbin/hijack)
            char * updater_args[] = { BOARD_HIJACK_UPDATE_BINARY, "2", "0", BOARD_HIJACK_BOOT_UPDATE_ZIP, NULL };
hijack_log("    exec(\"%s %s %s %s\") executing...", BOARD_HIJACK_UPDATE_BINARY, "2", "0", BOARD_HIJACK_BOOT_UPDATE_ZIP);
            result = exec_and_wait(updater_args);
hijack_log("      returned: %d", result);

            // now copy everything to root
            char * copy_args[] = { "/newboot/sbin/hijack", "cp", "-a", "/newboot/.", "/", NULL };
hijack_log("    exec(\"%s %s %s %s %s\") executing...", "/newboot/sbin/hijack", "cp", "-r", "/newboot/.", "/");
            result = exec_and_wait(copy_args);
hijack_log("      returned: %d", result);

            // wipe out /newboot
            char * rm_args[] = { "/sbin/hijack", "rm", "-rf", "/newboot", NULL };
hijack_log("    exec(\"%s %s %s %s\") executing...", "/sbin/hijack", "rm", "-rf", "/newboot");
            result = exec_and_wait(rm_args);
hijack_log("      returned: %d", result);

            // since we have /sbin/hijack, we no longer need /system
hijack_log("    hijack_umount(%s, %s) executing...", "/sbin/hijack", "/system");
            result = hijack_umount("/sbin/hijack", "/system");
hijack_log("      returned: %d", result);

            // now we're done with /preinstall
hijack_log("    hijack_umount(%s, %s) executing...", "/sbin/hijack", "/preinstall");
            result = hijack_umount("/sbin/hijack", "/preinstall");
hijack_log("      returned: %d", result);

            // now we will attempt to kill EVERYTHING
            char * hijack_killall_args[] = { "/sbin/hijack.killall", NULL };
hijack_log("    exec(\"%s\")", "/sbin/hijack.killall");
            result = exec_and_wait(hijack_killall_args);
hijack_log("      returned: %d", result);

#ifdef LOG_ENABLE
            // one last filesystem accounting run
            char * last_log_dump_args[] = { "/sbin/hijack.log_dump", LOG_PATH, NULL };
hijack_log("    exec(\"%s %s\") executing...", "/sbin/hijack.log_dump", LOG_PATH);
            result = exec_and_wait(last_log_dump_args);
hijack_log("      returned: %d", result);
#endif

            // now we must tasket pid 1 to only cpu 0
            // this is then reset in our init.rc
            char * taskset_args[] = { "/sbin/taskset", "-p", "-c", "0", "1", NULL };
hijack_log("    exec(\"%s %s %s %s %s\") executing...", "/sbin/taskset", "-p", "-c", "0", "1");
            result = exec_and_wait(taskset_args);
hijack_log("      returned: %d", result);

            // now we re-run init (this should restart /init) using tasket
            char * init_args[] = { "/sbin/taskset", "-c", "0", "/sbin/2nd-init", NULL };
hijack_log("    exec(\"%s %s %s %s\") executing...", "/sbin/taskset", "-c", "0", "/sbin/2nd-init");
            result = exec_and_wait(init_args);
hijack_log("      returned: %d", result);

            return result;
#ifdef USE_RECOVERY_HIJACK
        }
#endif
    }

    char hijacked_executable_fullpath[PATH_MAX];
    readlink("/proc/self/exe", hijacked_executable_fullpath, sizeof(hijacked_executable_fullpath));

    char real_executable[PATH_MAX];
    sprintf(real_executable, "%s/%s.bin", dirname(hijacked_executable_fullpath), basename(hijacked_executable));
    char ** argp = (char **)malloc(sizeof(char *) * (argc + 1));
    for (i = 0; i < argc; i++) {
        argp[i]=argv[i];
    }
    argp[argc] = NULL;

    argp[0] = real_executable;

hijack_log("  Executing real program: %s", real_executable);
    for (i = 0; i < argc; i++) {
hijack_log("    argp[%d] = \"%s\"", i, argp[i]);
    }

    // should clean up memory leaks, but it really doesn't matter since the process immediately exits.
    result = exec_and_wait(argp);
hijack_log("    returned: %d", result);

    return result;
}
