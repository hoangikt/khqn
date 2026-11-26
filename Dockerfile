# Builder Image
FROM cgr.dev/chainguard/python:latest-dev@sha256:fbcaaaf39fa2d0c8cb15e836bc57a6966103e0aaacc76b643e0d596729f1e9fb as builder

ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

RUN python -m venv /app/venv
COPY requirements.txt .
# use newest pip version to have less CVE
RUN python -m pip install --upgrade pip
# Install the dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt


# End container image
FROM cgr.dev/chainguard/python:latest@sha256:4ba1897d53045d3661b549ca66aa1888816d67c27632aca7913cd521d10589cc

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

COPY main.py .
COPY --from=builder /app/venv /venv

# Run the main script using Python
ENTRYPOINT ["python", "/app/main.py"]
