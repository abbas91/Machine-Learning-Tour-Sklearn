FROM ubuntu:14.04

MAINTAINER phonchi <steve2003121@gmail.com>

# Export env settings
ENV TERM=xterm
ENV LANG en_US.UTF-8

# Install required packages and remove the apt packages cache when done.
RUN apt-get update -y && apt-get install build-essential -y
ADD apt-packages.txt /tmp/apt-packages.txt
RUN xargs -a /tmp/apt-packages.txt apt-get install -y && rm -rf /var/lib/apt/lists/*

# Install required packages for python environment
RUN pip install virtualenv
RUN /usr/local/bin/virtualenv /opt/training --distribute

ADD /requirements/ /tmp/requirements
RUN /opt/training/bin/pip install -r /tmp/requirements/pre-requirements.txt
RUN /opt/training/bin/pip install -r /tmp/requirements/requirements.txt

# Create training account
RUN useradd --create-home --home-dir /home/training --shell /bin/bash training
RUN chown -R training /opt/training
RUN adduser training sudo

ADD run_ipython.sh /home/training
RUN chmod +x /home/training/run_ipython.sh
RUN chown training /home/training/run_ipython.sh

ADD .bashrc.template /home/training/.bashrc

EXPOSE 8888
RUN usermod -a -G sudo training
RUN echo "training ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER training
RUN mkdir -p /home/training/notebooks
ENV HOME=/home/training
ENV SHELL=/bin/bash
ENV USER=training
VOLUME /home/training/notebooks
WORKDIR /home/training/notebooks

# Run ipython as a service
CMD ["/home/training/run_ipython.sh"]