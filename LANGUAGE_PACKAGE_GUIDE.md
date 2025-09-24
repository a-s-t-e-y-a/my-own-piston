# Piston Language Package Development Guide

## Prerequisites
- Docker and docker-compose installed
- Understanding of the target language's build process

## Step-by-Step Process to Add Language Packages

### 1. Start Development Environment
```bash
# Navigate to your piston directory
cd /home/krisna/my-own-piston

# Start the development containers
docker-compose -f docker-compose.dev.yaml up -d
```

### 2. Create Package Structure
```bash
# Create the package directory structure
mkdir -p packages/{language_name}/{version}/

# Example for adding Go 1.23.1:
mkdir -p packages/go/1.23.1/
```

### 3. Required Files for Each Package

#### a. `metadata.json` (Required)
```json
{
    "language": "go",
    "version": "1.23.1",
    "aliases": ["golang"]
}
```

#### b. `build.sh` (Required)
```bash
#!/usr/bin/env bash

# Download and extract the language runtime/compiler
curl -L "https://go.dev/dl/go1.23.1.linux-amd64.tar.gz" -o go.tar.gz
tar xzf go.tar.gz --strip-components=1
rm go.tar.gz
```

#### c. `environment` (Required)
```bash
#!/usr/bin/env bash

# Set up environment variables and PATH
export PATH=$PWD/bin:$PATH
export GOROOT=$PWD
export GOPATH=/tmp/go
```

#### d. `run` (Required)
```bash
#!/usr/bin/env bash

# Execute the code
go run "$@"
```

#### e. `compile` (Optional - for compiled languages)
```bash
#!/usr/bin/env bash

# Compile the source code
go build -o compiled_program "$@"
```

### 4. Language-Specific Considerations

#### For Interpreted Languages (Python, JavaScript, Ruby):
- Only need `run` script
- No `compile` script required

#### For Compiled Languages (C++, Java, Go, Rust):
- Need both `compile` and `run` scripts
- `compile` should produce executable
- `run` should execute the compiled binary

#### For Languages with Package Managers:
- Install common packages in `build.sh`
- Set up package manager paths in `environment`

### 5. JSON Support Integration

#### For C/C++:
```bash
# In compile script
gcc -std=c17 -I/opt/json/includes -I/usr/include/cjson *.c -lm -lcjson
g++ -std=c++20 -I/opt/json/includes -I/usr/include/nlohmann *.cpp
```

#### For Java:
```bash
# In compile script
javac -cp "/usr/share/java/*:." *.java

# In run script  
java -cp "/usr/share/java/*:." MainClass
```

#### For Languages with Built-in JSON:
- Python: `import json`
- JavaScript: `JSON.parse()`, `JSON.stringify()`
- Go: `import "encoding/json"`

### 6. Testing Your Package

#### a. Build the Package
```bash
# Access the API container
docker exec -it piston_api bash

# Navigate to packages and build
cd /piston/packages/{language}/{version}/
./build.sh
```

#### b. Test Compilation (if applicable)
```bash
# Test compile script
echo 'your test code' > test_file
./compile test_file
```

#### c. Test Execution
```bash
# Test run script
echo 'your test code' > test_file
./run test_file
```

### 7. Package Configuration Examples

#### Simple Interpreted Language (Python):
```
packages/python/3.13.0/
├── metadata.json
├── build.sh
├── environment  
└── run
```

#### Compiled Language with JSON (C++):
```
packages/gcc/14.2.0/
├── metadata.json
├── build.sh
├── environment
├── compile
└── run
```

### 8. Advanced Package Features

#### Multiple Language Support (like GCC):
```json
{
    "language": "gcc",
    "version": "14.2.0",
    "provides": [
        {
            "language": "c",
            "aliases": ["gcc"]
        },
        {
            "language": "c++", 
            "aliases": ["cpp", "g++"]
        }
    ]
}
```

#### Package Dependencies:
```bash
# In build.sh - install dependencies
apt-get update && apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
```

### 9. Common Patterns

#### Download and Extract Archive:
```bash
curl -L "{download_url}" -o archive.tar.gz
tar xzf archive.tar.gz --strip-components=1
rm archive.tar.gz
```

#### Build from Source:
```bash
./configure --prefix="$PWD"
make -j$(nproc)
make install
```

#### Binary Distribution:
```bash
curl -L "{binary_url}" -o binary
chmod +x binary
mv binary bin/
```

### 10. Debugging and Validation

#### Check Container Logs:
```bash
docker-compose -f docker-compose.dev.yaml logs api
```

#### Interactive Testing:
```bash
# Enter container for debugging
docker exec -it piston_api bash
```

#### Test with API:
```bash
curl -X POST http://localhost:2000/api/v2/execute \
  -H "Content-Type: application/json" \
  -d '{
    "language": "your_language",
    "version": "your_version", 
    "files": [{"content": "your test code"}]
  }'
```

### 11. Production Deployment

#### Rebuild Container:
```bash
docker-compose -f docker-compose.dev.yaml down
docker-compose -f docker-compose.dev.yaml build --no-cache
docker-compose -f docker-compose.dev.yaml up -d
```

#### Update Package Index:
```bash
# The repo container will automatically index new packages
# Verify at http://localhost:8000/index
```

## Updated Language Versions Summary

| Language | Old Version | New Version | JSON Support |
|----------|-------------|-------------|--------------|
| Node.js  | 20.11.1     | 22.9.0     | Built-in     |
| Java     | 15.0.2      | 21.0.4     | json-simple  |  
| Python   | 3.12.0      | 3.13.0     | Built-in     |
| C        | GCC 10.2.0  | GCC 14.2.0 | cJSON        |
| C++      | GCC 10.2.0  | GCC 14.2.0 | nlohmann     |

## JSON Libraries Available

- **C**: cJSON library (`#include <cjson/cJSON.h>`)
- **C++**: nlohmann/json (`#include <nlohmann/json.hpp>`)  
- **Java**: json-simple (classpath pre-configured)
- **Python**: Built-in `json` module + `orjson`, `json5`
- **JavaScript**: Built-in `JSON` object

## Tips for Success

1. **Always test locally first** using the dev environment
2. **Check existing packages** for reference implementations
3. **Use appropriate compiler flags** and optimization levels
4. **Handle file extensions** properly in scripts
5. **Set correct permissions** on all scripts (`chmod +x`)
6. **Include common libraries** that users might expect
7. **Test with actual JSON operations** to verify functionality