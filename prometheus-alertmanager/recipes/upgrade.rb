#
# Cookbook Name:: prometheus_alertmanager_node
# Recipe:: pro_alertmanager
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#


bash 'upgrade_node_binary' do
  cwd ::File.dirname(node['prometheus']['alertmanager']['binary']['file'])
  code <<-EOH
    echo #{node['prometheus']['alertmanager']['binary']['url']}
    wget #{node['prometheus']['alertmanager']['binary']['url']} -O #{node['prometheus']['alertmanager']['binary']['file']}
    tar xzvf #{node['prometheus']['alertmanager']['binary']['file']} -C #{node['prometheus']['alertmanager']['dir']}    
	EOH
  not_if { ::File.exist? ("#{node['prometheus']['alertmanager']['dir']}/alertmanager") }
end
#mv #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64/alertmanager #{node['prometheus']['alertmanager']['dir']}
	#mv #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64/amtool #{node['prometheus']['alertmanager']['dir']}
	#mv #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64/LICENSE #{node['prometheus']['alertmanager']['dir']}
	#mv #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64/NOTICE #{node['prometheus']['alertmanager']['dir']}
	
#rm -rf #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64
#rm -rf #{node['prometheus']['alertmanager']['binary']['file']} #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64
    
service 'alertmanager' do
	action		:start
	provider	Chef::Provider::Service::Upstart
	supports	:status => true, :restart => true, :reload => true
end

