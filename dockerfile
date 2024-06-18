# Verwende das offizielle Debian-Image als Basis
FROM debian:latest

# Installiere SSH und sudo
RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd

# Erstelle den Benutzer testuser mit dem Passwort password
RUN useradd -m -s /bin/bash testuser && \
    echo 'testuser:password' | chpasswd && \
    adduser testuser sudo

# Konfiguriere SSH, um den Root-Login zu erlauben und Password-Authentication zu ermöglichen
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Erlaube dem Benutzer, SSH mit sudo ohne Passwort zu verwenden (optional)
RUN echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Setze das Passwort von root auf 'password' (optional)
RUN echo 'root:password' | chpasswd

# Exponiere den SSH-Port
EXPOSE 22

# Startskript für den SSH-Dienst
CMD ["/usr/sbin/sshd", "-D"]
