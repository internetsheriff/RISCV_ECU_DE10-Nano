# ============================================
# Quartus Project Env File
# --------------------------------------------
# It just exports variables important to make
# applications work properly. Fill it up with
# values and add it to your .bashrc file
#
# Some tools like nios2 use bash so adding to
# .fishrc or whatever might not be enough
# ============================================

#!/usr/bin/env bash



# Define project path
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/quartus_project"

#------------Base path variables--------------

# Path to the correct verison's installation
INSTALLATION_DIR="/opt/intelFPGA/24.1"
QUARTUS_ROOTDIR="$INSTALLATION_DIR/quartus"
QUARTUS_ROOTDIR_OVERRIDE="$QUARTUS_ROOTDIR" #needed to actually change dir

# Other apps
QSYS_ROOTDIR="$QUARTUS_ROOTDIR/qsys/bin"
QUESTA_DIR="$INSTALLATION_DIR/questa_fse"
NIOS2_DIR="$INSTALLATION_DIR/nios2eds"


# Exporting
export QSYS_ROOTDIR
export QUARTUS_ROOTDIR
export QUARTUS_ROOTDIR_OVERRIDE


#------------------Licenses-----------------
# This might be needed to certain software
# like Questa or for some IP components
#............................................

# Path to the license folder
LICENSE_DIR="$PROJECT_DIR/licenses"

# licenses file names
LICENSES=("LR-256945_License.dat" "LR-257568_License.dat")

# Exporting value
export LM_LICENSE_FILE=$(IFS=':'; echo "${LICENSES[*]/#/$LICENSE_DIR/}")


#----------------Libraries-----------------
# If you need to manually install or
# override certain libraries the app needs
#..........................................

# List of paths
OUTSIDE_LIBRARIES=(
        "/usr/lib"
        #"$QUARTUS_ROOTDIR/linux64"
)

# Format and export to path
LD_LIBRARIES=$(IFS=':'; echo "{}$OUTSIDE_LIBRARIES[*]}")
export LD_LIBRARY_PATH="$LD_LIBRARIES:$LD_LIBRARY_PATH"

#---------------PROGRAM PATHS-----------------

QSYSBIN_DIR="$QSYS_ROOTDIR"
QUESTABIN_DIR="$QUESTA_DIR/bin"
QUARTUSBIN_DIR="$QUARTUS_ROOTDIR/bin"
NIOS2BIN_DIR="$NIOS2_DIR/bin"

# Exporting to PATH
export PATH="$PATH:$QUARTUSBIN_DIR:$QUESTABIN_DIR:$QSYSBIN_DIR:$NIOS2BIN_DIR"


#--------------APPS base dir--------------
QUARTUS_EXECUTABLE="$QUARTUSBIN_DIR/quartus"
QUESTA_EXECUTABLE="$QUESTABIN_DIR/vsim"
NIOS2SHELL_EXECUTABLE="$NIOS2_DIR/nios2_command_shell.sh"

# Alias
alias quartus="$cd '$PROJECT_DIR' && '$QUARTUS_EXECUTABLE'"
alias questa="$cd '$PROJECT_DIR' && '$QUESTA_EXECUTABLE'"
alias nios2shell="$cd '$PROJECT_DIR' && '$NIOS2SHELL_EXECUTABLE'"


#-----------Extra Path Variables----------
export LC_ALL="en_US.UTF-8"
export PERL_BADLANG=0
export QT_PLUGIN_PATH="$QUESTA_DIR/linux_x86_64/plugins"
export QT_PLUGIN_PATH="$QUESTA_DIR/linux_x86_64/platforms:$QT_PLUGIN_PATH"
export QT_QPA_PLATFORM="xcb"
