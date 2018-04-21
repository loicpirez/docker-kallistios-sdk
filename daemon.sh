#!/usr/bin/env sh

docker run -d -p 3022:22 -h localhost --security-opt seccomp:unconfined --name dreamcast dreamcast
