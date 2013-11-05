#  node.js RPM spec for RedHat EL5/Centos5
* node.js rpm spec : https://github.com/sfreire/nodejs-rpm-centos5
* forked from : https://github.com/jantman/nodejs-rpm-centos5
* node.js source   : http://nodejs.org/dist/

This repository is forked from [jantman/nodejs-rpm-centos5](https://github.com/jantman/nodejs-rpm-centos5) which is forked from [kazuhisya/nodejs-rpm](https://github.com/kazuhisya/nodejs-rpm).
Instead of building three RPMs (nodejs, nodejs-binary (the tarball) and nodejs-debuginfo), the idea was to follow the same packaging guidelines as the ones used in EPEL (for RHEL6).
This means that the following packages will be created:
 - nodejs, nodejs-npm, nodejs-docs, nodejs-devel
More, "nodejs" package provides the following dependencies (example):
- nodejs = 0.10.21-4.ptin.el5
- nodejs(abi) = 0.10
- nodejs(engine) = 0.10.21
- nodejs(v8-abi) = 3.14

NodeJS DO NOT require package dependencies such as v8, libuv, c-ares19 installed in order to run, since NodeJS is built statically along with them. This is different from the NodeJS avaliable in EPEL 6 repository.
NPM is provided in the main "nodejs" package, which also provides the dependency "nodejs-npm".
NPM depends on a set of NodeJS modules. 

## Building the RPM

In order to build this, a bash script (mock_build.sh) is given which tries to build everything through [mock](http://fedoraproject.org/wiki/Projects/Mock) in an environment as close to Fedora/EPEL as possible).
As said earlier, NodeJS is, in this case, built statically since the source .tgz provides all the required dependencies (e.g. v8, c-ares19, libuv).

Steps:
* customize your release name accordingly
* get the source for the correct version from [http://nodejs.org/dist/](http://nodejs.org/dist/) and put in the SOURCES directory used in rpmbuild
* There's one patch in this repo that you need to put in the SOURCES directory used in rpmbuild
* copy the .spec in the SPECS directory used in rpmbuild
* make sure you meet all of the BuildRequires from the spec file
