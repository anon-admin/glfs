define glfs::root_dirs ($dirname) {
  $soft_dir = $name

  include conf

  $dirname_shared = "${conf::shared_root}/${dirname}"
  $dirname_dir = "${conf::dir_root)/${dirname}"

  file { ["${dirname_dir}/${soft_dir}", "${dirname_shared}/${soft_dir}"]: ensure => directory, }
  Mount["${dirname_dir}"] -> File["${dirname_dir}/${soft_dir}"]
  Mount["${dirname_shared}"] -> File["${dirname_shared}/${soft_dir}"]

  file { [
    "${dirname_dir}/${soft_dir}/varlog",
    "${dirname_dir}/${soft_dir}/varlib"]: ensure => directory, }

  file { ["/var/log/${soft_dir}", "/var/lib/${soft_dir}"]: ensure => directory, }

  File["/var/log/${soft_dir}"] -> Mount["/var/log/${soft_dir}"]
  File["/var/lib/${soft_dir}"] -> Mount["/var/lib/${soft_dir}"]

  mount { "/var/log/${soft_dir}":
    ensure  => mounted,
    atboot  => True,
    device  => "${dirname_dir}/${soft_dir}/varlog",
    fstype  => "none",
    options => "rw,bind",
    require => File["${dirname_dir}/${soft_dir}/varlog"],
  }

  Mount["/var/log/${soft_dir}"] -> Tidy["/var/log"]

  mount { "/var/lib/${soft_dir}":
    ensure  => mounted,
    atboot  => True,
    device  => "${dirname_dir}/${soft_dir}/varlib",
    fstype  => "none",
    options => "rw,bind",
    require => File["${dirname_dir}/${soft_dir}/varlib"],
  }

}