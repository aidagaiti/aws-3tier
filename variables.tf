variable "region"{
description = "please provide a region information"
type = string 
default = "us-east-1"
}

#cidr for VPC
variable "vpc_cidr" {
  description = "provide vpc_cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", ]
}

#cidr for 1SUBNET_PUBLIC
variable "subnetpublic1_cidr" {
    type = string
    default = "10.0.101.0/24"
}

#cidr for 2SUBNETPUBLIC
variable "subnetpublic2_cidr" {
    type = string
    default = "10.0.102.0/24"

}

#cidr for 3SUBNETPUBLIC
variable "subnetpublic3_cidr" {
    type = string
    default = "10.0.103.0/24"
}
#cidr for 1SUBNETPRIVATE
variable "subnetprivate1_cidr" {
    type = string
    default = "10.0.1.0/24"
}
#cidr for 2SUBNETPRIVATE
variable "subnetprivate2_cidr" {
    type = string
    default = "10.0.2.0/24"
}
#cidr for 3SUBNETPRIVATE
variable "subnetprivate3_cidr" {
    type = string
    default = "10.0.3.0/24"

}

variable "private_key" {
  description = "private key location"
  type        = string
  default     = "/home/ec2-user/.ssh/id_rsa"
}

variable "instance_username" {
  description = "user to ssh to remote host"
  type        = string
  default     = "ec2-user"
}


variable "hosted-zone-id" {
    description = "provide zone id"
    type = string
 default = "Z0680016PA4LTHI66LBC"
} 

variable "domain-name" {
    description = "provide domain name"
    type = string
 default = "hawaii2021.click"
} 


#wordpress.hawaii2021.click