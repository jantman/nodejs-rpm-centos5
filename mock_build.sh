#!/bin/bash

VERSION=0.10.21
SPEC=nodejs.spec
CUSTOM=ptin
RELEASE=$(cat $SPEC | grep "Release:" | cut -d "." -f 1 | egrep -o "[0-9]+")
TGZ=node-v$VERSION.tar.gz
URL=http://nodejs.org/dist/v$VERSION/$TGZ
EPELPKGURL=http://ftp.tu-chemnitz.de/pub/linux/fedora-epel/5/i386/epel-release-5-4.noarch.rpm

rpm -q mock > /dev/null 2>&1
if [ $? -ne 0 ]
then
	echo "ERROR: mock must be installed!"
	exit 1
fi

if  [ "$USER" == "root" ]
then
	echo "ERROR: cannot run this as root"
	exit 1
fi

RPMTOPDIR=./rpmbuild
mkdir -p $RPMTOPDIR/{SOURCES,SPECS,BUILD,SRPMS,RPMS,BUILDROOT}

# copiar .spec
cp $SPEC $RPMTOPDIR/SPECS

wget -c $URL
[ $? -eq 0 ] || exit 1

# copiar sources
mv $TGZ $RPMTOPDIR/SOURCES
cp *.patch *.nodejs $RPMTOPDIR/SOURCES

CONFIGS="epel-5-i386 epel-5-x86_64"
for CONFIG in $CONFIGS
do
	mock -r $CONFIG --init
	[ $? -eq 0 ] || exit 1
	mock -r $CONFIG --install $EPELPKGURL
	[ $? -eq 0 ] || exit 1
	mock -r $CONFIG --install python26 python26-devel
	[ $? -eq 0 ] || exit 1
	mock -r $CONFIG --no-clean --no-cleanup-after --buildsrpm --sources=$RPMTOPDIR/SOURCES  --spec=$RPMTOPDIR/SPECS/$SPEC --resultdir=$RPMTOPDIR/SRPMS/
	[ $? -eq 0 ] || exit 1
	mock -r $CONFIG --no-clean --rebuild $RPMTOPDIR/SRPMS/nodejs-$VERSION-$RELEASE.$CUSTOM.el5.src.rpm
	[ $? -eq 0 ] || exit 1

	ls /var/lib/mock/$CONFIG/result
	cp /var/lib/mock/$CONFIG/result/*.rpm /tmp

done
