FROM alpine:3.12

# Install Python
ENV PYTHONUNBUFFERED=1
RUN apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi &&

# Install pip
RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

# Install dependincies
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev

# Application environments
ENV MYSQL_USERNAME=${MYSQL_USERNAME} \
    MYSQL_PASSWORD=${MYSQL_PASSWORD} \
    MYSQL_INSTANCE_NAME=${MYSQL_INSTANCE_NAME} \
    MYSQL_PORT_3306_TCP_ADDR=${MYSQL_PORT_3306_TCP_ADDR} \
    MYSQL_PORT_3306_TCP_PORT=${MYSQL_PORT_3306_TCP_PORT}

WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 3000
CMD python ./app.py