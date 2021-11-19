#!/bin/bash

pkg install -y python2 python3 git
pip install -y python-websockify
mkdir -p .termux/tasker/
cd .termux/tasker/
git clone https://github.com/novnc/noVNC.git

