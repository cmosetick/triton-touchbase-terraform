# define the docker provider for terraform
# using variables set in variables.tf file
provider "docker" {
  host = "${var.triton_dc}"
  cert_path = "${var.cert_path}"
}

# create contaniers based on pre-defined docker images
# as defined in images.tf file

resource "docker_container" "consul" {
    image = "${docker_image.consul.latest}"
    name = "consul"
    memory = "128"
    command = ["-server -bootstrap -ui-dir /ui"]
    dns = ["127.0.0.1"]
}

resource "docker_container" "couchbase" {
    image = "${docker_image.couchbase.latest}"
    count = "${var.couchbase_count}"
    name = "couchbase_"
    memory = "4096"
    env = ["CONSUL_HOST=http://consul:8500"]
    env = ["COUCHBASE_SERVICE_NAME=couchbase"]
    #provisioner "remote-exec" {
    #    inline = [
    #    "consul join ${docker_container.consul.ip}"
    #    ]
    #}
    links = ["consul:consul"]
}

# the main touchbase application
resource "docker_container" "touchbase" {
    image = "${docker_image.touchbase.latest}"
    name = "touchbase"
    memory = "1024"
    command = ["/opt/containerbuddy/containerbuddy", "-config", "file:///opt/containerbuddy/touchbase.json", "/usr/local/bin/run-touchbase.sh"]
    #provisioner "remote-exec" {
    #    inline = [
    #    "consul join ${docker_container.consul.ip}"
    #    ]
    #}
    links = ["consul:consul"]
}

# Nginx as a load-balancing tier and reverse proxy
resource "docker_container" "nginx" {
    image = "${docker_image.nginx.latest}"
    count = "${var.nginx_count}"
    name = "nginx_"
    memory = "512"
    env = ["CONTAINERBUDDY=file:///opt/containerbuddy/nginx.json"]
    command = ["/opt/containerbuddy/containerbuddy","nginx", "-g", "daemon off"]
    network_mode = "bridge"
    #provisioner "remote-exec" {
    #    inline = [
    #    "consul join ${docker_container.consul.ip}"
    #    ]
    #}
    links = ["consul:consul"]
}

# Support dynamic DNS for the load balancing tier
# https://www.joyent.com/blog/automatic-dns-updates-with-containerbuddy
resource "docker_container" "cloudflare" {
    image = "${docker_image.cloudflare.latest}"
    name = "cloudflare"
    memory = "128"
    env = ["CF_API_KEY=${var.cf_api_key}"]
    env = ["CF_AUTH_EMAIL=${var.cf_auth_email}"]
    env = ["CF_ROOT_DOMAIN=${var.cf_root_domain}"]
    env = ["SERVICE=nginx"]
    env = ["RECORD=${var.cf_record}"]
    env = ["TTL=600"]
    env = ["COUCHBASE_USER=${var.couchbase_user}"]
    env = ["COUCHBASE_PASS=${var.couchbase_pass}"]
    entrypoint = ["/opt/containerbuddy/containerbuddy", "-config", "file:///opt/containerbuddy/cloudflare.json"]
    network_mode = "bridge"
    #provisioner "remote-exec" {
    #    inline = [
    #    "consul join ${docker_container.consul.ip}"
    #    ]
    #}
    links = ["consul:consul"]
}
