#
# Cookbook Name:: prometheus_exporter
# Recipe:: mysql-setup
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#

directory node['prometheus']['mysqld_exporter']['dir'] do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
  recursive true
end

bash 'node_binary' do
  cwd ::File.dirname(node['prometheus']['mysqld_exporter']['binary']['file'])
  code <<-EOH
    wget #{node['prometheus']['mysqld_exporter']['binary']['url']} -O #{node['prometheus']['mysqld_exporter']['binary']['file']}
    tar xzvf #{node['prometheus']['mysqld_exporter']['binary']['file']} -C #{node['prometheus']['mysqld_exporter']['dir']}
    mv #{node['prometheus']['mysqld_exporter']['dir']}/mysqld_exporter-#{node['prometheus']['mysqld_exporter']['version']}.linux-amd64/mysqld_exporter #{node['prometheus']['mysqld_exporter']['dir']}
    rm -rf #{node['prometheus']['mysqld_exporter']['binary']['file']} #{node['prometheus']['mysqld_exporter']['dir']}/mysqld_exporter-#{node['prometheus']['mysqld_exporter']['version']}.linux-amd64
    EOH
  not_if { ::File.exist? ("#{node['prometheus']['mysqld_exporter']['dir']}/mysqld_exporter") }
end


link node['prometheus']['mysqld_exporter']['executable'] do
  to		node['prometheus']['mysqld_exporter']['path']
  owner 	node['prometheus']['user']
  group 	node['prometheus']['group']
  link_type	:symbolic
  action        :create
end

template node['prometheus']['mysqld_exporter']['init'] do
source	'mysqld_exporter.conf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[mysqld_exporter]', :immediately
end

template '/etc/.my.cnf' do
source	'my.cnf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[mysqld_exporter]', :immediately
end

service 'mysqld_exporter' do
	action		:start
	provider	Chef::Provider::Service::Upstart
	supports	:status => true, :restart => true, :reload => true
end
