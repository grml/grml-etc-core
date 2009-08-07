/*
 * Filename:      cpu-screen.c
 * Purpose:       output current / available cpu frequence (useful for integration into GNU screen)
 * Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
 * Bug-Reports:   see http://grml.org/bugs/
 * License:       This file is licensed under the GPL v2.
 *******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_LEN 10

static int cpu_cur_frequency(void)
{
        FILE *fp;
        char puffer[LINE_LEN];
        char *nl;
        fp = fopen("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq", "r");
        if(!fp) {
                printf("[ cpufreq n/a ]\n");
                return 1;
        }
        else {
                while(fgets(puffer, LINE_LEN, fp)){
                        if ((nl = strchr(puffer,'\n')))
                            *nl = 0;
                        int value = atoi(puffer);
                        value /= 1000;
                        fprintf(stdout, "%u", value);
                }
        }
        fclose(fp);

        return 0;
}

static int cpu_max_frequency(void)
{
        FILE *fp;
        char puffer[LINE_LEN];
        fp = fopen("/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq", "r");
        if(!fp) {
                return 2;
        }
        else {
                while(fgets(puffer, LINE_LEN, fp)){
                        int value = atoi(puffer);
                        value /= 1000;
                        fprintf(stdout, "%u\n", value);
                }
        }
        fclose(fp);

        return 0;
}

// function inspired by cpufreq-info.c of cpufrequtils-0.4 by Dominik Brodowski
static int count_cpus(void)
{
        FILE *fp;
        char value[LINE_LEN];
        unsigned int ret = 0;
        unsigned int cpunr = 0;

        fp = fopen("/proc/stat", "r");
        // assume "1" cpu if we can't count it
        if(!fp) {
                return 1;
        }

        while (!feof(fp)) {
                fgets(value, LINE_LEN, fp);
                if (strlen(value) < (LINE_LEN - 2))
                        continue;
                if (strstr(value, "cpu "))
                        continue;
                if (sscanf(value, "cpu%d ", &cpunr) != 1)
                        continue;
                if (cpunr > ret)
                        ret = cpunr;
        }
        fclose(fp);

        return (ret+1);
}

int main()
{
        int cpus;
        int ret;

        cpus = count_cpus();
        if (cpus != 1){
                printf("%d * ", cpus);
        }

        ret = cpu_cur_frequency();
        if (!ret) {
                printf(" / ");
                ret = cpu_max_frequency();
        }
        return (ret);
}

/* EOF */
