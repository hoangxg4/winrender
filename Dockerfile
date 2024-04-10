# Use a Windows Server 2022 base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Copy the .env file into the container
COPY .env .

# Install required dependencies
RUN Invoke-WebRequest https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip -OutFile ngrok.zip
RUN Expand-Archive ngrok.zip

# Set the NGROK_AUTH_TOKEN environment variable from the .env file
RUN $env:NGROK_AUTH_TOKEN = Get-Content -Path .env -Name NGROK_AUTH_TOKEN

# Enable Remote Desktop
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
RUN Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1
RUN Set-LocalUser -Name "runneradmin" -Password (ConvertTo-SecureString -AsPlainText "P@ssw0rd!" -Force)

# Create the ngrok tunnel
CMD ["./ngrok/ngrok.exe", "tcp", "3389"]
