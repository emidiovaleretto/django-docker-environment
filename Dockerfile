FROM python:3.11.3-alpine3.18
LABEL mantainer="emidio.valereto@gmail.com"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Copy the root folders and scripts into the container
COPY ./root /root
COPY ./scripts /scripts

# Set the working directory in the container
WORKDIR /root

# Set Django port
EXPOSE 8000


RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /root/requirements.txt && \
    adduser --disabled-password --no-create-home duser && \
    mkdir -p /data/app/static && \
    mkdir -p /data/app/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/app/static && \
    chown -R duser:duser /data/app/media && \
    chmod -R 755 /data/app/static && \
    chmod -R 755 /data/app/media && \
    chmod -R +x /scripts

# Add scripts folder and venv/bin to the container PATH
ENV PATH="/scripts:/venv/bin:$PATH"

# Change to the non-root user
USER duser

# Run the commands.sh script
CMD ["commands.sh"]