class encmount {
    package { ["cryptsetup-luks"]:
        ensure => installed,
    }
}
