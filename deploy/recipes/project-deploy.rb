
apps = search("aws_opsworks_app")
apps.each do |app|
  app_path = "/var/www/html/#{app['shortname']}"


  # Add write-access permission to "shared/log" directory.
  execute "test" do
    command "echo 'test'"
  end

  git app_path do
    repository app['app_source']['url']
    action :sync
  end

end