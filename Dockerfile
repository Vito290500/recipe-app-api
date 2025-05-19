# syntax=docker/dockerfile:1
FROM python:3.9-alpine
LABEL maintainer="Vito"

ENV PYTHONUNBUFFERED=1

# 1) Copia i requirements
COPY requirements.txt requirements.dev.txt /tmp/

# 2) Installa la parte "prod"
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# 3) ARG per il dev build
ARG DEV=false
RUN if [ "$DEV" = "true" ] ; then \
      pip install --no-cache-dir -r /tmp/requirements.dev.txt ; \
    fi

# 4) Prepara la cartella /app
RUN mkdir -p /app
WORKDIR /app

# 5) (Per ora non copiamo il progetto, lo genereremo in runtime/volumes)
#    COPY ./app /app

EXPOSE 8000

# 6) Comando di default
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
