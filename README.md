# Docker ApacheDS

This is a Docker image for [Apache Directory Server](http://directory.apache.org/apacheds/). It is *very* easy to run and can be configured using [Apache Directory Studio](http://directory.apache.org/studio/) or any other LDAP client like phpldapadmin. The container can also generate trusted certificates for serving LDAPS.

## Usage

Just run the container with forwarded LDAP ports and you are done!

```sh
docker run -d --name apacheds -p 10389:10389 -p 10636:10636 -v apacheds-data:/opt/apacheds/instances/default kadimasolutions/apacheds
```

This will start the ApacheDS server and persist its data in the named volume `apacheds-data`.

The server will be started with ApacheDS's default configuration. The default admin user's distinguished name (DN) is `uid=admin,ou=system` and the password is `secret`. This should be customized according to your needs using an LDAP client ( see above ).

You can also use Docker Compose:

```yaml
version: '3'
services:
  apacheds:
    image: kadimasolutions/apacheds:latest
    tty: true
    stdin_open: true
    ports:
     - 10389:10389
     - 10636:10636
    volumes:
     - apacheds-data:/opt/apacheds/instances/default

volumes:
  apacheds-data:
```

## Using ACME to Generate Certificates

The container can automatically generate and renew trusted certificates verified by LetsEncrypt using DNS verification. This allows you to generate certificates behind a firewall, but only works if you have a [supported DNS provider](https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md).

Here is an example Docker Compose file. Notice that there is an extra volume that must be persisted for the ACME cert data:

```yaml
version: '3'
services:
  apacheds:
    image: kadimasolutions/apacheds:latest
    tty: true
    stdin_open: true
    environment:
      ACME_ENABLED: "true" # Default: false
      ACME_TEST_MODE: "true" # Default: false
      ACME_DOMAIN: ldap.mysite.com # Default: example.com
      ACME_KEYSTORE_PASSWORD: helloworld # Default: changeit
      # See https://github.com/Neilpang/acme.sh/blob/master/dnsapi/README.md
      ACME_DOMAIN_PROVIDER: dns_aws # Default: dns_cf
      # Access keys specific to domain provider
      AWS_ACCESS_KEY_ID: supersecretkeyid
      AWS_SECRET_ACCESS_KEY: supersecretaccesskey
    ports:
     - 10389:10389
     - 10636:10636
    volumes:
     - apacheds-data:/opt/apacheds/instances/default
     - acme-data:/root/.acme.sh

volumes:
  apacheds-data:
  acme-data:
```

When the container runs it will generate a trusted certificate and put it in a keystore at  `/opt/apacheds/instances/default/conf/apacheds.p12`. You can then log onto the server using the normal LDAP protocol ( not encrypted ) and update the LDAPS configuration to use the keystore with the configured password ( if not specified in the environment variables, the default password is `changeit` ).

After restarting the container LDAPS should be working and you should be able to connect to it from any LDAP client using LDAPS or StartTLS.

> **Note:** The container will automatically renew the certificate before it expires. After the certificate is renewed the ApacheDS server will **restart automatically**. The server will be down for the short period of time that it takes ApacheDS to restart.
>
>The certificate renewal check is performed at 12:30am every day.
