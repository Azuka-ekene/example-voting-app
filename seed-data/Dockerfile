FROM python:3.9-slim@sha256:2d97f6910b16bd338d3060f261f53f144965f755599aab1acda1e13cf1731b1b

RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2-utils && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd --system appgroup && \
    useradd --system --gid appgroup --create-home appuser

WORKDIR /seed

COPY --chown=appuser:appgroup . .

RUN python make-data.py && \
    chown -R appuser:appgroup /seed

USER appuser

CMD ["/seed/generate-votes.sh"]