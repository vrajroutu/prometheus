#
# Cookbook Name:: prometheus_alertmanager
# Attributes:: default
#

default['prometheus']['user']						= 'root'

default['prometheus']['group']						= 'root'

####
# Directory where the prometheus alertmanager binary will be installed
default['prometheus']['alertmanager']['dir']				= '/opt/prometheus/alertmanager'

default['monitoring']['alertmanager']['version']			= '2.2.0'

default['prometheus']['alertmanager']['binary']['url']			= "https://github.com/prometheus/alertmanager/releases/download/v#{node['monitoring']['alertmanager']['version']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64.tar.gz"
																	
default['prometheus']['alertmanager']['binary']['file']		= "#{node['prometheus']['alertmanager']['dir']}/alertmanager_v#{node['monitoring']['alertmanager']['version']}.tar.gz"

default['prometheus']['alertmanager']['path']				= "#{node['prometheus']['alertmanager']['dir']}/alertmanager"

default['prometheus']['alertmanager']['init']				= '/etc/init/alertmanager.conf'

default['prometheus']['alertmanager']['executable']			= '/usr/bin/alertmanager'


