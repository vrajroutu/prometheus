#
# Cookbook Name:: prometheus_exporter
# Recipe:: process-setup
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#

directory node['prometheus']['process_exporter']['dir'] do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
  recursive true
end

bash 'node_binary' do
  cwd ::File.dirname(node['prometheus']['process_exporter']['binary']['file'])
  code <<-EOH
    wget #{node['prometheus']['process_exporter']['binary']['url']} -O #{node['prometheus']['process_exporter']['binary']['file']}
    tar xzvf #{node['prometheus']['process_exporter']['binary']['file']} -C #{node['prometheus']['process_exporter']['dir']}
    mv #{node['prometheus']['process_exporter']['dir']}/process-exporter-#{node['prometheus']['process_exporter']['version']}.linux-amd64/process-exporter #{node['prometheus']['process_exporter']['dir']}
    rm -rf #{node['prometheus']['process_exporter']['binary']['file']} #{node['prometheus']['process_exporter']['dir']}/process-exporter-#{node['prometheus']['process_exporter']['version']}.linux-amd64
    EOH
  not_if { ::File.exist? ("#{node['prometheus']['process_exporter']['dir']}/process-exporter") }
end


link node['prometheus']['process_exporter']['executable'] do
  to		node['prometheus']['process_exporter']['path']
  owner 	node['prometheus']['user']
  group 	node['prometheus']['group']
  link_type	:symbolic
  action        :create
end

template node['prometheus']['process_exporter']['init'] do
source	'process_exporter.conf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[process_exporter]', :immediately
end

service 'process_exporter' do
	action		:start
	provider	Chef::Provider::Service::Upstart
	supports	:status => true, :restart => true, :reload => true
end
