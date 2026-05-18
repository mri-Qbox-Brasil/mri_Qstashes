CREATE TABLE IF NOT EXISTS `mri_qstashes` (
    `id` INT NOT NULL PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL,
    `job` VARCHAR(50) DEFAULT '',
    `gang` VARCHAR(50) DEFAULT '',
    `rank` VARCHAR(50) DEFAULT '',
    `item` VARCHAR(50) DEFAULT '',
    `slotSize` INT DEFAULT 50,
    `weight` INT DEFAULT 1000000,
    `password` INT DEFAULT 0,
    `citizenID` VARCHAR(50) DEFAULT '',
    `targetlabel` VARCHAR(100) DEFAULT '',
    `webhookURL` TEXT DEFAULT NULL,
    `loc` TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
