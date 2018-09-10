# Docker ApacheDS

This is a Docker image for [Apache Directory Server](http://directory.apache.org/apacheds/). It is *very* easy to run and can be configured using [Apache Directory Studio](http://directory.apache.org/studio/) or any other LDAP client like phpldapadmin.

## Usage

Just run the container the the forwarded LDAP ports and you are done!

```sh
docker run -d --name apacheds -p 10389:10389 -p 10636:10636 -v apacheds-data:/opt/apacheds/instances kadimasolutions/apacheds
```

This will start the ApacheDS server and persist its data in the named volume `apacheds-data`.

The server will be started with ApacheDS's default configuration. The default admin user's distinguished name (DN) is `uid=admin,ou=system` and the password is `secret`. This should be customized according to your needs using an LDAP client ( see above ).
