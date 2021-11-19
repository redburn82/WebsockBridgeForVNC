#!/bin/bash

pkg install -Y python2 python3 git
pip install -Y python-websockify
mkdir -p .termux/tasker/
cd .termux/tasker/
git clone https://github.com/novnc/noVNC.git

