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

# Create necessary directories with correct permissions
# Install Python dependences
RUN python -m venv /venv && \
  /venv/bin/pip install --upgrade pip && \
  /venv/bin/pip install -r /root/requirements.txt && \
  mkdir -p /data/app/static && \
  mkdir -p /data/app/media && \
  chmod -R +x /scripts

# Add scripts folder and venv/bin to the container PATH
ENV PATH="/scripts:/venv/bin:$PATH"

# Run the commands.sh script
CMD ["commands.sh"]
