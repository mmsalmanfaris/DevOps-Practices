
## Setting Up a Self-Hosted GitHub Actions Runner (EC2)

  
 1. Create an EC2 instance (Ubuntu recommended).
 2. Update security group – allow inbound/outbound on HTTP (80) and HTTPS (443).
 3. Go to your GitHub repo → Settings → Actions → Runners → Add Runner.
 4. Copy the setup commands and run them on your EC2 instance.
 5. Update your workflow file to use:

    `runs-on: self-hosted`
