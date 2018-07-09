module SslConfigHelper

  def ssl_config_banner
    %Q(# This SSL config is generated via chef, with recommendations from https://wiki.mozilla.org/Security/Server_Side_TLS)
  end

  def ssl_protocols(server = 'nginx')
    case server
    when 'nginx'
      CIPHERS_AND_VERSIONS[security_mode]['versions']
    when 'apache'
      'all -SSLv2 -SSLv3 -TLSv1.1 -TLSv1'
    end
  end

  def ssl_ciphers
    CIPHERS_AND_VERSIONS[security_mode]['ciphers']
  end

  def hsts_time
    case value = node['ssl-config']['hsts']
    when true, 'on'
      '15768000'
    when false, nil
      false
    else
      value
    end
  end

  def nginx_ssl_stapling_settings
    if node['ssl-config']['ocsp']['cert_path'] && node['ssl-config']['ocsp']['resolver']
      {
        'cert_path' => node['ssl-config']['ocsp']['cert_path'],
        'resolver' => node['ssl-config']['ocsp']['resolver']
      }
    else
      false
    end
  end

  def apache_ssl_stapling?
    !!node['ssl-config']['ocsp']['enabled']
  end

  private

  def security_mode
    mode = node['ssl-config']['compatibility_mode']
    return 'high_security' unless CIPHERS_AND_VERSIONS.keys.include?(mode)
    return mode
  end

  CIPHERS_AND_VERSIONS = {
    'high_security' => {
      'ciphers' => %Q(ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256),
      'versions' => 'TLSv1.2'
    },
    'intermediate_compatibility' => {
      'ciphers' => %Q(ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA),
      'versions' => 'TLSv1 TLSv1.1 TLSv1.2'
    }
  }.freeze

end
