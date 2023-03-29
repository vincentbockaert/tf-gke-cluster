variable "region" {
  type = string
  default = "europe-west1-c"
}

variable "node_count" {
  type = string
  default = 1
}

variable "machine_type" {
  type = string
  default = "e2-medium"
}

variable "preemptibility" {
  type = bool
  default = true
}