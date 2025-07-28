FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential cmake libmysqlcppconn-dev

WORKDIR /app
COPY . .

RUN cmake -DCMAKE_BUILD_TYPE=Release . && make
RUN conan profile detect  # (à faire une seule fois sur ta machine)
RUN conan install .. --build=missing -pr:b=default -pr:h=default

# 3. Génère les fichiers CMake (avec le bon générateur !)
RUN cmake .. -G "MinGW Makefiles"

# 4. Compile
RUN cmake --build .

EXPOSE 8080
CMD ["./molecule-api"]
