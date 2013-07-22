#encmount

  This module manages mounting encrypted disks using LUKS.

  Forked from Jared Curtis https://github.com/jaredcurtis/puppet-encmount

  Tested platforms:
   - CentOS 6.x

##Usage
All options and configuration can be done through interacting with the parameters on the main encmount::mount definition. These are documented below.

##encmount::mount definition
Uses LUKS to mount an encrypted volume

###Parameters
####`fstype`
####`device`
####`mapper`
####`key`
####`mount`
Default value: $name
####`ensure`
Default value: 'mounted'
####`options`
Default value: 'defaults'
####`temp`
Default value: "/dev/shm/${mapper}"

### Sample Usage

```puppet
encmount::mount { '/mnt/test':
  fstype => 'ext3',
  device => '/dev/sdb1',
  mapper => 'enc_sdb1',
  key    => '1234!@#$',
}
```