cmake_minimum_required(VERSION 3.22)
project(trackmedoc CXX)

# Inclure le toolchain généré par Conan
include(${CMAKE_SOURCE_DIR}/conan_toolchain.cmake)

# Trouver les packages Conan via CMakeDeps
find_package(httplib REQUIRED)
find_package(spdlog REQUIRED)
find_package(fmt REQUIRED)

add_executable(trackmedoc src/main.cpp)

# Linker avec les targets trouvées par find_package
target_link_libraries(trackmedoc PRIVATE httplib::httplib spdlog::spdlog fmt::fmt)
