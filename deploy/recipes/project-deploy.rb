node[:deploy].each do |app_name, deploy|


  # Add write-access permission to "shared/log" directory.
  execute "test" do
    command "echo 'test'"
  end
end