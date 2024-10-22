# To-Do Application Documentation

This is a basic To-Do application that provides CRUD (Create, Read, Update, Delete) functionality.

## Local Deployment

### Prerequisites
- Docker Engine installed on your machine
- Docker Compose installed on your machine
- Git (for cloning the repository)

### Environment Setup

1. Create a `.env` file in the root directory with the following variables:
```
DB_PASSWORD=YOURPASSWORD    # MySQL database password
DB_NAME=YOURDBNAME         # Name of the database to be created
DB_USER=DBUSER            # Database user (typically 'root' for local development)
DB_HOST=DBHOST            # Use 'mysql' for local deployment
```

### Deployment Steps

1. **Build the Docker Image**
   ```bash
   # Navigate to the project directory containing the Dockerfile
   docker build -t todo_app .
   ```

2. **Start the Application**
   ```bash
   # Start both containers (MySQL and Todo App)
   docker compose up -d
   ```

3. **Verify Deployment**
   - The application will be available at `http://localhost:8080`
   - MySQL database will be accessible on port 3306

### Container Information
- **Todo App Container**
  - Container name: `todo_app`
  - Port: 8080
  - Depends on MySQL container being healthy

- **MySQL Container**
  - Container name: `mysql_db`
  - Port: 3306
  - Includes health check configuration
  - Persistent volume for data storage

### Stopping the Application
```bash
# Stop and remove containers
docker compose down
```

### Troubleshooting
- Ensure all environment variables in `.env` file are correctly set
- Check container logs using `docker logs todo_app` or `docker logs mysql_db`
- Verify MySQL container health status using `docker ps`
- Ensure ports 8080 and 3306 are not in use by other applications

## AWS Deployment
WIP!!!!!!! - WORKING ON CORS ISSUE

