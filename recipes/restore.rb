include_recipe 'service'

file File.join(ENV['TEMP'], 'mixlib-shellout-2.0.1-universal-mingw32.gem') do
  notifies :remove, "chef_gem[mixlib-shellout]", :immediately
  action :delete
end

chef_gem 'mixlib-shellout' do
  compile_time false
  version '2.0.1'
  notifies :restart, "service[chef-client]"
  action :install
end
