#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd nano
systemctl start httpd
systemctl enable httpd

# Docs for GCP metadata: https://cloud.google.com/compute/docs/metadata/predefined-metadata-keys

# Background the curl requests
curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google" &> /tmp/public_ipv4 &
curl -s "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" &> /tmp/az &
curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/mac" -H "Metadata-Flavor: Google" &> /tmp/macid &
curl -s "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google" &> /tmp/local_ipv4 &
wait

macid=$(cat /tmp/macid)
local_ipv4=$(cat /tmp/local_ipv4)
public_ipv4=$(cat /tmp/public_ipv4)
az=$(cat /tmp/az)
vpc=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/id" -H "Metadata-Flavor: Google")

echo "
<!doctype html>
<html lang=\"en\" class=\"h-100\">
<head>
<title>Details for GCP Compute Engine Instance</title>
</head>
<body>
<div>
<h1>GCP Instance Details</h1>
<h1>Starfleet Cluster</h1>

<br>
<img src="https://raw.githubusercontent.com/colby1394/GCP_Mini_Website_Public/refs/heads/main/Starfleet_Command_insignia.webp" alt="StarfleetLogo" width="200" height="200">
<br>

<p><b>Instance Hostname:</b> $(hostname -f) </p>
<p><b>Instance Private Ip Address: </b> ${local_ipv4}</p>
<p><b>Instance Public Ip Address: </b> ${public_ipv4}</p>
<p><b>Instance MAC Address: </b> ${macid}</p>
<p><b>Zone: </b> ${az}</p>
<p><b>Virtual Private Cloud (VPC):</b> ${vpc}</p>
</div>

<div>
<h1> Your IP Address</h1>
<a href="http://www.ipchicken.com">
<img src="http://www.ipchicken.com/images/ipc.gif" width="88" height="31" border="0"></a>
</div>
</body>
</html>
" > /var/www/html/index.html

# Clean up the temp files
rm -f /tmp/local_ipv4 /tmp/az /tmp/macid /tmp/public_ipv4


# Get ex ip #curl "http://metadata.google.internal/computeMetadata/v1/instk-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google"
#curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip" -H "Metadata-Flavor: Google"
# Get local ip #curl "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip" -H "Metadata-Flavor: Google"
# curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google"
# Get instance name #curl "http://metadata.google.internal/computeMetadata/v1/instk-name" -H "Metadata-Flavor: Google"
# Get instance zone #curl "http://metadata.google.internal/computeMetadata/v1/instk-zone" -H "Metadata-Flavor: Google"
# Get instance id #curl "http://metadata.google.internal/computeMetadata/v1/instk-id" -H "Metadata-Flavor: Google"
# Get instance type #curl "http://metadata.google.internal/computeMetadata/v1/instk-type" -H "Metadata-Flavor: Google"
# Get project id #curl "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google"
# Get project name #curl "http://metadata.google.internal/computeMetadata/v1/project/project-name" -H "Metadata-Flavor: Google"
# Get project number #curl "http://metadata.google.internal/computeMetadata/v1/project/numeric-project-id" -H "Metadata-Flavor: Google"
# Get project number #curl "http://metadata.google.internal/computeMetadata/v1/project/numeric-project-id" -H "Metadata-Flavor: Google"
