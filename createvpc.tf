resource "aws_vpc" "Example" {            
   cidr_block       = "10.0.0.0/16"
   instance_tenancy = "default"
 }

 resource "aws_internet_gateway" "internet_gateway" { 
    vpc_id =  aws_vpc.Example.id               
 }

 resource "aws_subnet" "publicsubnets" {    
   vpc_id =  aws_vpc.Example.id
   cidr_block = "10.0.0.0/16"       
 }

 resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Example.id
   cidr_block = "10.0.0.0/16"         
 }

 resource "aws_route_table" "PublicRT" {   
    vpc_id =  aws_vpc.Example.id
         route {
    cidr_block = "0.0.0.0/0"              
    gateway_id = aws_internet_gateway.internet_gateway.id
     }
 }

 resource "aws_route_table" "private_route" {   
   vpc_id = aws_vpc.Example.id
   route {
   cidr_block = "0.0.0.0/0"             
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
 }

 resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }

 resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.private_route.id
 }
 resource "aws_eip" "nateIP" {
   vpc   = true
 }

 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
 }
