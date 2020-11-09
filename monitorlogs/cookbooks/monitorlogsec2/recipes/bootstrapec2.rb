#
# Cookbook:: monitorlogsec2
# Recipe:: bootstrapec2
#
# Copyright:: 2020, The Authors, All Rights Reserved.




execute 'update yum' do
    command 'sudo yum update -y'
    # action :nothing
end

docker_service 'default' do
    action [:create, :start]
end

execute 'create log path' do
    command 'mkdir -p /var/log/herokupath'
end

execute 'install cloudwatch logs agent' do
    command 'sudo yum install amazon-cloudwatch-agent -y'
end

template '/opt/aws/amazon-cloudwatch-agent/bin/config.json' do
    source 'config.json.erb'
    owner 'root'
    group 'root'
end

execute 'start cloudwatch agent' do
    command 'sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json'
end

execute 'add bin path' do
    command 'export PATH="/usr/local/bin:$PATH"'
end

execute 'source file' do
    command 'source ~/.bashrc'
end

execute 'install heroku' do
    command 'curl https://cli-assets.heroku.com/install.sh | sh'
end


# template "#{ENV['HOME']}/.netrc" do
template "/home/ec2-user/.netrc" do
    source '.netrc.erb'
    owner 'ec2-user'
    group 'ec2-user'
end

execute 'change owner heroku folder' do
    command 'cd /var/log && sudo chown ec2-user herokupath/'
end

# Login to private registry
docker_registry '<registry URL>' do
    username ''
    password ''
    email ''
end

# Pull tagged image
docker_image '<custom docker image name>' do
    tag '<image tag>'
    action :pull
end

# Run container
docker_container 'herokulogscont' do
    repo '<custom docker image name>'
    tag '<image tag>'
    volumes [ '/var/log/herokupath:/var/log/herokupath' ] #change this volume mapping if needed
    action :run
end