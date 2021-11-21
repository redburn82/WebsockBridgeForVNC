#!/bin/bash

pkg install -y python2 python3 git vim
pip install -y python-websockify
git clone https://github.com/novnc/noVNC.git
termux-fix-shebang ~/noVNC/utils/websockify/run
mkdir -p ~/.termux/tasker/
echo "bash noVNC/utils/novnc_proxy --vnc 127.0.0.1:5901" > run.sh

