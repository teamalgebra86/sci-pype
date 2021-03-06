#!/bin/bash

condapip=pip2

echo "Installing newest pip"
${condapip} install --upgrade pip
echo ""

echo "Listing current pips"
${condapip} list --format=columns
echo ""

echo "Installing pyxattr manually due to the -O2/-03 issue that is still in the 0.5.5 conda build: https://github.com/iustin/pyxattr/issues/13"
pushd /opt/python2
git clone https://github.com/iustin/pyxattr.git pyxattr
${condapip} install ./pyxattr
popd

echo "Installing Primary set of pips"
${condapip} install --upgrade -r /opt/python2/primary-requirements.txt
last_status="$?"
if [[ "${last_status}" != "0" ]]; then
    echo "Failed to install Primary Python 2 requirements"
    exit 1 
fi

echo "Installing Secondary set of pips"
${condapip} install --upgrade -r /opt/python2/secondary-requirements.txt
last_status="$?"
if [[ "${last_status}" != "0" ]]; then
    echo "Failed to install Secondary Python 2 requirements"
    exit 1 
fi

echo "Installing custom pips that are in development"
${condapip} install --upgrade git+https://github.com/pydata/pandas-datareader.git

echo "Listing updated version of installed pips:"
${condapip} list --format=columns
echo ""

exit 0
