
# terraform_aws_vpc_module

A Terraform module to provide an VPC in AWS.
Non VPC NAT Gateway.

## Usage

### vpc.tf

```
module "terraform_aws_vpc_module" {
  source = "git::https://github.com/SatoHiroyuki/terraform_aws_vpc_module.git"

  vpc_name = "vpc"
  dns_hostnames = "true"

  ip_address = "172.16.0.0/16"
  ip_address_network_portion = "172.16"
  public-route-igw = ".0.0/23,.32.0/23,.64.0/23,.96.0/23,.128.0/23,.160.0/23"
  public-route-variable = ".2.0/23,.34.0/23,.66.0/23,.98.0/23,.130.0/23,.162.0/23"
  protected-route-nat = ".4.0/23,.36.0/23,.68.0/23,.100.0/23,.132.0/23,.164.0/23"
  private-route-local = ".6.0/23,.38.0/23,.70.0/23,.102.0/23,.134.0/23,.166.0/23"

  availability_zone = "ap-northeast-1a,ap-northeast-1c"
  environment = "dev,dev,stg,stg,prd,prd"
}

```

### Sunet

cidr /16

![subnet](/images/subnet.jpg)

## Outputs

- `public-route-igw-id` - public-route-igw.*.id
- `public-route-variable-id` - public-route-variable.*.id
- `protected-route-nat-id` - protected-route-nat.*.id
- `private-route-local-id` - private-route-local.*.id
- `public-route-igw-table-id` - aws_route_table.public-route-igw-table.id
- `public-route-variable-table-id` - public-route-variable-table.id
- `protected-route-nat-table-id` - protected-route-nat-table.id
- `private-route-local-table-id` - private-route-local-table.id


## Authors

https://github.com/SatoHiroyuki

