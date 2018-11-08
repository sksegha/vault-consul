# vault-consul
A cluster of Vault and Consul Nodes
A number of vault servers (a Pre-baked instance with consul client and vault server installed )

A number of consul servers ( a pre-baked instance with consul server installed)

My typical way of configuring my servers is to build the AMI using packer with most of the configuration baked in; and then run
ansible playbook on startup that configure other environmental based properties. My ansible playbook also calls the tags on the instances
and configures them based on these tags; so that a consul server gets a set of configuration items and the clients get another set.
 
