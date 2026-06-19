cmake_minimum_required(VERSION 3.20)
project(TruckMedoc)

# Standard C++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Trouver les packages système
find_package(PkgConfig REQUIRED)
find_package(nlohmann_json REQUIRED)
find_package(spdlog REQUIRED)
find_package(fmt REQUIRED)

# MySQL (optionnel)
pkg_check_modules(MYSQLCPPCONN mysqlcppconn)

# Inclure le dossier include pour httplib.h
include_directories(include/)

# Sources de l'application
set(SOURCES
    src/main.cpp
    # Ajoute tes autres fichiers .cpp ici si ils existent
    # src/api_server.cpp
    # src/database.cpp
    # src/molecule_controller.cpp
)

# Créer l'exécutable
add_executable(truck_medoc_api ${SOURCES})

# Lier les bibliothèques système
target_link_libraries(truck_medoc_api 
    PRIVATE 
    nlohmann_json::nlohmann_json
    spdlog::spdlog
    fmt::fmt
    pthread  # Pour httplib
)

# Lier MySQL si disponible
if(MYSQLCPPCONN_FOUND)
    target_include_directories(truck_medoc_api PRIVATE ${MYSQLCPPCONN_INCLUDE_DIRS})
    target_link_libraries(truck_medoc_api PRIVATE ${MYSQLCPPCONN_LIBRARIES})
    target_compile_definitions(truck_medoc_api PRIVATE HAS_MYSQL=1)
endif()

# Options de compilation
target_compile_options(truck_medoc_api PRIVATE -Wall -Wextra -O2)