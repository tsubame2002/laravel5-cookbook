app = search("aws_opsworks_app")
app.each do


  # Add write-access permission to "shared/log" directory.
  execute "test" do
    command "echo 'test'"
  end
end