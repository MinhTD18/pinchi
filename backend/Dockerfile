FROM python:3.11.7-alpine3.18

RUN mkdir -p /app/scripts

# python envs
ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

# python dependencies
COPY ./requirements.txt .
RUN pip install -r ./requirements.txt

# upload scripts
COPY ./scripts/entrypoint.sh /app/scripts/entrypoint.sh
COPY ./scripts/start.sh /app/scripts/start.sh
COPY ./scripts/gunicorn.sh /app/scripts/gunicorn.sh

# Fix windows docker bug, convert CRLF to LF
# RUN sed -i 's/\r$//g' /app/start.sh && chmod +x /app/start.sh && sed -i 's/\r$//g' /app/entrypoint.sh && chmod +x /app/entrypoint.sh &&\
#     sed -i 's/\r$//g' /app/gunicorn.sh && chmod +x /app/gunicorn.sh
RUN chmod +x /app/scripts/entrypoint.sh
RUN chmod +x /app/scripts/start.sh
RUN chmod +x /app/scripts/gunicorn.sh

WORKDIR /app

