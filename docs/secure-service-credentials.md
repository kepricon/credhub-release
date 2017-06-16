#Configuring Secure Service Credentials for Use with CredHub

A secure service credential is a certificate that your application uses to identify itself to CredHub via MTLS. During 
the MTLS handshake CredHub will also present a certificate that your application will validate as part of the 
communication protocol. In order to enable this handshake the following tasks must be accomplished:

First set up a load-balancer to give CF access to CredHub

* Create CredHub LB
* Create external DNS for CredHub LB
* Set env variable in environment
```
cf set-running-environment-variable-group '{"CREDHUB_API":"https://credhub.diego.security.cf-app.com:8844"}'
```


Then Diego must be configured to use a CA that is trusted by CredHub by setting the following values in the CF deployment manifest

* `diego.executor.instance_identity_ca_cert` and `diego.executor.instance_identity_key` must point to a CA and 
  private key that CredHub trusts (how do we get that? `instance_identity_ca.certificate` and 
  `instance_identity_ca.private_key`?). See 
  [here](https://github.com/cloudfoundry/diego-release/blob/develop/docs/instance-identity.md) for more details.
* `diego.executor.ca_certs_for_downloads` must point to something like `blobstore_tls.ca` (?)
* configure cloud controller communication with diego
```
cc:
     diego:
       temporary_local_apps: true
       temporary_local_staging: true
       temporary_local_tasks: true
 ```
* remove the `nsync` and `stager` jobs from the manifest
* Add CredHub CA to container trusted certificates 
```
name: diego-cell 
  jobs: 
  - name: cflinuxfs2-rootfs-setup
    release: cflinuxfs2-rootfs
    properties:
      cflinuxfs2-rootfs:
        trusted_certs: ((credhub_ca.certificate))
```
