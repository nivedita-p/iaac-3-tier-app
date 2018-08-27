#Module Information
This terraform module create a highly available 3-tier application stack. It will create two instances of a webserver, two instances of an application server, 2 loadbalancers, HTTP healthcheck endpoints, an instance of mananged CLOUD SQL, a db and user on CLOUD SQL and some relevant firewall rules on Google Cloud Platform.

In appservers.tf, two VMs are instantiated with tomcat8 installed on them. Both these instances are added to a target pool with a health check on port 8080. I created en external loadbalancer in front of this target pool using google_compute_forwarding_rule. This would put these VMs behind a public IP address. The better way to do this would be to create a managed instance group with instance template, this would create an Internal Load Balancer and put this VM pool behind a RFC1918 (private) IP address.

In webservers.tf similar approach is followed for webservers, i.e. 2 VMs running nginx behind a load balancer.

In databases.tf, a managed Cloud SQL instance running MySQL 5.6 is created followed by a databse and a user.

In firewall.tf, firewall rules to allow ICMP traffic and TCP traffic have been created to allow traffic to web and app servers.

On successfull execution, it will return IP addresses of web and server loadbalancers and db instance on the screen, like:
```
Outputs:

app_lb_ip = 35.233.68.84
db_instance_ip = [
    {
        ip_address = 173.194.224.168,
        time_to_retire = 
    }
]
db_instance_name = terraform-20180827084108243900000001
web_lb_ip = 35.241.169.63
```
# Setup
 - Install terraform
 - Create a service account with editor privileges and download the key
 - Create a bucket to store terraform state
 - Update the relevant variables in vars.tf
 - Set environment variable `GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json`

# Usage
 - `cd interview-tf-solution`
 - `terraform init`
 - `terraform plan`
 - `terraform apply`
