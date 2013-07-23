define encmount::mount(
  $fstype,
  $device,
  $mapper,
  $key,
  $mount=$name,
  $ensure='mounted',
  $options='defaults',
) {
  $devmapper = "/dev/mapper/${mapper}"

  exec { "luksOpen $mapper":
    command     => "/bin/echo -n '${key}' | /sbin/cryptsetup luksOpen ${device} ${mapper}",
    onlyif      => "/sbin/cryptsetup isLuks ${device}",
    creates     => $devmapper,
    path        => ['/sbin', '/bin/'],
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
