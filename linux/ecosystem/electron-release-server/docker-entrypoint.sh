#!/bin/bash

echo "============================================="
echo node $(node --version)
echo npm $(npm --version)
echo yarn $(yarn --version)
echo "============================================="
echo "[nodejs] Electron Release Server is Starting up"
echo "============================================="

npm start
