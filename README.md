# Terraform_AWS

I built this project to create a Resource on AWS cloud using EC2 instances, RDS, Load Balancer. I found Terraform(https://www.terraform.io) to be the best tool to create a Resource quickly with one command 🚀.
<p align="center">

![Terraform](https://shorturl.at/QdN8W)
</p>

## Terraform Resources Used
- EC2
  - Two Master Node
  - Two Worker Node (can be increased)
- VPC
  - Public Subnet
  - Internet Gateway
  - Route Table
  - Security Group
- RDS
  - MySql 8.0
- Load Balancer
  - EC2 connection in High Availability
- Target Group
  - Connection between EC2 and Load Balancer
- Shell Script
  - commands to run the project and connect to RDS
<hr>

## Requirements Before Running
1- Make sure you have the terrafrom tools installed on your machine.

2- Add your Access key, Secret key and Key Pair name on line 3 and 4.

3- Make sure your IAM user has right permission to creating EC2, VPC, Route Table, Security Group and Internet Gateway.

## Running the Script
After doing the requirements, you are ready now, start clone the repo to your machine:
``` shell
git clone https://github.com/Abdulrhman-Faqihi/Terraform_AWS.git
cd Terraform_AWS/
```
Now execute terraform commands:
``` shell
terraform init
terraform plan #to show what going to build
terraform apply -auto-approve
```

## Accessing Your Cluster
* You can access your cluster by accessing the master node throw <b>ssh</b>, you can get the public IP of master node from terrform outputs. Below is example of ssh command:
``` shell
ssh -i <Your_Key_Piar> ec2-user@<MasterNode_Public_IP>
```

## Removing and Destroying AWS Resources
To destroy the hole resources that created after applying the script, just run the following command:
```shell
terraform destroy -auto-approve
```


<!-- CONTACT -->
## Contact Me

Abdulrhman Faqihi - Faqihi.a775@gmail.com

Project Link: [https://github.com/Abdulrhman-Faqihi/Terraform_AWS.git](https://github.com/Abdulrhman-Faqihi/Terraform_AWS.git)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/abdulrhman-faqihi-80282b310/
[github-shield]: https://img.shields.io/badge/-github-black.svg?style=for-the-badge&logo=github&colorB=555
[github-url]: https://github.com/Abdulrhman-Faqihi
