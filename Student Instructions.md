# Challenge 0, Build a Java Developer VM

## Introduction

To be able to complete some of the challenges today, you will need a Java Developer environment.

## Description

In this challenge we'll be creating an Azure Windows VM, which will contain Java 8, mvn, Azure CLI, VScode with the Java Extensions. 

- Deploy an Azure VM using provided ARM Template. The template deployment will ask you to provide an admin password for the VM. The 12-character password must meet 3 out of 4 of these criteria:
	 	- Have lower characters
		- Have upper characters
		- Have a digit
		- Have a special character 

	- **NOTE:** To Remote Desktop into the development machine use port 22389 on the VMs public IP:
    	- `mstsc -v <VM Public IP>:22389` 
    	- The username is adminUsername 
    
   - Verify that mvn, Java and and Azure CLI are installed on the VM.
