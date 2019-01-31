### This is my environment.

#### Build

To build:

`. ./build.sh`

This will copy the aliases from components/ into ~/.bm_bash and source them individually in your ~/.bashrc.

An empty ~/.bash_profile and ~/.bashrc will be created if they are not present.

#### Auto Build

To enable auto build:

`. ./build.sh 1`

Every time .bashrc is run (rate limited to 1 minute), this repo will be asynchronously checked for updates and rebuild if there are any changes.

#### Run the test suite

To run the test suite

`./test.sh`
