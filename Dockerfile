FROM swift:3.0

WORKDIR /code

COPY Package.swift /code/

COPY ./Sources /code/Sources
RUN swift build -c release
EXPOSE 8000
CMD .build/release/App
