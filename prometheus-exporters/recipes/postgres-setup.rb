#
# Cookbook Name:: prometheus_exporter
# Recipe:: postgres-setup
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#

directory node['prometheus']['postgres_exporter']['dir'] do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
  recursive true
end

bash 'node_binary' do
  cwd ::File.dirname(node['prometheus']['postgres_exporter']['binary']['file'])
  code <<-EOH
    wget #{node['prometheus']['postgres_exporter']['binary']['url']} -O #{node['prometheus']['postgres_exporter']['binary']['file']}
    tar xzvf #{node['prometheus']['postgres_exporter']['binary']['file']} -C #{node['prometheus']['postgres_exporter']['dir']}
    mv #{node['prometheus']['postgres_exporter']['dir']}/postgres_exporter_v#{node['prometheus']['postgres_exporter']['version']}_linux-amd64/postgres_exporter #{node['prometheus']['postgres_exporter']['dir']}
    rm -rf #{node['prometheus']['postgres_exporter']['binary']['file']} #{node['prometheus']['postgres_exporter']['dir']}/postgres_exporter_v#{node['prometheus']['postgres_exporter']['version']}_linux-amd64
    EOH
  not_if { ::File.exist? ("#{node['prometheus']['postgres_exporter']['dir']}/postgres_exporter") }
end


link node['prometheus']['postgres_exporter']['executable'] do
  to		node['prometheus']['postgres_exporter']['path']
  owner 	node['prometheus']['user']
  group 	node['prometheus']['group']
  link_type	:symbolic
  action        :create
end

template node['prometheus']['postgres_exporter']['init'] do
source	'postgres_exporter.conf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[postgres_exporter]', :immediately
end

service 'postgres_exporter' do
	action		:start
	provider	Chef::Provider::Service::Upstart
	supports	:status => true, :restart => true, :reload => true
end
