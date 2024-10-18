FROM node:14-alpine
WORKDIR /app
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . .

# Expose the todo app port
EXPOSE 8080

# Launching application
CMD ["node", "server.js"]
