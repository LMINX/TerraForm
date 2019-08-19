provider "alicloud" {
  access_key = "LTAIekx7VJ58lbAp"
  secret_key = "jgPBMul45hC3kse3rm5SPzl6a8mzoe"
  region     = "cn-hangzhou"
}

#select Select/Create OS image,Network,VmType,Storage Type,NIC,Given ServerName,Post Configuration (Azure use DSC)
#Option: SLB

data "alicloud_images" "Win2016" {
  name_regex  = "^win2016"
  most_recent = true
  owners      = "system"
}

data  "alicloud_vpcs" "MyVPC" {
  name_regex       = "^MyVPC"
  cidr_block = "172.16.0.0/16"
}

data "alicloud_instance_types" "MyVMType" {
  cpu_core_count = 2
  memory_size = 4
  instance_type_family = "ecs.c5"
}

data "alicloud_security_groups" "MySecurityGroup" {
  vpc_id = "${data.alicloud_vpcs.MyVPC.vpcs.0.id}"
}



output "Win2016_id" {
  value = "${data.alicloud_images.Win2016.images.0.id}"
}

output "MyVPC" {
  value = "${data.alicloud_vpcs.MyVPC.vpcs.0.vswitch_ids.0}"
}

output "MyVMType" {
  value = "${data.alicloud_instance_types.MyVMType.instance_types.0.id}"
}

output "MySecurityGroup" {
  value = "${data.alicloud_security_groups.MySecurityGroup.groups.0.id}"
}


resource "alicloud_instance" "instance" {
  # cn-beijing
  #availability_zone = "cn-beijing-b"
  security_groups = ["${data.alicloud_security_groups.MySecurityGroup.groups.0.id}"]
  

  # series III
  instance_type        = "${data.alicloud_instance_types.MyVMType.instance_types.0.id}"
  system_disk_category = "cloud_efficiency"
  image_id             = "${data.alicloud_images.Win2016.images.0.id}"
  instance_name        = "ALIJI"
  vswitch_id ="${data.alicloud_vpcs.MyVPC.vpcs.0.vswitch_ids.0}"
  internet_max_bandwidth_out = 1
}




