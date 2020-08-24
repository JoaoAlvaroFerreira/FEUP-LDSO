import http from "http";
import dotenv from "dotenv";

import { app } from "./app";

// Load environment variables
dotenv.config();

// Create server
const server = http.createServer(app);

const hostname = process.env.HOST || "127.0.0.1";
const port = process.env.PORT || 3000;

// Start the server
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
