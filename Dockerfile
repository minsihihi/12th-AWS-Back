FROM python:3.8.3-alpine
ENV PYTHONUNBUFFERED 1

RUN mkdir /app
WORKDIR /app

# 필요한 패키지 설치
RUN apk add --no-cache \
    mariadb-connector-c-dev \
    libpq \
    libffi-dev \    
    rust \
    cargo \
    jpeg-dev \
    zlib-dev

# psycopg2-binary와 mysqlclient 설치
RUN apk add --no-cache python3-dev build-base && \
    pip install mysqlclient==2.2.4 && \
    apk del python3-dev build-base

# requirements.txt 복사 후 설치
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# 소스 코드 복사
COPY . /app/

# 불필요한 패키지 제거
RUN apk del jpeg-dev zlib-dev
