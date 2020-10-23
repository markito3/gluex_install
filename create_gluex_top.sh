#!/bin/bash
# GI_PATH is the fully qualified directory that contains this script
gi_script="${BASH_SOURCE[0]}";
if([ -h "${gi_script}" ]) then
  while([ -h "${gi_script}" ]) do gi_script=`readlink "${gi_script}"`; done
fi
pushd . > /dev/null
cd `dirname ${gi_script}` > /dev/null
GI_PATH=`pwd`
popd  > /dev/null
#
mkdir -p gluex_top
pushd gluex_top
pwd_string=`pwd`
mkdir -p resources
if [ -e build_scripts ]
    then
    echo build_scripts already here, skip installation
else
    echo cloning build_scripts repository
    git clone https://github.com/jeffersonlab/build_scripts
    pushd build_scripts
    ./update_to_latest.sh
    popd
fi
if [ -e halld_versions ]
    then
    echo halld_versions already here, skip installation
else
    echo cloning halld_versions repository
    git clone https://github.com/jeffersonlab/halld_versions
fi
$GI_PATH/create_setup_scripts.sh $pwd_string