#!/bin/bash
mkdir -p gluex_top
pushd gluex_top
if [ -e build_scripts ]
    then
    echo build_scripts already here, skip download
else
    echo downloading build_scripts tar file
    rm -rf build_scripts-latest latest.tar.gz build_scripts
    wget -O latest.tar.gz --no-check-certificate https://github.com/jeffersonlab/build_scripts/archive/latest.tar.gz
    tar zxf latest.tar.gz
    ln -s build_scripts-latest build_scripts
fi
if [ ! -z $1 ]
    version_file=$1
else
    version_file=version.xml
fi
version_name=${version_file%.*}
pwd_string=`pwd`
export GLUEX_TOP=$pwd_string
export BUILD_SCRIPTS=$GLUEX_TOP/build_scripts
rm -fv setup.$version_name.sh
echo export GLUEX_TOP=$pwd_string > setup.$version_name.sh
echo export BUILD_SCRIPTS=\$GLUEX_TOP/build_scripts >> setup.$version_name.sh
echo source \$BUILD_SCRIPTS/gluex_env_version.sh $pwd_string/$version_file >> setup.$version_name.sh
rm -fv setup.$version_name.csh
echo setenv GLUEX_TOP $pwd_string > setup.$version_name.csh
echo setenv BUILD_SCRIPTS \$GLUEX_TOP/build_scripts >> setup.$version_name.csh
echo source \$BUILD_SCRIPTS/gluex_env_version.csh $pwd_string/$version_file >> setup.$version_name.csh
if [ -f $version_file ]
    then
    echo $version_file exists, skip download
else
    echo getting $version_file from halldweb.jlab.org
    wget --no-check-certificate https://halldweb.jlab.org/dist/$version_file
fi
source $BUILD_SCRIPTS/gluex_env_version.sh $version_file
make -f $BUILD_SCRIPTS/Makefile_all gluex
popd
