# Challenge 0, Build a Java Developer VM

### Coach Notes:
#### Tooling:
The students can either work locally on their workstations or deploy a Java development machine VM in Azure using the provided template.  There is no need to do both.  We recommend using the Java Developer VM deployed in Azure as this provides a known-to-work common environment.

  - The following bash & powershell scripts can be provided to students to deploy the Build VM in Azure. Advise students to use one or the other depending on their platform.
	```bash
	# Bash Script
	RG="javahack-RG"  #Change as appropriate
	LOCATION="EastUS"  # Change as appropriate
	az group create --name $RG --location $LOCATION
	az deployment group create --name buildvmdeployment -g $RG \
    	-f wth-java-environment.json 

	```
	```Powershell
	# Powershell Script
	$RG="javahack-RG"  #Change as appropriate
	$LOCATION="EastUS"  # Change as appropriate
	az group create --name $RG --location $LOCATION
	az deployment group create --name buildvmdeployment -g $RG `
    	-f wth-java-environment.json 

	```

  - Once the Java development VM is deployed, you can Remote Desktop into the machine using port 22389 on the VMs public IP
	- **`mstsc -v <VM Public IP>:22389` **

	
  - The username is adminUsername



