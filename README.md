#  node.js RPM spec
* node.js rpm spec : https://github.com/jantman/nodejs-rpm-centos5
* node.js source   : http://nodejs.org/dist/

This repository is forked from [kazuhisya/nodejs-rpm](https://github.com/kazuhisya/nodejs-rpm). It builds three RPMs: nodejs, nodejs-binary (the tarball) and nodejs-debuginfo. These packages DO NOT abide by the Fedora/EPEL packaging guidelines at all. Most importantly, they do not use node-gyp to compile binaries of the node modules, and they package all modules (as well as npm) in the main nodejs package (no subpackages). As such, please be warned that you won't be able to "yum install" the same list of packages on CentOS 5 (using these packages) as on CentOS 6 (using [EPEL](http://fedoraproject.org/wiki/EPEL)). This package essentially just uses the nodejs Makefile to build a binary tarball, and then packages the contents of that. You've been warned.

The spec file defines the package name as cmgd_nodejs (I work for [CMG Digital](https://github.com/coxmediagroup)) so it's abundantly clear that this is a very different package from anything you'll get from official repos such as EPEL. If you don't like the "cmgd_" prefix, you can change it on the `%define   _name_prefix` line at the top of the specfile.

The reason for all this is that the Fedora/EPEL packages include node-gyp (a tool to compile native addons/modules) and also use that to compile all packages addons/modules. Node-gyp requires v8, which in turn requires enough dependencies (c-ares, etc.) that are new enough to eventually require a glibc too new for CentOS 5. So, we just don't do any of this...

## Building the RPM

I'm not going to provide step-by-step instructions, as they differ quite between different environments (i.e. I don't use rpmbuild directly, I build everything through [mock](http://fedoraproject.org/wiki/Projects/Mock) in an environment as close to Fedora/EPEL as possible).

* Clone this repository
* There's one patch in this repo that you need
* make sure you meet all of the BuildRequires from the spec file
* get the source for the correct version from [http://nodejs.org/dist/](http://nodejs.org/dist/)
