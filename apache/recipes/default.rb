#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

if node['platform_family'] == 'amazon' || node['platform_family'] == 'rhel'

    package 'httpd' do
     action :install
    end
      
    template '/var/www/html/index.html' do
     source 'index.html.erb'
     owner 'root'
     group 'root'
     mode '0755'
     variables(
       :os => node['os'],
       :platform_family => node['platform_family'],
       :pri_ip => node['ec2']['local_ipv4'],
       :pub_ip => node['ec2']['public_ipv4']
       )
     notifies :restart, 'service[httpd]', :immediately
    end
        
   service 'httpd' do
     action [:enable, :start]
   end

  aws_s3_file '/tmp/foo' do
    bucket 'i_haz_an_s3_buckit'
    remote_path 'path/in/s3/bukket/to/foo'
    region 'us-west-1'
  end

elsif node['platform_family'] == 'debian'

    apt_update 'update' do
      action :update
    end

    package 'apache2' do
     action :install
    end

    template '/var/www/html/index.html' do
      source 'index.html.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        :os => node['os'],
        :platform_family => node['platform_family'],
        :pri_ip => node['ec2']['local_ipv4'],
        :pub_ip => node['ec2']['public_ipv4']
      )
      notifies :restart, 'service[apache2]', :immediately
    end
    service 'apache2' do
      action [:enable, :start]
    end

else
    puts "This cookbook is not supported on #{node['platform_family']}."
end
