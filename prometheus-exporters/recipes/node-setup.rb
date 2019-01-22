#
# Cookbook Name:: prometheus_exporter
# Recipe:: node-setup
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#

directory node['prometheus']['node_exporter']['dir'] do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
  recursive true
end

bash 'node_binary' do
  cwd ::File.dirname(node['prometheus']['node_exporter']['binary']['file'])
  code <<-EOH
    wget #{node['prometheus']['node_exporter']['binary']['url']} -O #{node['prometheus']['node_exporter']['binary']['file']}
    tar xzvf #{node['prometheus']['node_exporter']['binary']['file']} -C #{node['prometheus']['node_exporter']['dir']}
    mv #{node['prometheus']['node_exporter']['dir']}/node_exporter-#{node['prometheus']['node_exporter']['version']}.linux-amd64/node_exporter #{node['prometheus']['node_exporter']['dir']}
    rm -rf #{node['prometheus']['node_exporter']['binary']['file']} #{node['prometheus']['node_exporter']['dir']}/node_exporter-#{node['prometheus']['node_exporter']['version']}.linux-amd64
    EOH
  not_if { ::File.exist? ("#{node['prometheus']['node_exporter']['dir']}/node_exporter") }
end


link node['prometheus']['node_exporter']['executable'] do
  to		node['prometheus']['node_exporter']['path']
  owner 	node['prometheus']['user']
  group 	node['prometheus']['group']
  link_type	:symbolic
  action        :create
end

template node['prometheus']['node_exporter']['init'] do
source	'node_exporter.conf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[node_exporter]', :immediately
end

service 'node_exporter' do
	action		:start
	provider	Chef::Provider::Service::Upstart
	supports	:status => true, :restart => true, :reload => true
end
