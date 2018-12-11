# Class: glfs
#
# This module manages glfs
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class glfs {
  contain glfs::install
  contain glfs::service
}
