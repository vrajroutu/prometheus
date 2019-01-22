#
# Cookbook Name:: prometheus_server
# Recipe:: pro_server
#
# Copyright 2017, Outfront Media
#
# All rights reserved - Do Not Redistribute
#

directory node['prometheus']['server']['dir'] do
  owner	node['prometheus']['user']
  group	node['prometheus']['group']
  mode	0755
  recursive true
end

bash 'node_binary' do
  cwd ::File.dirname(node['prometheus']['server']['binary']['file'])
  code <<-EOH
    wget #{node['prometheus']['server']['binary']['url']} -O #{node['prometheus']['server']['binary']['file']}
    tar xzvf #{node['prometheus']['server']['binary']['file']} -C #{node['prometheus']['server']['dir']}
    rm -rf #{node['prometheus']['server']['binary']['file']} #{node['prometheus']['server']['dir']}/server-#{node['monitoring']['prometheus']['version']}.linux-amd64
	mv #{node['prometheus']['server']['dir']}/prometheus-#{node['monitoring']['prometheus']['version']}.linux-amd64/* #{node['prometheus']['server']['dir']}
	rm -rf #{node['prometheus']['server']['dir']}/prometheus-#{node['monitoring']['prometheus']['version']}.linux-amd64
    EOH
  not_if { ::File.exist? ("#{node['prometheus']['server']['dir']}/server") }
end
items = Array[]
items << "localhost:9090"
items << "localhost:9100"

puts items
	

template "/opt/prometheus/server/prometheus.yml" do
        source "prometheus.yml.erb"
        variables({
          :nodes=> items,
		  :alertmanager_scheme=> node['monitoring']['alertmanager']['scheme'],
		  :alertmanager_target=> node['monitoring']['alertmanager']['elb']
        })
		
end

template "/opt/prometheus/server/alert.rules" do
        source "alert.rules.erb"
end

job_name = ""
target = ""
scrape_interval = ""
labels_name = ""
labels_title = ""
metrics_path = ""
ruby_block 'wait_for_conf_file' do
  block do
	sleep 40
	node['monitoring']['prometheus']['targets'].each do |client_node|
		client_node.each do |key, value|
			puts key
			if key == "name" 
			    puts value
				job_name = value
				puts job_name
			end
			if key == "labels_title" 
				puts value
				labels_title = value
				puts labels_title	
			end	
			if key == "labels_name" 
				puts value
				labels_name = value
				puts labels_name	
			end
			if key == "metrics_path" 
				puts value
				metrics_path = value
				puts metrics_path	
			end
			if key == "target" 
				puts value
				target = value
				puts target	
			end	
			if key == "scrape_interval" 
				puts value
				scrape_interval = value
				puts scrape_interval
			end
		end		
		data1 = "  - job_name: '#{job_name}'"	
		data2 = "    metrics_path:   #{metrics_path}"	
		data3 = "    scrape_interval:   #{scrape_interval}"
		data4 = "    static_configs:"
		data5 = "      - targets: #{target}"
		data6 = "        labels: "
		data7 = "          #{labels_title}: '#{labels_name}' "
		
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << " \n"
		end
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << "#{data1} \n"
		end
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << "#{data2} \n"
		end
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << "#{data3} \n"
		end
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << "#{data4} \n"
		end
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << "#{data5} \n"
		end
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << "#{data6} \n"
		end
		File.open("/opt/prometheus/server/prometheus.yml", "a+") do |f|
		f << "#{data7} \n"
		end
    end
  end
end  

link node['prometheus']['server']['executable'] do
  to		node['prometheus']['server']['path']
  owner 	node['prometheus']['user']
  group 	node['prometheus']['group']
  link_type	:symbolic
  action        :create
end

template node['prometheus']['server']['init'] do
source	'prometheus.conf.erb'
owner 	node['prometheus']['user']
group 	node['prometheus']['group']
mode	0755
notifies :restart, 'service[prometheus]', :immediately
end

service 'prometheus' do
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


node['monitoring']['prometheus']['auth_users'].each do |authuser|
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
