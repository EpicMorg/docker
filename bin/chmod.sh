#!/bin/bash
cd ..
find . -name '*.sh' -type f | xargs chmod +x
find . -name '*.py' -type f | xargs chmod +x