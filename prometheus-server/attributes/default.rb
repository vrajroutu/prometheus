#
# Cookbook Name:: prometheus_server
# Attributes:: default
#

default['prometheus']['user']						= 'root'

default['prometheus']['group']						= 'root'

# Directory where the prometheus server binary will be installed

default['prometheus']['server']['dir']				= '/opt/prometheus/server'

default['monitoring']['prometheus']['version']			= '1.7.2'

#https://github.com/prometheus/prometheus/releases/download/v2.2.0/prometheus-2.2.0.linux-amd64.tar.gz

default['prometheus']['server']['binary']['url']			= "https://github.com/prometheus/prometheus/releases/download/v#{node['monitoring']['prometheus']['version']}/prometheus-#{node['monitoring']['prometheus']['version']}.linux-amd64.tar.gz"

default['prometheus']['server']['binary']['file']		= "#{node['prometheus']['server']['dir']}/server.tar.gz"

default['prometheus']['server']['path']				= "#{node['prometheus']['server']['dir']}/prometheus"

default['prometheus']['server']['init']				= '/etc/init/prometheus.conf'

default['prometheus']['server']['executable']			= '/usr/bin/prometheus'



