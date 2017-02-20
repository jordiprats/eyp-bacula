# Client {
#   Name = lolcathost-fd
#   Address = localhost
#   FDPort = 9102
#   Catalog = MyCatalog
#   Password = "PyoUVegvlXd1jsZxXItk7MVuZc0dNbuXK"          # password for FileDaemon
#   File Retention = 60 days            # 60 days
#   Job Retention = 6 months            # six months
#   AutoPrune = yes                     # Prune expired Jobs/Files
# }
define bacula::dir::client(
                            $catalog,
                            $addr,
                            $password,
                            $client_name = $name,
                            $description = undef,
                            $port = '9102',
                            $file_retention = '30 days',
                            $job_retention = '30 days',
                            $autoprune = true,
                          ) {

  $client_name_filename=downcase($client_name)

  file { "/etc/bacula/bacula-dir/clients/${client_name_filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template("${module_name}/dir/client.erb"),
  }
}