CREATE DATABASE IF NOT EXISTS `ClimbingExploration`;

CREATE TABLE IF NOT EXISTS `ClimbingExploration`.`Users` (
    `id` VARCHAR(50) PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL,
    `hashedPwd` VARCHAR(128) NOT NULL,
    UNIQUE INDEX username_idx (`id`)
);

CREATE TABLE IF NOT EXISTS `ClimbingExploration`.`Images` (
    `id` VARCHAR(50) PRIMARY KEY,
    `subZoneId` VARCHAR(50),
    `originalName` VARCHAR(50) NOT NULL,
    `ext` ENUM('png', 'jpeg') NOT NULL,
    `path` VARCHAR(50) NOT NULL,
    CONSTRAINT fk_SubZone FOREIGN KEY (`subZoneId`)
        REFERENCES `ClimbingExploration`.`SubZones`(`id`)
);

CREATE TABLE IF NOT EXISTS `ClimbingExploration`.`Zones` (
    `id` VARCHAR(50) PRIMARY KEY,
    `latitude` FLOAT,
    `longitude` FLOAT,
    `title` VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS `ClimbingExploration`.`SubZones` (
    `id` VARCHAR(50) PRIMARY KEY,
    `zoneId` VARCHAR(50) NOT NULL,
    `title` VARCHAR(80) NOT NULL,
    `description` TEXT NOT NULL,
    CONSTRAINT fk_Zone FOREIGN KEY (`zoneId`)
        REFERENCES `ClimbingExploration`.`Zones`(`id`)
);

-- CREATE TABLE IF NOT EXISTS `ClimbingExploration`.`SubZoneImages` (
--     `subZoneId` VARCHAR(50) NOT NULL,
--     `imageId` VARCHAR(50) NOT NULL,
--     CONSTRAINT fk_SubZone FOREIGN KEY (`subZoneId`)
--         REFERENCES `ClimbingExploration`.`SubZones`(`id`),
--     CONSTRAINT fk_Image FOREIGN KEY (`imageId`)
--         REFERENCES `ClimbingExploration`.`Images`(`id`)
-- );