# Use a Ubuntu-based base image
FROM ubuntu:22.04

# Install required dependencies
RUN apt-get update && apt-get install -y \
    powershell \
    unzip \
    wget

# Copy the .env file into the container
COPY .env .

# Set the NGROK_AUTH_TOKEN environment variable from the .env file
RUN $NGROK_AUTH_TOKEN=$(cat .env | grep -oP 'NGROK_AUTH_TOKEN=\K.*') && \
    echo "NGROK_AUTH_TOKEN=$NGROK_AUTH_TOKEN" >> /etc/environment

# Download and extract the Ngrok binary
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip ngrok-v3-stable-linux-amd64.zip

# Enable Remote Desktop
RUN powershell -Command " \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0; \
    Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'; \
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'UserAuthentication' -Value 1; \
    Set-LocalUser -Name 'runneradmin' -Password (ConvertTo-SecureString -AsPlainText 'P@ssw0rd!' -Force); \
"

# Create the Ngrok tunnel
CMD ["./ngrok", "tcp", "3389"]
