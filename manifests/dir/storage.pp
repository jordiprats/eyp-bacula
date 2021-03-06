# Storage {
#   Name = File2
# # Do not use "localhost" here
#   Address = localhost                # N.B. Use a fully qualified name here
#   SDPort = 9103
#   Password = "XXX_SDPASSWORD_XXX"
#   Device = FileChgr2
#   Media Type = File2
#   Maximum Concurrent Jobs = 10        # run up to 10 jobs a the same time
# }
define bacula::dir::storage (
                              $password,
                              $device,
                              $storage_name        = $name,
                              $addr                = '127.0.0.1',
                              $sd_port             = '9103',
                              $media_type          = "File-${::fqdn}",
                              $max_concurrent_jobs = '20',
                              $description         = undef,
                            ) {
  if(!defined(Concat::Fragment['bacula-dir.conf storages includes']))
  {
    concat::fragment{ 'bacula-dir.conf storages includes':
      target  => '/etc/bacula/bacula-dir.conf',
      order   => '90',
      content => "@|\"sh -c 'for f in /etc/bacula/bacula-dir/storages/*.conf ; do echo @\${f} ; done'\"\n",
    }
  }

  $storage_name_filename=downcase($storage_name)

  file { "/etc/bacula/bacula-dir/storages/${storage_name_filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/dir/storage.erb"),
    notify  => Class['::bacula::dir::service'],
  }
}
