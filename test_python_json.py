import json
import orjson

def test_python_json():
    # Create a JSON object using built-in json
    obj = {
        "name": "John Doe",
        "age": 30,
        "city": "New York"
    }
    
    print("JSON (built-in):", json.dumps(obj, indent=2))
    
    # Parse from string
    json_str = '{"language": "Python", "version": "3.13.0"}'
    parsed = json.loads(json_str)
    
    print("Language:", parsed["language"])
    print("Version:", parsed["version"])
    
    # Test with orjson (faster)
    orjson_bytes = orjson.dumps(obj, option=orjson.OPT_INDENT_2)
    print("JSON (orjson):", orjson_bytes.decode())
    
    parsed_orjson = orjson.loads(json_str)
    print("Parsed with orjson:", parsed_orjson)

if __name__ == "__main__":
    test_python_json()