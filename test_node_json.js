// Test Node.js JSON support
const obj = {
    name: "John Doe",
    age: 30,
    city: "New York"
};

console.log("JSON:", JSON.stringify(obj, null, 2));

// Parse from string
const jsonStr = '{"language": "Node.js", "version": "22.9.0"}';
const parsed = JSON.parse(jsonStr);

console.log("Language:", parsed.language);
console.log("Version:", parsed.version);

// Advanced JSON operations
const complex = {
    users: [
        { id: 1, name: "Alice", active: true },
        { id: 2, name: "Bob", active: false }
    ],
    metadata: {
        total: 2,
        timestamp: new Date().toISOString()
    }
};

console.log("Complex JSON:", JSON.stringify(complex, null, 2));