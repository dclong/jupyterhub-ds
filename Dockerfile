FROM dclong/jupyterhub-beakerx:18.04

RUN apt-get update -y \
    && apt-get install -y \
        tmux proxychains \
        q-text-as-data \
        bash-completion man-db \
    && apt-get autoremove \
    && apt-get autoclean

# configure proxychains
COPY settings/proxychains.conf /etc/proxychains.conf

# install Teradata ODBC
COPY scripts/ /scripts/
RUN apt-get update -y \
    && apt-get install -y /scripts/tdodbc1620.deb \
    && rm -rf /scripts/tdodbc1620.deb \
    && apt-get autoremove \
    && apt-get autoclean 
RUN pip3 install teradata sqlalchemy-teradata
ENV ODBCHOME=/opt/teradata/client/ODBC_64 ODBCINI=/opt/teradata/client/ODBC_64/odbc.ini
RUN echo 'export ODBCHOME=/opt/teradata/client/ODBC_64' >> /etc/profile \
    && echo 'export ODBCINI=/opt/teradata/client/ODBC_64/odbc.ini' >> /etc/profile 

EXPOSE 5006
