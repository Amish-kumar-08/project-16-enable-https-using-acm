# Project 16: Enable HTTPS Using AWS Certificate Manager (ACM)

## Overview

Configured secure HTTPS access for a website hosted on an Amazon EC2 instance using an Application Load Balancer (ALB) and AWS Certificate Manager (ACM).

Deployed a static website using Nginx on Ubuntu EC2, configured an internet-facing Application Load Balancer, imported a self-signed SSL/TLS certificate into ACM, and enabled automatic HTTP-to-HTTPS redirection.

**Note:** A self-signed certificate was used because no custom domain was available. HTTPS encryption works, but browsers do not automatically trust this certificate and display a security warning.

## Architecture

```text
                 Internet Users
                       |
                       |
              Application Load Balancer
                       |
                ----------------
                |              |
             HTTP :80       HTTPS :443
                |              |
             Redirect       ACM Certificate
                |              |
                -------> HTTPS :443
                               |
                         Target Group
                           HTTP :80
                               |
                         Amazon EC2
                         Ubuntu 24.04
                               |
                            Nginx
                               |
                         Static Website
```

## Objectives

- Launch an Ubuntu EC2 instance.
- Deploy a static website using Nginx.
- Create an Application Load Balancer.
- Configure a target group and health checks.
- Generate a self-signed SSL/TLS certificate using OpenSSL.
- Import the certificate into AWS Certificate Manager.
- Configure an HTTPS listener on port 443.
- Redirect HTTP traffic from port 80 to HTTPS.
- Validate secure website access.

## AWS Resources

| Resource | Configuration |
|---|---|
| AWS Region | ap-south-1 (Mumbai) |
| EC2 Instance | t3.micro |
| Operating System | Ubuntu 24.04 LTS |
| Web Server | Nginx |
| Load Balancer | Application Load Balancer |
| Load Balancer Scheme | Internet-facing |
| Target Group Protocol | HTTP |
| Target Group Port | 80 |
| HTTPS Listener | TCP 443 |
| HTTP Listener | TCP 80 |
| Certificate Service | AWS Certificate Manager |
| SSL Certificate | Self-signed, imported into ACM |
| Certificate Validity | 365 days |

## Implementation Steps

### 1. EC2 Instance Setup

- Launched an Ubuntu 24.04 EC2 instance.
- Configured a dedicated security group.
- Used EC2 user data to install and configure Nginx automatically.
- Deployed a static CloudDevOps landing page.

### 2. Application Load Balancer

- Created an internet-facing Application Load Balancer.
- Configured two public subnets across separate Availability Zones.
- Attached a dedicated ALB security group.
- Created a target group using HTTP on port 80.
- Registered the EC2 instance with the target group.

### 3. SSL/TLS Certificate Generation

Generated a 2048-bit RSA private key and a self-signed certificate using OpenSSL.

Configured the certificate's Common Name and Subject Alternative Name (SAN) to match the ALB DNS hostname.

### 4. AWS Certificate Manager

- Imported the certificate and private key into ACM.
- Verified the certificate status as `ISSUED`.
- Confirmed the certificate type as `IMPORTED`.

### 5. HTTPS Listener Configuration

Configured the ALB HTTPS listener:

- Protocol: HTTPS
- Port: 443
- SSL/TLS certificate: ACM imported certificate
- Default action: Forward traffic to the EC2 target group.

### 6. HTTP-to-HTTPS Redirection

Configured the HTTP listener:

- Protocol: HTTP
- Port: 80
- Default action: Redirect to HTTPS port 443.
- Redirect status code: HTTP 301.

### 7. Security Group Configuration

**ALB Security Group**
- Allow inbound HTTP traffic on port 80 from `0.0.0.0/0`.
- Allow inbound HTTPS traffic on port 443 from `0.0.0.0/0`.

**EC2 Security Group**
- Allow inbound HTTP traffic on port 80 only from the ALB security group.
- No public SSH access configured.

## Validation and Testing

| Test | Expected Result | Result |
|---|---|---|
| EC2 instance status | Running | Passed |
| ALB status | Active | Passed |
| Target group health | Healthy | Passed |
| ACM certificate | ISSUED | Passed |
| HTTP request | 301 redirect | Passed |
| HTTPS website request | 200 OK | Passed |
| Website HTML response | Successfully returned | Passed |

### HTTP Redirect Test

```bash
curl -I http://YOUR-ALB-DNS-NAME
```

Observed response:

```text
HTTP/1.1 301 Moved Permanently
Location: https://YOUR-ALB-DNS-NAME:443/
```

### HTTPS Connection Test

```bash
curl -k -I https://YOUR-ALB-DNS-NAME
```

The `-k` option allows testing with a self-signed certificate without validating its trust chain.

### Website Content Test

```bash
curl -k https://YOUR-ALB-DNS-NAME
```

Verified that the CloudDevOps website HTML was successfully returned.

## Screenshots

The following screenshots demonstrate the implementation and validation.

| Screenshot | Description |
|---|---|
| `01-ec2-instance.png` | EC2 instance running |
| `02-application-load-balancer.png` | ALB configuration and availability zones |
| `03-target-group-healthy.png` | Healthy registered EC2 target |
| `04-acm-certificate.png` | Imported ACM certificate with ISSUED status |
| `05-alb-listeners.png` | HTTP redirect and HTTPS forwarding listeners |
| `06-https-website.png` | Live CloudDevOps website over HTTPS |
| `07-terminal-validation.png` | HTTP 301 and HTTPS 200 validation |

## Technologies Used

- Amazon Web Services (AWS)
- Amazon EC2
- Application Load Balancer (ALB)
- AWS Certificate Manager (ACM)
- Ubuntu 24.04 LTS
- Nginx
- OpenSSL
- AWS CLI
- HTTP/HTTPS
- SSL/TLS
- Linux Shell Scripting

## Key Learnings

- Deploying static websites on EC2 using Nginx.
- Configuring Application Load Balancers and target groups.
- Understanding HTTP and HTTPS listener configurations.
- Generating SSL/TLS certificates using OpenSSL.
- Importing certificates into AWS Certificate Manager.
- Configuring HTTP-to-HTTPS redirection.
- Implementing security group restrictions between ALB and EC2.
- Verifying target health and HTTPS connectivity.

## Important Security Note

This project uses a self-signed certificate imported into ACM because a custom domain was not available.

The certificate enables encrypted HTTPS communication, but it is not publicly trusted by browsers. A browser security warning is therefore expected.

For production deployments, use a registered domain and an ACM-issued publicly trusted certificate.

## Cleanup

After completing validation and capturing screenshots, remove the project-specific AWS resources to avoid ongoing charges.

- Delete the Application Load Balancer.
- Delete the target group.
- Terminate the project EC2 instance.
- Delete the two project-specific security groups.
- Remove the imported ACM certificate.

**Do not delete shared VPCs, subnets, internet gateways, or resources belonging to other projects.**

## Conclusion

Successfully implemented HTTPS for an EC2-hosted website using an Application Load Balancer and AWS Certificate Manager.

Validated automatic HTTP-to-HTTPS redirection, certificate import, healthy target registration, and successful website delivery over an encrypted HTTPS connection.
