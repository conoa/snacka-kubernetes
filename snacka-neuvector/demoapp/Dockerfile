FROM python:3.13-alpine AS base

RUN apk update && apk upgrade

RUN mkdir /code
COPY ./requirements.txt /code/ 
WORKDIR /code
RUN pip install -r requirements.txt

COPY ./app.py /code/

CMD ["gunicorn", "app:app"]

ENV GUNICORN_CMD_ARGS "--bind=0.0.0.0:8000 --workers=1 --thread=2 --worker-class=gthread --forwarded-allow-ips='*' --access-logfile -"

EXPOSE 8000

USER 10000
