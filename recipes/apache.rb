include_recipe 'ssl-config::default'

template 'apache-ssl-config' do
  source 'apache-ssl.conf.erb'
  path "#{node['apache']['dir']}/secure-ssl.conf"
  mode '0600'
  helpers(SslConfigHelper)
  variables({
    :session_timeout => node['ssl-config']['tuning']['ssl_session_timeout'],
    :session_cache   => node['ssl-config']['tuning']['ssl_session_cache']
  })
end
