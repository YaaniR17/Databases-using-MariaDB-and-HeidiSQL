-- Database Initialization
CREATE DATABASE IF NOT EXISTS homelab_inventory
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE homelab_inventory;

-- 1. Physical Hardware Nodes
CREATE TABLE IF NOT EXISTS physical_nodes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hostname VARCHAR(100) NOT NULL UNIQUE,
    model VARCHAR(100),
    cpu VARCHAR(100),
    ram_gb INT,
    storage_info VARCHAR(255),
    ip_address VARCHAR(45) NOT NULL,
    mac_address VARCHAR(17),
    operating_system VARCHAR(100),
    status ENUM('Online', 'Offline', 'Maintenance') DEFAULT 'Online',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Virtual Machines & LXC Containers
CREATE TABLE IF NOT EXISTS virtual_environments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    node_id INT NOT NULL,
    vmid INT UNIQUE,
    name VARCHAR(100) NOT NULL,
    type ENUM('VM', 'LXC', 'Docker-Host', 'Other') NOT NULL,
    ip_address VARCHAR(45),
    cpu_cores INT,
    ram_mb INT,
    os VARCHAR(100),
    status ENUM('Running', 'Stopped', 'Template') DEFAULT 'Running',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (node_id) REFERENCES physical_nodes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Hosted Services & Docker Containers
CREATE TABLE IF NOT EXISTS hosted_services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    virtual_env_id INT NULL,
    node_id INT NULL,
    service_name VARCHAR(100) NOT NULL,
    local_domain VARCHAR(255),
    port INT,
    status ENUM('Running', 'Stopped', 'Degraded') DEFAULT 'Running',
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (virtual_env_id) REFERENCES virtual_environments(id) ON DELETE SET NULL,
    FOREIGN KEY (node_id) REFERENCES physical_nodes(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- Initial Seed Data based on your lab infrastructure
INSERT INTO physical_nodes (hostname, model, cpu, ram_gb, storage_info, ip_address, mac_address, operating_system) VALUES
('pve', 'Dell Vostro 3268', 'Intel Core i3-7100', 12, '500GB Hybrid SSD + 250GB HDD', '192.168.1.2', '48:4d:7e:b1:2e:be', 'Proxmox VE 9.2.3'),
('router', 'Mini PC', 'Intel Celeron J4125', 8, '128GB SSD + 500GB SSD', '192.168.1.1', NULL, 'OPNsense 26.7'),
('msi-ai-workstation', 'MSI A15 AI B8V', 'AMD Ryzen 7 8845HS', 16, '1TB SSD', '192.168.1.150', NULL, 'Windows 11');

INSERT INTO virtual_environments (node_id, vmid, name, type, ip_address, cpu_cores, ram_mb, os) VALUES
(1, 100, 'Docker Host', 'LXC', '192.168.1.160', 2, 4096, 'Ubuntu LXC'),
(1, 101, 'Minecraft Server', 'VM', '192.168.1.101', 2, 2048, 'Ubuntu Server'),
(1, 102, 'Windows Server 2022', 'VM', '192.168.1.102', 2, 4096, 'Windows Server 2022'),
(1, 103, 'Metasploitable', 'VM', '192.168.1.103', 1, 1024, 'Linux');

INSERT INTO hosted_services (virtual_env_id, service_name, local_domain, port, description) VALUES
(1, 'Jellyfin', 'jellyfin.lab', 8096, 'Media server running custom Abyss theme'),
(1, 'Homarr', 'homarr.lab', 7575, 'Central dashboard linking services'),
(1, 'Nginx Proxy Manager', NULL, 81, 'Reverse proxy managing local domains'),
(1, 'Pi-hole', 'pihole.lab', 8888, 'Network-wide DNS ad/tracker blocker'),
(1, 'Uptime Kuma', 'uptime.lab', 3001, 'Uptime and service monitoring'),
(1, 'Portainer', 'portainer.lab', 9000, 'Web dashboard for managing Docker');