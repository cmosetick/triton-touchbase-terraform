# define docker images for use by the contaniers

resource "docker_image" "consul" {
    name = "progrium/consul:latest"
}
resource "docker_image" "nginx" {
    name = "0x74696d/triton-touchbase-demo-nginx:latest"
}
resource "docker_image" "couchbase" {
    name = "misterbisson/triton-couchbase:enterprise-4.0.0-r1"
}
resource "docker_image" "touchbase" {
    name = "0x74696d/triton-touchbase:latest"
}
resource "docker_image" "cloudflare" {
    name = "0x74696d/triton-cloudflare:latest"
}
