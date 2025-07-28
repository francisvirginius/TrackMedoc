#include <httplib.h>
#include <spdlog/spdlog.h>

int main() {
    httplib::Server svr;

    svr.Get("/api/ping", [](const httplib::Request&, httplib::Response& res) {
        res.set_content("pong", "text/plain");
        spdlog::info("Ping requested");
    });

    svr.listen("0.0.0.0", 8080);
}
