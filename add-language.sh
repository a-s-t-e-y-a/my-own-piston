#!/bin/bash

# Quick script to add a new language in dev mode

LANGUAGE_NAME=$1
VERSION=$2

if [ -z "$LANGUAGE_NAME" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <language_name> <version>"
    echo "Example: $0 rust 1.70.0"
    exit 1
fi

echo "🚀 Adding $LANGUAGE_NAME $VERSION to Piston..."

# Create package directory
mkdir -p "packages/$LANGUAGE_NAME/$VERSION"

# Create basic metadata.json
cat > "packages/$LANGUAGE_NAME/$VERSION/metadata.json" << EOF
{
    "language": "$LANGUAGE_NAME",
    "version": "$VERSION",
    "aliases": []
}
EOF

# Create basic build.sh (customize this!)
cat > "packages/$LANGUAGE_NAME/$VERSION/build.sh" << 'EOF'
#!/usr/bin/env bash

# Put instructions to build your package in here
echo "Building $LANGUAGE_NAME $VERSION..."

# Example: Download and extract
# curl -L "https://example.com/download.tar.gz" -o archive.tar.gz
# tar xzf archive.tar.gz --strip-components=1
# rm archive.tar.gz

echo "Build complete!"
EOF

# Create environment script
cat > "packages/$LANGUAGE_NAME/$VERSION/environment" << 'EOF'
#!/usr/bin/env bash

export PATH=$PWD/bin:$PATH
EOF

# Create run script
cat > "packages/$LANGUAGE_NAME/$VERSION/run" << 'EOF'
#!/usr/bin/env bash

# Put instructions to run the runtime
exec "$@"
EOF

# Make scripts executable
chmod +x "packages/$LANGUAGE_NAME/$VERSION/"*

echo "✅ Package structure created!"
echo "📝 Next steps:"
echo "   1. Edit build.sh to download/install your language"
echo "   2. Customize environment and run scripts"
echo "   3. Test with: ./dev-setup.sh rebuild"
echo "   4. Verify at: http://localhost:2000/api/v2/runtimes"