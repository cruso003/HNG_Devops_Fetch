# devopsfetch

`devopsfetch` is a Bash tool designed for DevOps to collect and display system information. It can provide details on active ports, user logins, Nginx configurations, Docker images, and container statuses. Additionally, `devopsfetch` includes a systemd service for continuous monitoring and logging.

## Features

1. **Ports**
   - Display all active ports and services.
   - Provide detailed information about a specific port.

2. **Docker**
   - List all Docker images and containers.
   - Provide detailed information about a specific container.

3. **Nginx**
   - Display all Nginx domains and their ports.
   - Provide detailed configuration information for a specific domain.

4. **Users**
   - List all users and their last login times.
   - Provide detailed information about a specific user.

5. **Time Range**
   - Display activities within a specified time range (feature not yet implemented).

## Output Formatting

All outputs are formatted for readability in well-formatted tables with descriptive column names.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/cruso003/HNG_Devops_Fetch.git
   cd devopsfetch
   ```

2. **Run the installation script:**

   ```bash
   sudo ./install_devopsfetch.sh
   ```

   The script will install necessary dependencies and set up a systemd service to monitor and log activities.

## Usage

Run `./devopsfetch.sh` with the appropriate options:

- **Display active ports and services:**

  ```bash
  ./devopsfetch.sh -p
  ```

- **Provide detailed information about a specific port:**

  ```bash
  ./devopsfetch.sh -p 80
  ```

- **List Docker images and containers:**

  ```bash
  ./devopsfetch.sh -d
  ```

- **Provide detailed information about a specific container:**

  ```bash
  ./devopsfetch.sh -d container_name
  ```

- **Display Nginx domains and their ports:**

  ```bash
  ./devopsfetch.sh -n
  ```

- **Provide detailed configuration information for a specific domain:**

  ```bash
  ./devopsfetch.sh -n example.com
  ```

- **List users and their last login times:**

  ```bash
  ./devopsfetch.sh -u
  ```

- **Provide detailed information about a specific user:**

  ```bash
  ./devopsfetch.sh -u username
  ```

- **Display activities within a specified time range (feature not yet implemented):**

  ```bash
  ./devopsfetch.sh -t
  ```

- **Display help message:**

  ```bash
  ./devopsfetch.sh -h
  ```

## Logging

The continuous monitoring mode is implemented using a systemd service. Logs are managed by systemd and can be retrieved using:

```bash
journalctl -u devopsfetch.service
```

## Dependencies

- `net-tools`
- `docker.io`
- `nginx`

These dependencies are installed by the `install_devopsfetch.sh` script.

## Development

To contribute to `devopsfetch`, fork the repository and submit a pull request.
