########################################################################
# Dockerfile to build KallistiOS Toolchain + Additional Dreamcast Tools
########################################################################
FROM nold360/kallistios-sdk:minimal

# Additinal DC Tools:
#  - mksdiso Toolkit
#  - cdi4dc & mds4cd (iso converter)
#
RUN git clone --depth=1 https://github.com/Nold360/mksdiso /opt/mksdiso && \
	cd /opt/mksdiso/ && cp -r mksdiso /root/.mksdiso && \
	cp bin/burncdi bin/mksdiso /usr/local/bin/ && \
	cd src && make all && make install && cp binhack/bin/binhack32 /usr/local/bin/

RUN git clone --depth=1 https://github.com/kazade/img4dc /opt/img4dc && \
	mkdir /opt/img4dc/build && cd /opt/img4dc/build && cmake .. && make && \
	mv mds4dc/mds4dc cdi4dc/cdi4dc /usr/local/bin/

RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY id_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
