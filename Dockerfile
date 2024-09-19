FROM python:3.8.3-alpine as builder

ENV PYTHONUNBUFFERED 1

# 앱 디렉토리 생성 및 작업 디렉토리 설정
WORKDIR /usr/src/app

# 필수 패키지 설치 (libffi, Rust, etc.)
RUN apk update && apk add --no-cache \
    python3-dev \
    build-base \
    libffi-dev \
    mariadb-dev \
    jpeg-dev \
    zlib-dev \
    cargo \
    gcc \
    musl-dev \
    linux-headers \
    libpq



# 의존성 설치
COPY requirements.txt /usr/src/app/requirements.txt
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r requirements.txt

# 나중에 더 이상 필요 없는 빌드 종속성 제거
RUN apk del python3-dev build-base linux-headers

# 앱 소스 복사
COPY . /usr/src/app
