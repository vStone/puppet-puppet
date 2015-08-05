class puppet::server::puppetserver (
  $java_bin          = $::puppet::server_jvm_java_bin,
  $config            = $::puppet::server_jvm_config,
  $jvm_min_heap_size = $::puppet::server_jvm_min_heap_size,
  $jvm_max_heap_size = $::puppet::server_jvm_max_heap_size,
  $jvm_extra_args    = $::puppet::server_jvm_extra_args,
) {

  $puppetserver_package = pick($::puppet::server_package, 'puppetserver')

  Augeas {
    lens    => 'Shellvars.lns',
    incl    => $config,
    context => "/files${config}",
    notify  => Service['puppetserver'],
  }

  $jvm_cmd_arr = ["-Xms${jvm_min_heap_size}","-Xmx${jvm_max_heap_size}", $jvm_extra_args]
  $jvm_cmd = strip(join(flatten($jvm_cmd_arr),' '))

  augeas {'puppet::server::puppetserver::jvm_args':
    changes => "set JAVA_ARGS '\"${jvm_cmd}\"'",
  }
  augeas {'puppet::server::puppetserver::java_bin':
    changes => "set JAVA_BIN ${java_bin}",
  }

}
