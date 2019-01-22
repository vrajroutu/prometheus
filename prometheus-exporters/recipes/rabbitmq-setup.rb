#
# Cookbook Name:: prometheus_exporter
# Recipe:: rabbitmq-setup
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#

directory node['prometheus']['rabbitmq_exporter']['dir'] do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
  recursive true
end

bash 'node_binary' do
  cwd ::File.dirname(node['prometheus']['rabbitmq_exporter']['binary']['file'])
  code <<-EOH
    wget #{node['prometheus']['rabbitmq_exporter']['binary']['url']} -O #{node['prometheus']['rabbitmq_exporter']['binary']['file']}
    tar xzvf #{node['prometheus']['rabbitmq_exporter']['binary']['file']} -C #{node['prometheus']['rabbitmq_exporter']['dir']}
    mv #{node['prometheus']['rabbitmq_exporter']['dir']}/rabbitmq_exporter-#{node['prometheus']['rabbitmq_exporter']['version']}.linux-amd64/rabbitmq_exporter #{node['prometheus']['rabbitmq_exporter']['dir']}
    rm -rf #{node['prometheus']['rabbitmq_exporter']['binary']['file']} #{node['prometheus']['rabbitmq_exporter']['dir']}/rabbitmq_exporter-#{node['prometheus']['rabbitmq_exporter']['version']}.linux-amd64
    EOH
  not_if { ::File.exist? ("#{node['prometheus']['rabbitmq_exporter']['dir']}/rabbitmq_exporter") }
end


link node['prometheus']['rabbitmq_exporter']['executable'] do
  to		node['prometheus']['rabbitmq_exporter']['path']
  owner 	node['prometheus']['user']
  group 	node['prometheus']['group']
  link_type	:symbolic
  action        :create
end

template node['prometheus']['rabbitmq_exporter']['init'] do
source	'rabbitmq_exporter.conf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[rabbitmq_exporter]', :immediately
end

service 'rabbitmq_exporter' do
	action		:start
	provider	Chef::Provider::Service::Upstart
	supports	:status => true, :restart => true, :reload => true
end
