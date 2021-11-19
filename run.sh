#!/bin/bash

pkg install python2 python3 git -y
pip install python-websockify
mkdir -p .termux/tasker/
cd .termux/tasker/
git clone https://github.com/novnc/noVNC.git

