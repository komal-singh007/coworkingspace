# Use an official Python runtime as a parent image

FROM python:3.8-slim

# Set the working directory in the container to /app

WORKDIR /app

ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_HOST
ARG DB_PORT
ARG DB_NAME

ENV DB_USERNAME $DB_USERNAME
ENV DB_PASSWORD $DB_PASSWORD
ENV DB_HOST $DB_HOST
ENV DB_PORT $DB_PORT
ENV DB_NAME $DB_NAME

# Add the current directory contents into the container at /app
ADD . /app

RUN pip install -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Run app.py when the container launches
CMD ["python", "app.py"]
