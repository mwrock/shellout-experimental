include_recipe 'shellout-experimental::service'

file File.join(ENV['TEMP'], 'mixlib-shellout-2.0.1-universal-mingw32.gem') do
  action :delete
end

chef_gem 'removing mixlib-shellout' do
  compile_time false
  package_name 'mixlib-shellout'
  action :remove
end

chef_gem 'mixlib-shellout' do
  compile_time false
  version '2.0.1'
  notifies :restart, "service[chef-client]"
  action :install
end
