#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

class hive2 {
  $path="/bin:/usr/bin"

  package { "hive2${package_version}":
    ensure => installed,
  }

  package { "tez_hive2${package_version}":
    ensure => installed,
  }

  # Configs.
  file { '/etc/hive2/conf/hive-site.xml':
    ensure => file,
    content => template('hive2/hive-site.xml.erb'),
    require => Package["hive2${package_version}"],
  }
  file { '/etc/hive2/conf/hive-env.sh':
    ensure => file,
    content => template('hive2/hive-env.sh.erb'),
    require => Package["hive2${package_version}"],
  }
  file { '/etc/hive2/conf/hive-log4j2.properties':
    ensure => file,
    source => "puppet:///modules/hive2/hive-log4j2.properties",
    require => Package["hive2${package_version}"],
  }
  file { '/etc/tez_hive2/conf/tez-site.xml':
    ensure => file,
    content => template('hive2/tez-site.xml.erb'),
    require => Package["tez_hive2${package_version}"],
  }

  if $hive_options {
    exec {"python /vagrant/files/xmlcombine.py /etc/hive2/conf/hive-site.xml hive_client $hive_options":
        cwd => "/",
        path => $path,
        require => File["/etc/hive2/conf/hive-site.xml"]
    }
  }

  # Tweaked CLI script
  file { '/usr/hdp/current/hive-server2-hive2/bin/hive.distro':
    ensure => file,
    source => "puppet:///modules/hive2/hive.distro",
    require => Package["hive2${package_version}"],
  }

  # Convenience links.
  file {"/usr/bin/hive2":
    ensure => link,
    target => "/usr/hdp/${hdp_version}/hive2/bin/hive",
  }
  file {"/usr/bin/hive":
    ensure => link,
    force => true,
    target => "/usr/hdp/${hdp_version}/hive2/bin/hive",
  }
  file {"/usr/bin/beeline":
    ensure => link,
    force => true,
    target => "/usr/hdp/${hdp_version}/hive2/bin/beeline",
  }
  file {"/usr/bin/hplsql":
    ensure => link,
    target => "/usr/hdp/${hdp_version}/hive2/bin/hplsql",
  }
}
