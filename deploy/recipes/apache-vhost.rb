# setup Apache virtual host
apps = search("aws_opsworks_app")

apps.each do |app|
  vhostname = app['domains'].first
  app_name = app['shortname']
  app_path = "/var/www/html/#{app['shortname']}"
  docroot = "#{app_path}/#{app['attributes']['document_root']}"

  template "/etc/httpd/conf.d/#{app['shortname']}.conf" do
    mode 0604
    source 'web_app.conf.erb'
    variables ({
      :port => 80,
      :vhostname => vhostname,
      :docroot  =>  docroot,
      :app_name => app_name
    })
  end

  execute "httpd graceful" do
    command "service httpd graceful"
  end

end