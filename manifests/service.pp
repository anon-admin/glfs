class glfs::service inherits glfs {

  service { "glusterfs-server":
    ensure => running,
    enable => true,
  }
  Package["glusterfs-server"] -> Service["glusterfs-server"] 
  

}