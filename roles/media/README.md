# media role

Installs media playback, editing applications, and restricted codecs.

## What it does

- Installs media apps via apt: VLC, mpv, Audacity, GIMP, Inkscape, Kdenlive, Handbrake, ffmpeg
- Installs `ubuntu-restricted-extras` (codecs, fonts, Flash) — pre-accepts the MS core fonts EULA
- Installs OBS Studio from the official `ppa:obsproject/obs-studio` PPA (deb), removing any snap install
- Installs `v4l2loopback-dkms` and configures it to load at boot, so OBS shows the **Start Virtual Camera** button

## Idempotency

Uses `state: present`. Safe to re-run.
