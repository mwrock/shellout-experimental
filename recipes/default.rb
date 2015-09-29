include_recipe 'shellout-experimental::service'

shellout_gem = 'mixlib-shellout-2.0.1-universal-mingw32.gem'
source = File.join(ENV['TEMP'], shellout_gem)
cookbook_file source do
  source shellout_gem
  notifies :remove, "chef_gem[mixlib-shellout]", :immediately
end

chef_gem 'mixlib-shellout' do
  source source
  compile_time false
  notifies :restart, "service[chef-client]"
  action :install
end
