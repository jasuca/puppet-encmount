define encmount::mount(
  $fstype,
  $device,
  $mapper,
  $key,
  $mount=$name,
  $ensure='mounted',
  $options='defaults',
  $temp="/dev/shm/${mapper}"
) {
  $devmapper = "/dev/mapper/${mapper}"

  file { $temp:
    ensure  => 'present',
    backup  => false,
    owner   => root,
    group   => root,
    mode    => '0400',
    notify  => Exec["create key $mapper"],
  }

  exec { "create key $mapper":
    command     => "/bin/echo -n '${key}' > ${temp}",
    unless      => "/bin/mount | /bin/grep ${mapper}",
    refreshonly => true,
    notify      => Exec["luksOpen $mapper"],
  }

  exec { "delete key $mapper":
    command     => "/usr/bin/shred -u ${temp}",
    refreshonly => true,
  }

  exec { "luksOpen $mapper":
    command     => "/sbin/cryptsetup --key-file ${temp} luksOpen ${device} ${mapper}",
    onlyif      => "/usr/bin/test ! -b ${devmapper}",
    creates     => $devmapper,
    path        => ['/sbin', '/bin/'],
    refreshonly => true,
    subscribe   => Exec["create key $mapper"],
    notify      => [ Exec["delete key $mapper"], Mount[$mount] ],
  }

  mount { $mount:
    ensure  => $ensure,
    atboot  => false,
    device  => $devmapper,
    fstype  => $fstype,
    options => $options,
    require => Exec["luksOpen $mapper"],
  }
}
