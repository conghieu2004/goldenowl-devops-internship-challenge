region       = "us-east-1"
project_name = "nodejs-ecs-demo"
key_name     = "d-kp-SAA-MyKeypair"
ami_id       = "ami-0157af9aea2eef346" 

# Route53 & SSL Configuration
domain_name = "hieuhc.online"    # Uncomment and set your domain
subdomain   = "myapp"               # Will create app.yourdomain.com
enable_ssl  = true                # Enable HTTPS with ACM certificate
