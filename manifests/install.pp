class glfs::install inherits glfs {

  package { ["glusterfs-client", "glusterfs-server"]:
    ensure => latest,
  }

}