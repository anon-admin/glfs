define glfs::mounts ($vgname = "system") {
  $dirname = $name

  include conf

  $dirname_shared = "${conf::shared_root}/${dirname}"
  $dirname_dir = "${conf::dir_root)/${dirname}"

  contain glfs

  file { "/glfs/${dirname}":
    ensure => directory,
    before => Mount["/glfs/${dirname}"],
  }

  mount { "/glfs/${dirname}":
    ensure  => mounted,
    atboot  => True,
    device  => "/dev/mapper/${vgname}-${dirname}_glfs",
    fstype  => "ext4",
    options => "rw",
  }
  Mount["/glfs/${dirname}"]  ~> Service["glusterfs-server"]

  file { "${dirname_shared}":
    ensure => directory,
    before => Mount["${dirname_shared}"],
  }

  mount { "${dirname_shared}":
    ensure  => mounted,
    atboot  => False,
    device  => "localhost:${dirname}_glfs",
    fstype  => "glusterfs",
    options => "noauto,rw,default_permissions,allow_other,max_read=131072",
  }

  Mount["/glfs/${dirname}"] -> Mount["${dirname_shared}"]
  Service["glusterfs-server"] -> Mount["${dirname_shared}"]

  file { "${dirname_dir}":
    ensure => directory,
    before => Mount["${dirname_dir}"],
  }

  mount { "${dirname_dir}":
    ensure  => mounted,
    atboot  => True,
    device  => "/dev/mapper/${vgname}-${dirname}",
    fstype  => "ext4",
    options => "rw",
  }
}