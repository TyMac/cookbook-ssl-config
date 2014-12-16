default['ssl-config']['compatibility_mode'] = 'high_security' # Set to true to support more clients, at the cost of a less secure setup
default['ssl-config']['hsts'] = false # Be CAREFUL enabling HSTS - it will force your browser to always use https for the given domain, so be sure your setup is complete and ready

default['ssl-config']['ocsp'] = {}

default['ssl-config']['tuning']['ssl_session_timeout'] = '5m'
default['ssl-config']['tuning']['ssl_session_cache'] = 'shared:SSL:5m'


default['ssl-config']['private_dir'] = '/etc/ssl/private'
