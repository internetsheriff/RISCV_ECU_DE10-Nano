# ============================================
#  --------------CONFIG FRAGMENT-------------
# ============================================
#  Make fragment with all main definitions for
#  project, paths, names, values...
# ============================================



#-------------------Base Names----------------------
# These names are used to identify tons of diferent
# files and folder in thes project.

PROJECT_NAME=pulpino_qsys_test
QSYS_NAME=sys




#--------------Compilation Configs-----------------

# Options to configure the toolchain compilation
TOOLCHAIN_COMPILATION_FLAGS= --enable-multilib

# Options to configure the source code compilation
# (other options in the variables.mk file)
TARGET_ARCH= -march=rv32imc_zicsr_zifencei -mabi=ilp32 

# Libraries to add to source code compilation
LIBS =



#------------Alternative Memory Reload--------------
# Set to "true" if quartus can't reload memory 
# normally and you need to do it 'manually', 
# anything else will be treated as 'false' 
#
# DO NOT USE TRAILING WHITESPACE 'true '
ALTERNATIVE_MEM_RELOAD=true

# TODO: Move to a centralized fragment for addresses
BASE_ADDRESS=0x00008000
