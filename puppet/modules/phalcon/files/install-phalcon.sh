#! /bin/bash

cd /tmp

git clone git://github.com/phalcon/cphalcon.git
cd cphalcon/build
sudo ./install

cd

git clone git://github.com/phalcon/phalcon-devtools.git
cd phalcon-devtools
sudo ./phalcon.sh

