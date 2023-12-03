# FROM postgres:9.2.23
# @see https://hub.docker.com/_/postgres?tab=tags&page=1&name=9.2 Tags disponíveis
FROM postgres:13.11-bullseye
# @see https://hub.docker.com/_/postgres/tags?page=1&name=13
# @see https://hub.docker.com/_/postgres Documentação

LABEL maintainer="fernando.ribeiro357@gmail.com"

RUN localedef -i pt_BR -c -f UTF-8 -A /usr/share/locale/locale.alias pt_BR.UTF-8
ENV LANG pt_BR.utf8

# Ajuste de timezone para Sao_Paulo
# Utilizando timezone de Recife por conta do horário de verão da imagem postgres:9.2.23
RUN rm /etc/localtime \
    # && ln -s /usr/share/zoneinfo/America/Recife /etc/localtime
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Database Configuration
COPY postgres/postgres.conf /etc/postgresql

