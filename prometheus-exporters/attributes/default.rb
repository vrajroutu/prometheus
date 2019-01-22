#
# Cookbook Name:: prometheus_exporter
# Attributes:: default
#

default['prometheus']['user']									= 'root'

default['prometheus']['group']									= 'root'

# prometheus node exporter 
default['prometheus']['node_exporter']['dir']					= '/opt/prometheus/node_exporter'

default['prometheus']['node_exporter']['version']				= '0.14.0'

default['prometheus']['node_exporter']['binary']['url']			= "https://github.com/prometheus/node_exporter/releases/download/v#{node['prometheus']['node_exporter']['version']}/node_exporter-#{node['prometheus']['node_exporter']['version']}.linux-amd64.tar.gz"

default['prometheus']['node_exporter']['binary']['file']		= "#{node['prometheus']['node_exporter']['dir']}/node_exporter.tar.gz"

default['prometheus']['node_exporter']['path']					= "#{node['prometheus']['node_exporter']['dir']}/node_exporter"

default['prometheus']['node_exporter']['executable']			= '/usr/bin/node_exporter'

default['prometheus']['node_exporter']['init']					= '/etc/init/node_exporter.conf'

default['prometheus']['node_exporter']['exporter']['port']		= ':9100'

# prometheus postgres_exporter exporter 
default['prometheus']['postgres_exporter']['dir']				= '/opt/prometheus/postgres_exporter'

default['prometheus']['postgres_exporter']['version']			= '0.4.1'
																  #https://github.com/wrouesnel/postgres_exporter/releases/download/v0.4.1/postgres_exporter_v0.4.1_linux-amd64.tar.gz
default['prometheus']['postgres_exporter']['binary']['url']		= "https://github.com/wrouesnel/postgres_exporter/releases/download/v#{node['prometheus']['postgres_exporter']['version']}/postgres_exporter_v#{node['prometheus']['postgres_exporter']['version']}_linux-amd64.tar.gz"

default['prometheus']['postgres_exporter']['binary']['file']	= "#{node['prometheus']['postgres_exporter']['dir']}/postgres_exporter.tar.gz"

default['prometheus']['postgres_exporter']['path']				= "#{node['prometheus']['postgres_exporter']['dir']}/postgres_exporter"

default['prometheus']['postgres_exporter']['executable']			= '/usr/bin/postgres_exporter'

default['prometheus']['postgres_exporter']['init']				= '/etc/init/postgres_exporter.conf'

default['prometheus']['postgres_exporter']['exporter']['port']		= ':9401'

# prometheus process_exporter exporter 
default['prometheus']['process_exporter']['dir']				= '/opt/prometheus/process_exporter'

default['prometheus']['process_exporter']['version']			= '0.1.0'
														          #https://github.com/ncabatoff/process-exporter/releases/download/v0.1.0/process-exporter-0.1.0.linux-amd64.tar.gz
default['prometheus']['process_exporter']['binary']['url']		= "https://github.com/ncabatoff/process-exporter/releases/download/v#{node['prometheus']['process_exporter']['version']}/process-exporter-#{node['prometheus']['process_exporter']['version']}.linux-amd64.tar.gz"

default['prometheus']['process_exporter']['binary']['file']		= "#{node['prometheus']['process_exporter']['dir']}/process_exporter.tar.gz"

default['prometheus']['process_exporter']['path']				= "#{node['prometheus']['process_exporter']['dir']}/process-exporter"

default['prometheus']['process_exporter']['executable']			= '/usr/bin/process-exporter'

default['prometheus']['process_exporter']['init']				= '/etc/init/process_exporter.conf'

default['prometheus']['process_exporter']['exporter']['port']		= ':9402'

# prometheus mysqld_exporter exporter 

default['prometheus']['mysqld_exporter']['db']['dns']			='shiva-dev-mysql2.claockrfak60.us-east-2.rds.amazonaws.com'

default['prometheus']['mysqld_exporter']['db']['username']		='openfire'

default['prometheus']['mysqld_exporter']['db']['password']		='Cb58nXydg4bfsYDH'

default['prometheus']['mysqld_exporter']['dir']					= '/opt/prometheus/mysqld_exporter'

default['prometheus']['mysqld_exporter']['version']				= '0.10.0'
														          #https://github.com/prometheus/mysqld_exporter/releases/download/v0.10.0/mysqld_exporter-0.10.0.linux-amd64.tar.gz
default['prometheus']['mysqld_exporter']['binary']['url']		= "https://github.com/prometheus/mysqld_exporter/releases/download/v#{node['prometheus']['mysqld_exporter']['version']}/mysqld_exporter-#{node['prometheus']['mysqld_exporter']['version']}.linux-amd64.tar.gz"

default['prometheus']['mysqld_exporter']['binary']['file']		= "#{node['prometheus']['mysqld_exporter']['dir']}/mysqld_exporter.tar.gz"

default['prometheus']['mysqld_exporter']['path']				= "#{node['prometheus']['mysqld_exporter']['dir']}/mysqld_exporter"

default['prometheus']['mysqld_exporter']['executable']			= '/usr/bin/mysqld_exporter'

default['prometheus']['mysqld_exporter']['init']				= '/etc/init/mysqld_exporter.conf'

default['prometheus']['mysqld_exporter']['exporter']['port']	= ':9403'

# prometheus rabbitmq_exporter exporter 
default['prometheus']['rabbitmq_exporter']['dir']				= '/opt/prometheus/rabbitmq_exporter'

default['prometheus']['rabbitmq_exporter']['version']			= '0.25.2'
														          #https://github.com/kbudde/rabbitmq_exporter/releases/download/v0.25.2/rabbitmq_exporter-0.25.2.linux-amd64.tar.gz
default['prometheus']['rabbitmq_exporter']['binary']['url']		= "https://github.com/kbudde/rabbitmq_exporter/releases/download/v#{node['prometheus']['rabbitmq_exporter']['version']}/rabbitmq_exporter-#{node['prometheus']['rabbitmq_exporter']['version']}.linux-amd64.tar.gz"

default['prometheus']['rabbitmq_exporter']['binary']['file']	= "#{node['prometheus']['rabbitmq_exporter']['dir']}/rabbitmq_exporter.tar.gz"

default['prometheus']['rabbitmq_exporter']['path']				= "#{node['prometheus']['rabbitmq_exporter']['dir']}/rabbitmq_exporter"

default['prometheus']['rabbitmq_exporter']['executable']		= '/usr/bin/rabbitmq_exporter'

default['prometheus']['rabbitmq_exporter']['init']				= '/etc/init/rabbitmq_exporter.conf'

default['prometheus']['rabbitmq_exporter']['exporter']['port']	= ':9404'

