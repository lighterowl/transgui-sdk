# syntax=docker/dockerfile:1

FROM rockylinux:8

RUN yum -y update && yum makecache
RUN yum install -y epel-release yum-utils && yum-config-manager --enable devel && yum makecache
RUN yum install -y fpc libxml2 fuse-libs qt5-devel bzip2 git file

RUN curl -L -O https://github.com/davidbannon/libqt5pas/releases/download/v1.2.15/libqt5pas-2.15-3.x86_64.rpm
RUN curl -L -O https://github.com/davidbannon/libqt5pas/releases/download/v1.2.15/libqt5pas-devel-2.15-3.x86_64.rpm
RUN rpm -i libqt5pas-2.15-3.x86_64.rpm libqt5pas-devel-2.15-3.x86_64.rpm
RUN rm libqt5pas*

RUN fpcmkcfg -d basepath=/usr/lib64/fpc/3.2.0 -o ~/.fpc.cfg

COPY sdk_build.sh .
RUN ./sdk_build.sh

RUN yum remove -y fpc
