# Sử dụng image Ubuntu chính thức
FROM ubuntu:latest

# Thiết lập thông tin người duy trì
LABEL maintainer="your_email@example.com"

# Cập nhật và cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    net-tools \
    vim \
    curl \
    && apt-get clean

# Tạo thư mục cần thiết cho SSH
RUN mkdir /var/run/sshd

# Tạo một người dùng mới và đặt mật khẩu
RUN useradd -ms /bin/bash user && echo 'user:password' | chpasswd && adduser user sudo

# Cho phép đăng nhập bằng mật khẩu
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Mở cổng 22 cho SSH
EXPOSE 22

# Khởi động dịch vụ SSH
CMD ["/usr/sbin/sshd", "-D"]
