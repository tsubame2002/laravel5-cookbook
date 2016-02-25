
apps = search("aws_opsworks_app")
apps.each do |app|
  app_path = "/var/www/html/#{app['shortname']}"

  file "/root/.ssh/id_rsa" do
    mode "600"
    content app['app_source']['ssh_key']
  end

  file "/root/.ssh/privateRepository.sh" do
    mode "700"
    content <<-EOL
    #!/bin/bash
    ssh -i /root/.ssh/id_rsa -o "StrictHostKeyChecking=no" "$@"
    EOL
  end

  git app_path do
    repository app['app_source']['url']
    revision app["app_source"]["revision" ]
    ssh_wrapper "/root/.ssh/privateRepository.sh"
    action :sync
  end

  # execute 'composer install'
  execute "composer" do
    command <<-EOH
      composer install -d #{app_path} --optimize-autoloader
    EOH
  end


  file "#{app_path}/.env" do
    group node["group"]
    owner node["user"]
    content lazy {
      dotenv = Chef::Util::FileEdit.new("#{app_path}/.env.example")
      dotenv.send(:contents).join
    }
  end

end