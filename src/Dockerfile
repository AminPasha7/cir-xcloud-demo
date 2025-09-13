FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ENV PYTHONPATH=/app
COPY . /app
EXPOSE 8080
CMD ["uvicorn","translator.server:app","--host","0.0.0.0","--port","8080"]
