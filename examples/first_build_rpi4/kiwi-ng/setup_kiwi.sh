#!/bin/bash

if [ ! -d "venv" ] 
then
    python3 -m venv venv
    source ./venv/bin/activate
    pip install kiwi
    pip install kiwi-boxed-plugin
fi

source ./venv/bin/activate
export PATH=${PWD}\venv\bin:$PATH

kiwi-ng --version
