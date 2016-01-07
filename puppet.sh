#!/bin/bash

export PATH="/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
case "$1" in
  puppet)
    yum -y install epel-release.noarch
    yum -y install dkms
    # Update and set timezone
    yum -y update
    timedatectl set-timezone Europe/Moscow
    # Official repo for puppet 3.8
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm && yum -y install puppet-server

    # Add custom params to puppet master
cat << 'EOF' >> /etc/puppet/puppet.conf

[master]
    dns_alt_names = puppet
    always_cache_features = true
    environmentpath = $confdir/environments
EOF

    # Create production environment
    mkdir -p /etc/puppet/environments/production/{manifests,modules}

cat << 'EOF' > /etc/puppet/environments/production/manifests/site.pp
node 'agent' {
}
EOF

    # Disable firewalld
    puppet resource service firewalld ensure=stopped enable=false

    # Run puppet master
    puppet master

    # Change vagrant user password
    echo "vagrant:123" | chpasswd

    # Sign agent node
    sleep 120; puppet cert sign --all
  ;;

  agent)
    # Update and set timezone
    yum -y install epel-release.noarch
    yum -y install dkms
    yum -y update
    timedatectl set-timezone Europe/Moscow

    # Install agent
    rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm && yum -y install puppet

    # Set catalog refresh time
    echo "    runinterval = 30s" >> /etc/puppet/puppet.conf
    # Disable firewall, enable puppet agent and start it
    puppet resource service firewalld ensure=stopped enable=false
    puppet resource service puppet ensure=running enable=true
    # Change vagrant user password
    echo "vagrant:123" | chpasswd
  ;;

  *)
    echo "Run $0: with puppet or agent arg"
  ;;
esac
