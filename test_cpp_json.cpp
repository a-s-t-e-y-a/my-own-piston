#include <nlohmann/json.hpp>
#include <iostream>

using json = nlohmann::json;

int main() {
    // Create a JSON object
    json obj;
    obj["name"] = "John Doe";
    obj["age"] = 30;
    obj["city"] = "New York";
    
    // Convert to string and print
    std::cout << "JSON: " << obj.dump(2) << std::endl;
    
    // Parse from string
    std::string json_str = R"({"language": "C++", "version": "14.2.0"})";
    json parsed = json::parse(json_str);
    
    std::cout << "Language: " << parsed["language"] << std::endl;
    std::cout << "Version: " << parsed["version"] << std::endl;
    
    return 0;
}