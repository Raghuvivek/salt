increase_volume:
  cmd.run:
    - name: amixer sset Master 100%+
    - runas: default

unmute:
  cmd.run:
    - name: amixer -D pulse set Master unmute
    - runas: default