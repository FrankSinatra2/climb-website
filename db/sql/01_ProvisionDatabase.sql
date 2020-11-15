CREATE DATABASE IF NOT EXISTS `ClimbingExploration`;

CREATE TABLE IF NOT EXISTS `ClimbingExploration`.`Users` (
    `id` VARCHAR(50) PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL,
    `hashedPwd` VARCHAR(128) NOT NULL,
    UNIQUE INDEX username_idx (`id`)
);

CREATE TABLE IF NOT EXISTS `ClimbingExploration`.`Images` (
    `id` VARCHAR(50) PRIMARY KEY,
    `originalName` VARCHAR(50) NOT NULL,
    `ext` ENUM('PNG') NOT NULL DEFAULT 'PNG',
    `path` VARCHAR(50) NOT NULL
);

