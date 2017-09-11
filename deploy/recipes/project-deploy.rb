
apps = search("aws_opsworks_app")
database = search("aws_opsworks_rds_db_instance").first

apps.each do |app|
  if database
    dbname = app['data_sources'].first['database_name']
  end
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
  if app["environment"] && app["environment"]["WIKI"]

  else
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
        if node.has_key?("dotenv")
          node["dotenv"].each do |key, value|
            dotenv.search_file_replace_line(/^#{key}=.*$/, "#{key}=#{value}\n")
          end
        end
        
        if database
          dotenv.search_file_replace_line(/^DB_HOST=.*$/, "DB_HOST=#{database['address']}\n")
          dotenv.search_file_replace_line(/^DB_DATABASE=.*$/, "DB_DATABASE=#{dbname}\n")
          dotenv.search_file_replace_line(/^DB_USERNAME=.*$/, "DB_USERNAME=#{database['db_user']}\n")
          dotenv.search_file_replace_line(/^DB_PASSWORD=.*$/, "DB_PASSWORD=#{database['db_password']}\n")
        end

        if app["environment"]
          app["environment"].each do |key, value|
            dotenv.search_file_replace_line(/^#{key}=.*$/, "#{key}=#{value}\n")
          end
        end

        dotenv.send(:editor).lines.join
      }
    end

    directory "#{app_path}/storage/logs" do
      action :delete
      recursive true
    end
    directory "#{app_path}/storage/logs" do
      group node["group"]
      owner node["user"]
      action :create
    end

    execute "change owner" do
      command "chown -R #{node["user"]}:#{node["group"]} #{app_path}"
    end

    execute "Add write-access permission to storage directory" do
      command "chmod -R 775 #{app_path}/storage"
    end

    execute "Add write-access permission to bootstrap/cache directory" do
      command "chmod -R 775 #{app_path}/bootstrap/cache"
    end
  end

  



end