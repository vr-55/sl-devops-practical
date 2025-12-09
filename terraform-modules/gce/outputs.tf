output "controller_ips" {
  description = "Controller node internal IPs"
  value       = { for k, v in google_compute_instance.controllers : k => v.network_interface[0].network_ip }
}

output "worker_ips" {
  description = "Worker node internal IPs"
  value       = { for k, v in google_compute_instance.workers : k => v.network_interface[0].network_ip }
}
