triton-touchbase-terraform
==========================

_Point triton-terraform to an entire datacenter where you can you run touchbase and couchbase with docker on bare metal triton containers without managing vm's_

# WIP
TODO
* Make sure that the correct containers get public IP addresses.
* Fix race condition with consul container not being ready.
* Fix nginx and touchbase containers quitting immediately after creation.


# Prereqs
* configure `$HOME/.terraformrc` file
* install [triton-terraform](https://github.com/joyent/triton-terraform) go binary to e.g. `$HOME/bin`
* Triton environment is installed and working correctly i.e. you can run a docker container on triton such as `docker run --rm -it ubuntu:14.04 /bin/bash`

```
# $HOME/.terraformrc example

# Path to where a custom plugin binary is located
providers {
  triton = "/Users/chris/bin/triton-terraform"
}

# configure the provider to use a
provider "triton" {
  account = "chris" # your account name in my.joyent.com web console
  key = "~/.ssh/id_rsa" # the path to your key. # If removed, defaults to ~/.ssh/id_rsa
  key_id = "MD5 fingerprint for public half of key listed above" # The corresponding key signature from your account page
}
```

# Usage
Just use terraform like normal. The triton-provider will be loaded automatically.
e.g.
```
terraform plan
terraform apply    # consul container will be created
terraform apply    # other containers will be created
terraform destroy  # to remove the entire cluster
```

# Configure provider in variables.tf
```
provider "docker" {
  host = "tcp://us-east-1.docker.joyent.com:2376" # datacenter you want to use
  cert_path = "/Users/chris/.sdc/docker/chris" # make sure that you ran bash setup script!
}
```

# Create the containers in container.tf
e.g.

```
resource "docker_container" "touchbase" {
    image = "${docker_image.touchbase.latest}"
    name = "foo"
}
```

# Define the images in images.tf
e.g.
```
resource "docker_image" "touchbase" {
    name = "0x74696d/triton-touchbase:latest"
}
```

# define the env for cloudflare and couchbase in variables.tf
e.g.
```
variable "cf_api_key" {
  default = "1234567890"
}

variable "couchbase_user" {
  default = "couchbase"
}

etc, etc.

```

### Notes
For syntax highlighting of terraform files in Atom editor, install package `language-terraform`.  
e.g.  
`apm install language-terraform`
