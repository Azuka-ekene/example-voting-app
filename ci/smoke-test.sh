#!/usr/bin/env bash
# End-to-end smoke test.
# Casts one vote and proves it travels vote -> Redis -> worker -> PostgreSQL,
# and that the result page is up. Run from the repository root, after
# `docker compose -f ci/docker-compose.ci.yml up -d --build --wait`.
set -euo pipefail

COMPOSE="docker compose -f ci/docker-compose.ci.yml"
VOTE_URL="http://localhost:8080"
RESULT_URL="http://localhost:8081"

wait_for_page() {
  local name="$1" url="$2"
  echo "Waiting for the ${name} page at ${url} ..."
  for _ in $(seq 1 30); do
    if curl -fsS -o /dev/null "${url}/"; then
      echo "  ${name} page is up."
      return 0
    fi
    sleep 2
  done
  echo "FAIL: the ${name} page never came up." >&2
  return 1
}

wait_for_page "vote" "${VOTE_URL}"
wait_for_page "result" "${RESULT_URL}"

echo "Casting a vote for option a ..."
curl -fsS -o /dev/null -X POST -d "vote=a" "${VOTE_URL}/"

echo "Waiting for the vote to reach the database ..."
for _ in $(seq 1 30); do
  count="$(${COMPOSE} exec -T db psql -U postgres -d postgres -tAc "SELECT COUNT(*) FROM votes WHERE vote = 'a'" 2>/dev/null | tr -d '[:space:]' || true)"
  if [ "${count:-0}" -ge 1 ] 2>/dev/null; then
    echo "PASS: the vote was counted (${count} row in the votes table)."
    exit 0
  fi
  sleep 2
done

echo "FAIL: the vote never reached the database." >&2
exit 1