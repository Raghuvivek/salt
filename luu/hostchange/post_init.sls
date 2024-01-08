{%- if salt['file.file_exists' ]('C:\Wyse\WCM\host_change.txt') %}
delete_salt_flag:
  file.absent:
    - name: C:\Wyse\WCM\setup_device.txt


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



#Modify the Master Host:
modify_minion_config:
  file.replace:
    - name: C:\ProgramData\Salt Project\Salt\conf\minion
    - pattern: '^master:\s.*$'
    - repl: 'master: luu-lxwhsaltprd.corp.ad.zalando.net'
    - runas: Admin

#Delete the old Master key
delete_file:
  file.absent:
    - name: C:\ProgramData\Salt Project\Salt\conf\pki/minion/minion_master.pub


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
