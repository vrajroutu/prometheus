#
# Cookbook Name:: prometheus_alertmanager_node
# Recipe:: pro_alertmanager
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#


directory node['prometheus']['alertmanager']['dir'] do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
  recursive true
end

bash 'node_binary' do
  cwd ::File.dirname(node['prometheus']['alertmanager']['binary']['file'])
  code <<-EOH
    wget #{node['prometheus']['alertmanager']['binary']['url']} -O #{node['prometheus']['alertmanager']['binary']['file']}
    tar xzvf #{node['prometheus']['alertmanager']['binary']['file']} -C #{node['prometheus']['alertmanager']['dir']}    
	mv #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64/* #{node['prometheus']['alertmanager']['dir']}
	rm -rf #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64
	rm -rf #{node['prometheus']['alertmanager']['binary']['file']} #{node['prometheus']['alertmanager']['dir']}/alertmanager-#{node['monitoring']['alertmanager']['version']}.linux-amd64
    EOH
  not_if { ::File.exist? ("#{node['prometheus']['alertmanager']['dir']}/alertmanager") }
end


template "/opt/prometheus/alertmanager/alertmanager.yml" do
        source "simple.yml.erb"
        variables({
          #:api=> node['monitoring']['alertmanager']['slack']['api']
          :emailsmtp=> node['monitoring']['alertmanager']['email']['smtp_smarthost'],
		  :fromemail=> node['monitoring']['alertmanager']['email']['smtp_from'],
		  :username=> node['monitoring']['alertmanager']['email']['smtp_auth_username'],
		  :password=> node['monitoring']['alertmanager']['email']['smtp_auth_password'],
		  :infra_team=> node['monitoring']['teams_to_alert']['infra_team'],
		  :db_team=> node['monitoring']['teams_to_alert']['db_team'],
		  :itops_team=> node['monitoring']['teams_to_alert']['itops_team'],
		  :pagerdutyapi=> node['monitoring']['alertmanager']['pagerduty']['api']
        })
      end


link node['prometheus']['alertmanager']['executable'] do
  to		node['prometheus']['alertmanager']['path']
  owner 	node['prometheus']['user']
  group 	node['prometheus']['group']
  link_type	:symbolic
  action        :create
end

template node['prometheus']['alertmanager']['init'] do
source	'alertmanager.conf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[alertmanager]', :immediately
end

service 'alertmanager' do
	action		:start
	provider	Chef::Provider::Service::Upstart
	supports	:status => true, :restart => true, :reload => true
end

package 'nginx' do
  action :install
end

package 'apache2-utils' do
  action :install
end

auth_user = ""
auth_userpasswd = ""

file '/etc/nginx/.htpasswd' do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
end

node['monitoring']['alertmanager']['auth_users'].each do |authuser|
	authuser.each do |key, value|
		puts key
		if key == "auth_user" 
		    puts value
			auth_user = value
			puts auth_user
		end
		if key == "auth_password" 
		    puts value
			auth_userpasswd = value
			puts auth_userpasswd
		end
	end
	bash "auth-user" do
		code <<-EOH
		htpasswd -db /etc/nginx/.htpasswd #{auth_user} #{auth_userpasswd}
		EOH
	end
end

template "/etc/nginx/sites-enabled/default" do
source "nginx.conf.erb"
notifies :reload, "service[nginx]", :delayed
end

bash "Validate Ngix" do
  code <<-EOH
  nginx -t
  EOH
end

service "nginx" do
  action :restart
end
  

