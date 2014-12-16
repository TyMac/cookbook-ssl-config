# ssl-config-cookbook

This cookbook is aimed at making it easy to provide secure SSL/TLS settings in your webserver of choice. The recommendations are taken from [Mozilla's TLS Guidelines](https://wiki.mozilla.org/Security/Server_Side_TLS)

## Disclaimer

This repository provides a centralised easy way to encapsulate recommended SSL settings, across multiple sites. It may not always be up to date with the latest best practices as new protocols are published, and vulnerabilities in existing ones are discovered. Use of this cookbook does not constitute a magical security bullet, and the author(s) expressly makes no guarantee that use of this cookbook will necessarily result in correct security settings for your server. You should use this as a starting point, and check the generated results for yourself.

It is recommended that you read [Mozilla's TLS Guidelines](https://wiki.mozilla.org/Security/Server_Side_TLS) as a more definitive guide, and more frequently updated source of information. It is also recommended that you test the strength of your server's configuration together with the generated key and certificate via a tool such as [SSL Labs server test](https://www.ssllabs.com/ssltest/analyze.html) to get a better picture of the security of your specific site.

## Usage

### Nginx

```json
{
  "run_list": [
    "recipe[nginx]"
    "recipe[ssl-config::nginx]"
  ]
}
```

And in your nginx config template:

```
server {
  listen 443 ssl;
  servername example.com;

  include /etc/nginx/secure-ssl.conf;

  ssl_certificate /path/to/signed_cert_plus_intermediates;
  ssl_certificate_key /path/to/private_key;

  #...
}
```

### Apache

```json
{
  "run_list": [
    "recipe[apache2]"
    "recipe[ssl-config::apache]"
  ]
}
```

```
<VirtualHost *:443>
  ServerName example.com
  SSLEngine on
  SSLCertificateFile      /path/to/signed_certificate
  SSLCertificateChainFile /path/to/intermediate_certificate
  SSLCertificateKeyFile   /path/to/private/key
  SSLCACertificateFile    /path/to/all_ca_certs

  include /etc/apache2/secure-ssl.conf

  #...
</VirtualHost>

```

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ssl-config']['compatibility_mode']</tt></td>
    <td>String</td>
    <td><tt>Can be changed to "intermediate_compatibility" to support some older browsers</tt></td>
    <td><tt>"high_security"</tt></td>
  </tr>
  <tr>
    <td><tt>['ssl-config']['hsts']</tt></td>
    <td>Boolean</td>
    <td>Ensure you know what you are doing before turning this on. Forces browsers to always use https on the given domain</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['ssl-config']['tuning']['ssl_session_timeout']</tt></td>
    <td>String</td>
    <td>Tunable session timeout</td>
    <td><tt>"5m"</tt></td>
  </tr>
  <tr>
    <td><tt>['ssl-config']['tuning']['ssl_session_cache']</tt></td>
    <td>String</td>
    <td>Tunable session cache</td>
    <td><tt>"shared:SSL:5m"</tt></td>
  </tr>
</table>


## License and Authors

Author:: Jeremy Olliver (<jeremy.olliver@gmail.com>)
License:: Apache 2.0
