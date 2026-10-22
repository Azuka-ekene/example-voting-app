FROM python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea65f6ce AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --system --gid 10001 appgroup && \
    useradd --system --uid 10001 --gid appgroup --create-home appuser

WORKDIR /usr/local/app

COPY requirements.txt ./requirements.txt

RUN pip install --no-cache-dir -r requirements.txt && \
    chown -R appuser:appgroup /usr/local/app

FROM base AS dev

RUN pip install --no-cache-dir watchdog

ENV FLASK_ENV=development

USER 10001:10001

CMD ["python", "app.py"]

FROM base AS final

COPY --chown=appuser:appgroup . .

USER 10001:10001

EXPOSE 8080

CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8080", "--log-file", "-", "--access-logfile", "-", "--workers", "4", "--keep-alive", "0"]