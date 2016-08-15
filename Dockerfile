# =============================================================================
# 
# CentOS-6 6.8 x86_64 - SCL/EPEL/IUS Repos. / Supervisor / OpenSSH.
# 
# =============================================================================
FROM centos:centos6.8

MAINTAINER John Headley <keoni84@gmail.com>

# -----------------------------------------------------------------------------
# Import the RPM GPG keys for Centos Mirrors
# -----------------------------------------------------------------------------
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-6

# -----------------------------------------------------------------------------
# Base Install
# -----------------------------------------------------------------------------
RUN rpm --rebuilddb \
	&& yum -y install \
	vim-enhanced \
	sudo \
	openssh \
	openssh-server \
	openssh-clients \
	&& rm -rf /var/cache/yum/* \
	&& rpm --erase --nodeps redhat-logos \
	&& rpm --rebuilddb \
	&& yum clean all

# -----------------------------------------------------------------------------
# Import epel Repository
# -----------------------------------------------------------------------------
RUN wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	&& rpm -ivh epel-release-6-8.noarch.rpm \
	&& rm -rf epel-release-6-8.noarch.rpm

# -----------------------------------------------------------------------------
# Base Install
# -----------------------------------------------------------------------------
RUN rpm --rebuilddb \
	&& yum -y install sshpass \
	&& yum -y erase epel-release-6-8 \
	&& rm -rf /var/cache/yum/* \
	&& rpm --rebuilddb \
	&& yum clean all

# -----------------------------------------------------------------------------
# Set timezone to UTC
# -----------------------------------------------------------------------------
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# -----------------------------------------------------------------------------
# Configure SSH UseDNS
# -----------------------------------------------------------------------------
RUN sed -i \
	-e 's~^#UseDNS yes~UseDNS no~g' \
	/etc/ssh/sshd_config

# -----------------------------------------------------------------------------
# Expose port 22
# -----------------------------------------------------------------------------
EXPOSE 22

# -----------------------------------------------------------------------------
# Command to init
# -----------------------------------------------------------------------------
CMD ["/sbin/init"]
