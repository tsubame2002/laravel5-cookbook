
apps = search("aws_opsworks_app")
apps.each do |app|
  app_path = "/var/www/html/#{app['shortname']}"



  git app_path do
    repository app['app_source']['url']
    deploy_key app['app_source']['ssh_key']
    action :sync
  end

end