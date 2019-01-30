FROM python:2.7-slim
MAINTAINER Viktor Petrosiants "v.petrosiants@gmail.com"
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["hello_world.py"]
