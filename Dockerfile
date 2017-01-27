FROM swift:3.0

WORKDIR /code

COPY Package.swift /code/
RUN swift build -c release

# Assuming that tests change less than code, so put Tests before Sources copy
COPY ./Sources /code/Sources
RUN swift build -c release
EXPOSE 8000
CMD .build/release/App
