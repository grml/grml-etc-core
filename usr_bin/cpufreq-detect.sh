#!/bin/sh
# Filename:      cpufreq-detect.sh
# Purpose:       detect cpu type and set $MODULE to appropriate kernel module for cpufrequency scaling
# Authors:       grml-team (grml.org), (C) Ubuntu, (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################
# Notice: also check out /etc/init.d/loadcpufreq of current cpufrequtils in Debian.
#
# Notice: based on http://people.ubuntulinux.org/~scott/patches/powernowd/ and
# scripts found in the powernowd package version 0.97-1ubuntu6 on Ubuntu.
################################################################################

/usr/sbin/laptop-detect 2>/dev/null && LAPTOP=1

CPUINFO=/proc/cpuinfo
IOPORTS=/proc/ioports

if [ ! -f $CPUINFO ] ; then
   echo >&2 $CPUINFO not detected...
   exit 1
fi

# /lib/modules/2.6.16-grml/kernel/arch/i386/kernel/cpu/cpufreq/ ->
# modulename          [used?]
# acpi-cpufreq        [x]
# cpufreq-nforce2     [ ] nForce2 FSB changing cpufreq driver
# gx-suspmod          [ ] Cpufreq driver for Cyrix MediaGX and NatSemi Geode
# longhaul            [x]
# longrun             [x]
# p4-clockmod         [~] cpufreq driver for Pentium(TM) 4/Xeon(TM)
# powernow-k6         [x]
# powernow-k7         [x]
# powernow-k8         [x]
# speedstep-centrino  [x]
# speedstep-ich       [x]
# speedstep-lib       [ ] Library for Intel SpeedStep 1 or 2 cpufreq drivers.
# speedstep-smi       [x]
#
# /lib/modules/2.6.16-grml/kernel/drivers/cpufreq ->
# cpufreq_conservative
# cpufreq_ondemand
# cpufreq_powersave
# cpufreq_stats
# cpufreq_userspace
# freq_table

MODEL_NAME=`grep '^model name' "$CPUINFO" | head -n 1 | sed -e 's/^.*: //;'`
CPU=`grep -E '^cpud[^:]+:' "$CPUINFO" | head -n 1 | sed -e 's/^.*: //;'`
VENDOR_ID=`grep -E '^vendor_id[^:]+:' "$CPUINFO" | head -n 1 | sed -e 's/^.*: //;'`
CPU_FAMILY=$(sed -e '/^cpu family/ {s/.*: //;p;Q};d' $CPUINFO)

MODULE=none
MODULE_FALLBACK=acpi-cpufreq

# Two modules for PIII-M depending the chipset.
# modprobe speedstep-ich$EXT || modprobe speestep-smi$EXT  would be another way
if [ -f $IOPORTS ] && grep -q 'Intel .*ICH' $IOPORTS ; then
  PIII_MODULE=speedstep-ich
else
  PIII_MODULE=speedstep-smi
fi

case "$VENDOR_ID" in
    GenuineIntel*)
    # If the CPU has the est flag, it supports enhanced speedstep and should
    # use the speedstep-centrino driver
    if [ "$(grep est $CPUINFO)" ]; then
        case "$(uname -r)" in
            2.6.2[0-9]*)
                # Prefer acpi-cpufreq for kernels after 2.6.20
                MODULE=acpi-cpufreq
                ;;
            *)
                MODULE=speedstep-centrino
                ;;
        esac
    elif [ $CPU_FAMILY = 15 ]; then
    # Right. Check if it's a P4 without est.
        # Could be speedstep-ich, or could be p4-clockmod.
        MODULE=speedstep-ich;
        # Disabled for now - the latency tends to be bad enough to make it
        # fairly pointless.
        # echo "FREQDRIVER=p4-clockmod" >/etc/default/powernowd
        # to override this
        #if [ $LAPTOP = "1" ]; then
        #    MODULE_FALLBACK=p4-clockmod;
        #fi
    else
    # So it doesn't have Enhanced Speedstep, and it's not a P4. It could be
    # a Speedstep PIII, or it may be unsupported. There's no terribly good
    # programmatic way of telling.
        case "$MODEL_NAME" in
            Intel\(R\)\ Pentium\(R\)\ III\ Mobile\ CPU*)
            MODULE=$PIII_MODULE ;;

        # JD: says this works with   cpufreq_userspace
            Mobile\ Intel\(R\)\ Pentium\(R\)\ III\ CPU\ -\ M*)
            MODULE=$PIII_MODULE ;;

        # https://bugzilla.ubuntu.com/show_bug.cgi?id=4262
        # UNCONFIRMED
            Pentium\ III\ \(Coppermine\)*)
            MODULE=$PIII_MODULE ;;

            Intel\(R\)\ Celeron\(R\)\ M\ processor*)
            MODULE=p4-clockmod ;;

        esac
    fi
    ;;
    AuthenticAMD*)
    # Hurrah. This is nice and easy.
    case $CPU_FAMILY in
        5)
        # K6
        MODULE=powernow-k6
        ;;
        6)
        # K7
        MODULE=powernow-k7
        ;;
        15)
        # K8
        MODULE=powernow-k8
        ;;
    esac
    ;;
    CentaurHauls*)
    # VIA
    if [ $CPU_FAMILY = 6 ]; then
        MODULE=longhaul;
    fi
    ;;
    GenuineTMx86*)
    # Transmeta
    if [ "`grep longrun $CPUINFO`" ]; then
        MODULE=longrun
    fi
    ;;
esac

## END OF FILE #################################################################
