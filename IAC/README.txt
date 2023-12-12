Have to create VPCs - 1 prod vpc, 1 dev vpc

Dev VPC => 10.10.0.0/16
public-dev    -  2 => Autoscaling - public  subnet   [10.10.1.0/24 and 10.10.2.0/24]
Frontend-dev  -  2 => Autoscaling - private subnet   [10.10.3.0/24 and 10.10.4.0/24]
Backend-dev   -  2 => Autoscaling - private subnet   [10.10.5.0/24 and 10.10.6.0/24]
Mysql-dev     -  2 => Autoscaling - private subnet   [10.10.7.0/24 and 10.10.8.0/24]

Prod VPC => 10.20.0.0/16
public-prod   -  2 => Autoscaling - public  subnet   [10.20.1.0/24 and 10.20.2.0/24]
Frontend-prod -  2 => Autoscaling - private subnet   [10.20.3.0/24 and 10.20.4.0/24]
Backend-prod  -  2 => Autoscaling - private subnet   [10.20.5.0/24 and 10.20.6.0/24]
Mysql-prod    -  2 => Autoscaling - private subnet   [10.20.7.0/24 and 10.20.8.0/24]

Steps in each vpc:-
Create dev vpc
create 8 subnets [2 subnets public, 6 private subnets]
create route tables [for public subnets attach igw] //create igw before this step [for private subnets attach ngw] //create ngw before this step
Create SGs, NACLs allowing only necessary traffic
create autoscaling group to create instances on demand in each subnet
create Target group for all instances in each subnet
Create ALB and attach Target group to it.
Create dns records
Create vpc peering connection between prod, dev
Update vpc route tables with peering connection.