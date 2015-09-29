powershell_script 'test a long running script' do
  code <<-EOS
    start-sleep 3000
  EOS
end
