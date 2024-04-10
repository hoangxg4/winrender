# Use a Windows Server 2022 base image
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

# Install required dependencies
RUN powershell -Command "Invoke-WebRequest -Uri https://curl.se/windows/curl-7.84.0-win64.zip -OutFile curl.zip"
RUN powershell -Command "Expand-Archive -Path curl.zip -DestinationPath ."
RUN .\curl.exe -o ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip
RUN powershell -Command "Expand-Archive -Path ngrok.zip -DestinationPath ."

# Set the NGROK_AUTH_TOKEN environment variable
ENV NGROK_AUTH_TOKEN=1wOBiyieGdM0TEoffSyszMYCfnL_56xVrqJRj9sZj3Y7FxdpS

# Enable Remote Desktop
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
RUN Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
RUN Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1
RUN New-LocalUser -Name "runneradmin" -Password (ConvertTo-SecureString -AsPlainText "P@ssw0rd!" -Force)

# Create the ngrok tunnel
CMD ["./ngrok/ngrok.exe", "tcp", "3389"]
