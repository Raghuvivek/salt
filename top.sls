base:
  'usecase:Xibo':
    - match: grain
    - common/xibo
  'lod-*':
    - lod/usecase
  'erf-*':
    - erf/usecase
  'luu-*':
    - luu/setup/post_init
