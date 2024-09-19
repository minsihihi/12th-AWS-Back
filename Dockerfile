FROM python:3.8.3-alpine
ENV PYTHONUNBUFFERED 1

# 앱 디렉토리 생성 및 작업 디렉토리 설정
RUN mkdir /app
WORKDIR /app

# psycopg2-binary 및 mysqlclient 의존성 설치
RUN apk add --no-cache mariadb-connector-c-dev
RUN apk update && apk add python3 python3-dev mariadb-dev build-base && pip3 install mysqlclient==2.2.4 && apk del python3-dev mariadb-dev build-base

# Rust 컴파일러 설치 (maturin 빌드를 위해 필요)
RUN apk add --no-cache cargo

# libffi 및 추가 의존성 설치
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache jpeg-dev zlib-dev mariadb-dev libffi-dev libpq

# requirements.txt 파일 복사 및 패키지 설치
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# 더 이상 필요 없는 패키지 제거
RUN apk del jpeg-dev zlib-dev

# 앱 코드 복사
COPY . /app/
