FROM docker.io/library/python:3.14-alpine3.23

WORKDIR /app
COPY app.py .

ENV PORT=8080
EXPOSE 8080

CMD ["python", "app.py"]
