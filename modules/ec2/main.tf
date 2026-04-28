# Proxy EC2 Instances
resource "aws_instance" "proxy" {
  count                  = length(var.public_subnet_ids)
  ami                    = var.proxy_ami
  instance_type          = var.proxy_instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [var.proxy_security_group_id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd mod_proxy_html -y
    systemctl start httpd
    systemctl enable httpd

    echo "LoadModule proxy_module modules/mod_proxy.so" >> /etc/httpd/conf.modules.d/00-proxy.conf
    echo "LoadModule proxy_http_module modules/mod_proxy_http.so" >> /etc/httpd/conf.modules.d/00-proxy.conf

    cat <<EOP > /etc/httpd/conf.d/reverse-proxy.conf
    <VirtualHost *:80>
      ServerAdmin webmaster@localhost
      DocumentRoot /var/www/html

      ProxyPreserveHost On
      ProxyPass / http://BACKEND_IP:80/
      ProxyPassReverse / http://BACKEND_IP:80/

      ErrorLog /var/log/httpd/error.log
      CustomLog /var/log/httpd/access.log combined
    </VirtualHost>
    EOP

    systemctl restart httpd
  EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-proxy-${count.index + 1}"
    }
  )
}

# Backend EC2 Instances
resource "aws_instance" "backend" {
  count                  = length(var.private_subnet_ids)
  ami                    = var.backend_ami
  instance_type          = var.backend_instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.backend_security_group_id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd -y
    systemctl start httpd
    systemctl enable httpd

    cat <<EOT > /var/www/html/index.html
    <!DOCTYPE html>
    <html lang="ar">
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>pro Backend</title>
    <style>
        body {
            margin: 0;
            font-family: Tahoma, sans-serif;
            line-height: 1.6;
            color: #333;
        }
        header {
            background-color:rgb(76, 175, 168);
            color: white;
            padding: 20px;
            text-align: center;
        }
        nav {
            background: #333;
            color: #fff;
            padding: 10px;
            text-align: center;
        }
        nav a {
            color: #fff;
            margin: 0 15px;
            text-decoration: none;
            font-weight: bold;
        }
        section {
            padding: 20px;
        }
        .intro {
            background: #f2f2f2;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .image-large {
            text-align: center;
            margin: 20px 0;
        }
        .image-large img {
            max-width: 90%;
            height: auto;
            border-radius: 8px;
        }
        footer {
            background: #555;
            color: #fff;
            text-align: center;
            padding: 10px;
            position: fixed;
            width: 100%;
            bottom: 0;
        }
    </style>
    </head>
    <body>
    <header>
        <h1>Welcome To MY NTI Profile </h1>
        <h2>Mohamed Magdy</h2>
    </header>
    <nav>
        <a href="#home">linked in</a>
        <a href="#about">GitHup</a>
        <a href="#contact">call me</a>
    </nav>
    <section class="intro" id="home">
        <h2>About Me</h2>
        <p>Passionate and dedicated DevOps Engineer with extensive experience in designing, implementing, and managing end-to-end DevOps processes. Proficient in a wide array of tools and technologies, including Docker, Kubernetes, Jenkins, Ansible, Terraform, and cloud platforms such as AWS and Azure
          With a solid background in system administration and automation, I excel in creating efficient CI/CD pipelines, optimizing deployment processes, and ensuring system reliability. I am committed to fostering collaboration between development and operations teams to achieve seamless and scalable software delivery.</p>
    </section>
     <section class="image-large">
        <h3> My Ambition </h3>
        <img src="https://th.bing.com/th/id/OIP.hQBljChXG8wLIZFdBlstGQHaEj?w=650&h=400&rs=1&pid=ImgDetMain" alt="الصورة الرئيسية">
    </section>
    <footer>
        Don't Be Shy To Ask Me Anything
    </footer>
    </body>
    </html>
    EOT

    systemctl restart httpd
  EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-backend-${count.index + 1}"
    }
  )
}

# Null resource to configure reverse proxy after provisioning
resource "null_resource" "configure_proxy" {
  count = length(aws_instance.proxy)

  triggers = {
    proxy_instance_id   = aws_instance.proxy[count.index].id
    backend_instance_id = aws_instance.backend[count.index % length(aws_instance.backend)].id
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = aws_instance.proxy[count.index].public_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Wait for config file to exist
      "for i in {1..10}; do [ -f /etc/httpd/conf.d/reverse-proxy.conf ] && break || sleep 5; done",
      # Replace BACKEND_IP placeholder
      "sudo sed -i 's|BACKEND_IP|${aws_instance.backend[count.index % length(aws_instance.backend)].private_ip}|' /etc/httpd/conf.d/reverse-proxy.conf",
      # Restart Apache
      "sudo systemctl restart httpd"
    ]
  }

  depends_on = [
    aws_instance.proxy,
    aws_instance.backend
  ]
}

