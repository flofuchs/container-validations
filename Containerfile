FROM centos:7

# Install git and ansible
RUN yum install -y git ansible sudo
RUN yum clean all

COPY init.sh /init.sh
RUN chmod 0755 /init.sh

# Create sudoers file for stack user
COPY sudoers /etc/sudoers
RUN chmod 0400 /etc/sudoers

# Create stack user
RUN useradd -c "stack user" -m -s /bin/sh stack
USER stack
COPY inventory.yaml /home/stack/inventory.yaml
WORKDIR /home/stack
CMD ["/init.sh"]
