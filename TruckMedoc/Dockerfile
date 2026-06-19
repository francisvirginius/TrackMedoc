# Dockerfile sans Conan - Plus simple et plus stable
FROM ubuntu:22.04

# Éviter les interactions
ENV DEBIAN_FRONTEND=noninteractive

# Installer toutes les dépendances via apt
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libmysqlcppconn-dev \
    nlohmann-json3-dev \
    libspdlog-dev \
    libfmt-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Répertoire de travail
WORKDIR /app

# Copier le code source
COPY . .

# Télécharger httplib.h si pas présent
RUN mkdir -p include && \
    if [ ! -f include/httplib.h ]; then \
        curl -L -o include/httplib.h https://raw.githubusercontent.com/yhirose/cpp-httplib/v0.14.3/httplib.h; \
    fi

# Créer et compiler
RUN mkdir -p build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc)

# Exposer le port
EXPOSE 8080

# Répertoire pour l'exécution
WORKDIR /app/build

# Commande de démarrage
CMD ["./truck_medoc_api"]   