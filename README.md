# testApp
This is Terraform v0.14.8 project for creating Test environment at Google Cloud Provider with Netdata monitoring system.
How it works:
- Creates 3 vm instance (f1-micro by default) Redis, testApp1, testApp2
- Configuring each instance (public ip's, Redis connection, ssh connection, Netdata monitoring agent)
- After executing it outputs public ip's of instances. You can monitor each instance separetely at http://ip:19999/ or monitor they all if you provide token for Netdata Cloud. testApp1 and testApp2 working on 3000 port and use Redis.
- Everything is ready ~20 min after executing (f1-micro instance)

For setup you need:
- JSON-file for connecting to your GCP project. It's should be genereted at GCP console. Also enable Compute Engine API at your project. And create service account.
- NetData token generated at Netdata Cloud console
- ssh public key

Fill up terraform.tfvars like this:

- gcp_json = "xxxx.json"
- gcp_project_name = "xxxx"
- ssh_key_pub = "login:ssh-ed25519 XXXXXXXXXX xxxx@gmail.com"
- netdata_token = "xxxxxxxx -rooms=xxxxx -url=https://app.netdata.cloud"
