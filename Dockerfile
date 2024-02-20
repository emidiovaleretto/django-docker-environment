FROM python:3.11.3-alpine3.18
LABEL maintainer="emidio.valereto@gmail.com"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Copy the root folders and scripts into the container
COPY root /root
COPY scripts /scripts

# Set the working directory in the container
WORKDIR /root

# Set Django port
EXPOSE 8000

# Add a user without home directory
RUN adduser --disabled-password --no-create-home duser

# Create necessary directories with correct permissions
RUN mkdir -p /data/app/static /data/app/media /venv \
    && chown -R duser:duser /data/app/static /data/app/media /venv \
    && chmod -R 755 /data/app/static /data/app/media /venv

# Install Python dependencies
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /root/requirements.txt && \
    chown -R duser:duser /venv /root

# Add scripts folder and venv/bin to the container PATH
ENV PATH="/scripts:/venv/bin:$PATH"

# Copy the commands.sh script and set permissions
COPY scripts/commands.sh /scripts/commands.sh
RUN chmod +x /scripts/commands.sh

# Change to the non-root user
USER duser

# Run the commands.sh script
CMD ["/bin/sh", "/scripts/commands.sh"]
