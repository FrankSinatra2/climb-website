FROM mysql:8

ENV MYSQL_RANDOM_ROOT_PASSWORD 'yes'
ENV MYSQL_USER 'admin'
ENV MYSQL_PASSWORD 'hunter2'
ENV MYSQL_DATABASE 'ClimbingExploration'

COPY ./sql /docker-entrypoint-initdb.d