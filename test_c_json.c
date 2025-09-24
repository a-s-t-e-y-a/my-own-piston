#include <cjson/cJSON.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Create a JSON object
    cJSON *json = cJSON_CreateObject();
    cJSON *name = cJSON_CreateString("John Doe");
    cJSON *age = cJSON_CreateNumber(30);
    cJSON *city = cJSON_CreateString("New York");
    
    cJSON_AddItemToObject(json, "name", name);
    cJSON_AddItemToObject(json, "age", age);
    cJSON_AddItemToObject(json, "city", city);
    
    // Convert to string and print
    char *json_string = cJSON_Print(json);
    printf("JSON: %s\n", json_string);
    
    // Parse from string
    const char *json_str = "{\"language\": \"C\", \"version\": \"14.2.0\"}";
    cJSON *parsed = cJSON_Parse(json_str);
    
    cJSON *language = cJSON_GetObjectItem(parsed, "language");
    cJSON *version = cJSON_GetObjectItem(parsed, "version");
    
    printf("Language: %s\n", cJSON_GetStringValue(language));
    printf("Version: %s\n", cJSON_GetStringValue(version));
    
    // Clean up
    cJSON_Delete(json);
    cJSON_Delete(parsed);
    free(json_string);
    
    return 0;
}