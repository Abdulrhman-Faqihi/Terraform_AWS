#Region for Resource
variable "region" {
        description = "The region zone on AWS"
        default = "us-east-1" 
}

#Access Key for acount 
variable "access_key" {
        description = "Access key to AWS console"
        default = "################################" 
}
#Secret Key for acount
variable "secret_key" {
        description = "Secret key to AWS console"
        default = "################################"
}

#Key Pair 
variable "ami_key_pair_name" {
    default = "tes" 
}

#AMI for Amazon Linux 2023 For create EC2 instance
variable "ami_id" {
        description = "The AMI to use"
        default = "ami-06b21ccaeff8cd686"
}

variable "instance_type" {
        default = "t2.medium" 
}
#For RDS 
variable "engine" {
    default = "mysql"
}

variable "database_name" {
    default = "lockers"
}

variable "database_username" {
    default = "admin"
}

variable "database_password" {
    default = "Password1231"
}

variable "instance_class"{
    default = "db.t3.small"
}

variable "engine_version" {
    default = "8.0"
}

variable "parameter_group_name" {
    default = "default.mysql8.0"
}

