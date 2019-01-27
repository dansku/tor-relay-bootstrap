tor-relay-bootstrap
===================

tor-relay-bootstrap does this:

* Upgrades all the software on the system
* Adds the deb.torproject.org repository to apt, so Tor updates will come directly from the Tor Project
* Installs and configures Tor to be a relay (but still requires you to manually edit torrc to set Nickname, ContactInfo, etc. for this relay)
* Configures sane default firewall rules
* Installs ntp to ensure time is synced (tlsdate is no longer available in Debian stable)
* Helps harden the ssh server

To use it, set up a Debian server, SSH into it, switch to the root user, and:

```sh
apt-get install -y git
git clone https://github.com/coldhakca/tor-relay-bootstrap.git
cd tor-relay-bootstrap
./bootstrap.sh
```


