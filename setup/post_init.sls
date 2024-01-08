{%- if salt['file.file_exists' ]('C:\Wyse\WCM\setup_device.txt') %}
delete_salt_flag:
  file.absent:
    - name: C:\Wyse\WCM\setup_device.txt

#Reset Admin Password
reset_password_Admin:
  cmd.run:
    - name: |
        net user Admin Tc$34

#Reset User Password
change_password:
  cmd.run:
    - name: powershell.exe net user User User

#Create NewFolder
create_directory:
  file.directory:
    - name: C:\configs

#Copy Image
copy_wallpaper_image:
  file.managed:
    - name: C:\configs\wallpaper_zal.jpg
    - source: salt://luu/setup/configs/wallpaper_zal.jpg

#Change Wallpaper
change_wallpaper:
  cmd.run:
    - name: reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\configs\wallpaper_zal.jpg" /f
    - shell: cmd
    - runas: User

#Update Wallpaper
update_wallpaper_settings:
  cmd.run:
    - name: rundll32.exe user32.dll, UpdatePerUserSystemParameters
    - runas: User

#Download Google Chrome
download_chrome_installer:
  cmd.run:
    - name: curl -o C:\configs\chrome_installer.exe https://dl.google.com/chrome/install/latest/chrome_installer.exe
    - shell: powershell

#Install Google Chrome
install_chrome:
  cmd.run:
    - name: Start-Process -Wait -FilePath C:\configs\chrome_installer.exe -ArgumentList "/silent /install"
    - shell: powershell
    - require:
      - cmd: download_chrome_installer

#Enable Auto Login
enable_auto_login:
  cmd.run:
    - name: |
        $UserName = "User"
        $Password = "User"

        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "1" -Type String

        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value $UserName -Type String

        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value $Password -Type String

        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonCount" -Value "1" -Type DWord
    - shell: powershell
    - runas: Admin

#Disable Sleep and Powersaving Mode
power_settings:
  cmd.run:
    - name: |
        POWERCFG -X  -monitor-timeout-ac 0
        POWERCFG -X  -standby-timeout-ac 0
        POWERCFG -X  -hibernate-timeout-ac 0
        POWERCFG -X  -monitor-timeout-dc 0
        POWERCFG -X  -standby-timeout-dc 0
        POWERCFG -X  -hibernate-timeout-dc 0

    - shell: powershell
    - runas: Admin


#Disable Firewall
disable_firewall:
  cmd.run:
    - name: netsh advfirewall set allprofiles state off
    - shell: cmd
    - runas: Admin

#Enable Filter
enable_filter:
  cmd.run:
    - name: uwfmgr filter enable
    - shell: powershell
    - runas: Admin

#Restart System
system_reboot:
  cmd.run:
    - name: shutdown /r /t 0

{%- endif %}
