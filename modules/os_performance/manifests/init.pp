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

class os_performance {
  $path="/bin:/usr/bin"

  # Increased limits for some users.
  file { "/etc/security/limits.conf":
    ensure => 'file',
    source => 'puppet:///modules/os_performance/limits.conf',
    replace => true,
  }

  case $operatingsystem {
    'centos': {
      $target = "/etc/rc.d/rc.local"
    }
    'ubuntu': {
      $target = "/etc/rc.local"
    }
  }

  # Disable THP on boot.
  file { "$target":
    ensure => 'file',
    source => 'puppet:///modules/os_performance/rc.local',
    replace => true,
  }
}
