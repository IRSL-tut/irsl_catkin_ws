#!/bin/bash

# Store the absolute path where this script is executed
script_dir=$(realpath "$(dirname "$0")")
# echo "Script is executed from: $script_dir" ## debug

# Function to enable packages
enable() {
    local pkgs=("$@")
    # Add logic to enable packages here
    if [ -z "$1" -o "$1" == "all" -o "$1" == "ALL" ]; then
        echo "Enabling all packages"
        for pkg in "${!package_dirs_map[@]}"; do
            dir="${package_dirs_map[${pkg}]}"
            if [ -e $dir/CATKIN_IGNORE ]; then
                rm -f $dir/CATKIN_IGNORE
            fi
        done
        return
    fi
    echo "Enabling packages: ${pkgs[*]}"
    for pkg in "${pkgs[@]}"; do
        dir="${package_dirs_map[${pkg}]}"
        if [ -e $dir/CATKIN_IGNORE ]; then
            rm -f $dir/CATKIN_IGNORE
        fi
    done
}

# Function to disable packages
disable() {
    local pkgs=("$@")
    if [ -z "$1" -o "$1" == "all" -o "$1" == "ALL" ]; then
        echo "Disabling all packages"
        for pkg in "${!package_dirs_map[@]}"; do
            dir="${package_dirs_map[${pkg}]}"
            if [ -n $dir ]; then
                (cd $dir; touch CATKIN_IGNORE)
            fi
        done
        return
    fi
    # Add logic to disable packages here
    echo "Disabling packages: ${pkgs[*]}"
    for pkg in "${pkgs[@]}"; do
        dir="${package_dirs_map[${pkg}]}"
        if [ -n $dir ]; then
            (cd $dir; touch CATKIN_IGNORE)
        fi
    done
}

# Function to build packages locally
build_local() {
    local pkgs=("$@")
    # Add logic to build packages locally here
    #echo "Building packages locally: ${pkgs[*]}"
    echo "not implemented yet, use catkin build"
}

# Function to build packages using Docker
build_docker() {
    local pkgs=("$@")
    # Add logic to build packages using Docker here
    for pkg in "${pkgs[@]}"; do
        dir="${package_dirs_map[${pkg}]}"
        if [ -e $dir/docker/build.sh ]; then
            echo "Build: $pkg at $dir"
            (cd $dir/docker; bash ./build.sh)
        fi
    done
}

# Function to update packages
update() {
    local pkgs=("$@")
    # Add logic to update packages here
    for pkg in "${pkgs[@]}"; do
        dir="${package_dirs_map[${pkg}]}"
        if [ -e $dir/.git ]; then
            echo "Update: $pkg at $dir"
            (cd $dir; git pull)
        fi
    done
}

# Function to print package names each on a new line
print() {
    echo "PRINT $#"
    local pkgs=("$@")

    if [ "$#" == 0 ]; then
        echo "size: ${#package_dirs_map[@]}"
        for pkg in "${!package_dirs_map[@]}"; do
            echo "${pkg}"
        done
    else
        for pkg in "${pkgs[@]}"; do
            dir="${package_dirs_map[${pkg}]}"
            if [ -n $dir ]; then
                echo "$pkg $dir"
            fi
        done
    fi
}

declare -gA package_dirs_map
# Function to find directories containing package.xml and store in a map
find_package_dirs() {
    local search_dir=${1:-.}
    while IFS= read -r dir; do
        abs_path=$(realpath "$dir")
        ## echo "add $(basename $dir) : $abs_path" # debug
        package_dirs_map["$(basename $dir)"]="$abs_path"
    done < <(find "$search_dir" -type f -name "package.xml" -exec dirname {} \; | sort -u)
}

# Main script logic
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <command> [<pkgs>...]"
    echo "  commands: enable, disable, build-docker, update, print"
    exit 1
fi

command=$1
shift
pkgs=("$@")

find_package_dirs

case $command in
    enable)
        enable "${pkgs[@]}"
        ;;
    disable)
        disable "${pkgs[@]}"
        ;;
    build-local)
        build_local "${pkgs[@]}"
        ;;
    build-docker)
        build_docker "${pkgs[@]}"
        ;;
    update)
        update "${pkgs[@]}"
        ;;
    print)
        print "${pkgs[@]}"
        ;;
    *)
        echo "Invalid command: $command"
        echo "Valid commands are: enable, disable, build-local, build-docker, update, print"
        exit 1
        ;;
esac
