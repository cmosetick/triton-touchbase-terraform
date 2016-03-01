# used to define provider in contaniers.tf
# mandatory
variable "triton_dc" {
  default = "tcp://us-east-1.docker.joyent.com:2376"
}
# certs are created by bash setup script
# curl -O https://raw.githubusercontent.com/joyent/sdc-docker/master/tools/sdc-docker-setup.sh && chmod +x sdc-docker-setup.sh
# ./sdc-docker-setup.sh -k us-east-1.api.joyent.com <ACCOUNT> ~/.ssh/<PRIVATE_KEY_FILE>
variable "cert_path" {
  default = "/Users/chris/.sdc/docker/chris.mosetick"
}

# define env variables for cloudflare and couchbase
variable "cf_api_key" {
  default = "insert your cloudflare api key here"
}
variable "cf_auth_email" {
  default = "my email associated with cloudflare account"
}
variable "cf_root_domain" {
  default = "ex mydomain.tld"
}
variable "cf_record" {
  default = "ex touchbase.mydomain.tld"
}
variable "couchbase_user" {
  default = "couchbase"
}
variable "couchbase_pass" {
  default = "MycouchbasePass"
}

variable "couchbase_count" {
  default = "2"
}
variable "couchbase_names" {
  default = {
    "0" = "couchbase_0"
    "1" = "couchbase_1"
  }
}

variable "nginx_count" {
  default = "1"
}

# not used right now
variable "couchbase_scale1" {
  default = {
    count = 1
  }
}
variable "couchbase_scale2" {
  default = {
    count = 2
  }
}
