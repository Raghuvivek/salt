disable_filter:
  cmd.run:
    - name: uwfmgr filter disable
    - shell: powershell
    - runas: Admin

create_salt_flag:
  file.managed:
    - name: C:\Wyse\WCM\setup_device.txt
    - contents: |
        Setup device flag
    - makedirs: True

system_reboot:
  cmd.run:
    - name: shutdown /r /t 0
