// TruckMedoc/src/main.cpp - Version simplifiée
#include <iostream>
#include <string>
#include <ctime>

// JSON et logging (packages système Ubuntu)
#include <nlohmann/json.hpp>
#include <spdlog/spdlog.h>
#include <fmt/format.h>

// httplib header-only
#include "httplib.h"

using json = nlohmann::json;

int main() {
    try {
        // Initialiser le logger
        spdlog::set_level(spdlog::level::info);
        spdlog::info("🚀 Démarrage de TruckMedoc API");
        
        // Créer le serveur HTTP
        httplib::Server server;
        
        // Middleware pour CORS (si frontend sur port différent)
        server.set_pre_routing_handler([](const httplib::Request&, httplib::Response& res) {
            res.set_header("Access-Control-Allow-Origin", "*");
            res.set_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE");
            res.set_header("Access-Control-Allow-Headers", "Content-Type");
            return httplib::Server::HandlerResponse::Unhandled;
        });
        
        // Route de health check
        server.Get("/health", [](const httplib::Request&, httplib::Response& res) {
            json response = {
                {"status", "healthy"},
                {"service", "TruckMedoc API"},
                {"version", "1.0.0"},
                {"timestamp", std::time(nullptr)}
            };
            
            res.set_content(response.dump(2), "application/json");
            spdlog::info("Health check OK");
        });
        
        // Route pour lister les molécules (données mock)
        server.Get("/api/molecules", [](const httplib::Request&, httplib::Response& res) {
            json molecules = json::array({
                {
                    {"id", 1}, 
                    {"name", "Aspirine"}, 
                    {"formula", "C9H8O4"},
                    {"weight", 180.16},
                    {"description", "Anti-inflammatoire non stéroïdien"}
                },
                {
                    {"id", 2}, 
                    {"name", "Paracétamol"}, 
                    {"formula", "C8H9NO2"},
                    {"weight", 151.16},
                    {"description", "Analgésique et antipyrétique"}
                },
                {
                    {"id", 3}, 
                    {"name", "Ibuprofène"}, 
                    {"formula", "C13H18O2"},
                    {"weight", 206.28},
                    {"description", "Anti-inflammatoire"}
                }
            });
            
            json response = {
                {"molecules", molecules},
                {"count", molecules.size()}
            };
            
            res.set_content(response.dump(2), "application/json");
            spdlog::info("Liste des molécules demandée");
        });
        
        // Route pour récupérer une molécule par ID
        server.Get(R"(/api/molecules/(\d+))", [](const httplib::Request& req, httplib::Response& res) {
            int id = std::stoi(req.matches[1]);
            
            // Données mock - en réalité tu ferais une requête DB
            std::map<int, json> molecules = {
                {1, {{"id", 1}, {"name", "Aspirine"}, {"formula", "C9H8O4"}}},
                {2, {{"id", 2}, {"name", "Paracétamol"}, {"formula", "C8H9NO2"}}},
                {3, {{"id", 3}, {"name", "Ibuprofène"}, {"formula", "C13H18O2"}}}
            };
            
            if (molecules.find(id) != molecules.end()) {
                res.set_content(molecules[id].dump(2), "application/json");
                spdlog::info("Molécule {} trouvée", id);
            } else {
                json error = {{"error", "Molécule non trouvée"}, {"id", id}};
                res.status = 404;
                res.set_content(error.dump(2), "application/json");
                spdlog::warn("Molécule {} non trouvée", id);
            }
        });
        
        // Route pour la page d'accueil
        server.Get("/", [](const httplib::Request&, httplib::Response& res) {
            std::string html = R"(
<!DOCTYPE html>
<html>
<head>
    <title>TruckMedoc API</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .endpoint { background: #f4f4f4; padding: 10px; margin: 10px 0; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>🚛 TruckMedoc API</h1>
    <p>API de gestion des données moléculaires</p>
    
    <h2>Endpoints disponibles:</h2>
    <div class="endpoint"><strong>GET /health</strong> - Status de l'API</div>
    <div class="endpoint"><strong>GET /api/molecules</strong> - Liste des molécules</div>
    <div class="endpoint"><strong>GET /api/molecules/{id}</strong> - Détails d'une molécule</div>
    
    <h2>Test rapide:</h2>
    <ul>
        <li><a href="/health">Health Check</a></li>
        <li><a href="/api/molecules">Toutes les molécules</a></li>
        <li><a href="/api/molecules/1">Molécule #1</a></li>
    </ul>
</body>
</html>
            )";
            res.set_content(html, "text/html");
        });
        
        // Configuration du serveur
        const std::string host = "0.0.0.0";
        const int port = 8080;
        
        // Message de démarrage
        std::cout << fmt::format("🌟 TruckMedoc API démarré!\n");
        std::cout << fmt::format("📡 URL: http://{}:{}\n", host, port);
        std::cout << fmt::format("🔍 Health: http://{}:{}/health\n", host, port);
        std::cout << fmt::format("📊 API: http://{}:{}/api/molecules\n", host, port);
        std::cout << "Appuyez sur Ctrl+C pour arrêter...\n\n";
        
        spdlog::info("Serveur HTTP démarré sur {}:{}", host, port);
        
        // Lancer le serveur (bloquant)
        if (!server.listen(host.c_str(), port)) {
            spdlog::error("Impossible de démarrer le serveur sur le port {}", port);
            return 1;
        }
        
    } catch (const std::exception& e) {
        spdlog::error("Erreur fatale: {}", e.what());
        return 1;
    }
    
    return 0;
}   