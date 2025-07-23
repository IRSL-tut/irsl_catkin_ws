#!/bin/bash

if [ -z "$ROS_ROOT" ]; then
    echo "You should source any setup.bash"
    exit -1
fi

_OPTION='VERBOSE=1'

if [ "$1" == "local" ]; then
    _OPTION="$_OPTION IRSL_BUILD_LOCAL=true"
fi

if [ ! -e .catkin_tools ]; then
    catkin init -w .
    catkin config --install
fi

set -x
bash -c "$_OPTION catkin build"
