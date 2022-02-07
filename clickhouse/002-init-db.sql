CREATE DATABASE IF NOT EXISTS covid19;

CREATE TABLE IF NOT EXISTS covid19.updates
(
    `ISOCode` FixedString(3),
    `Continent` String,
    `Location` String,
    `UpdateDate` Date,
    `TotalCases` INT NULL,
    `NewCases` INT NULL,
    `TotalDeaths` INT NULL,
    `NewDeaths` INT NULL,
    `TotalCasesPerMil` FLOAT NULL,
    `NewCasesPerMil` FLOAT NULL,
    `NewDeathsPerMil` FLOAT NULL,
    `ReproductionRate` FLOAT NULL,
    `HospitalPatients` INT NULL,
    `HospitalPatientsPerMil` FLOAT NULL,
    `NewTests` INT NULL,
    `TotalTests` INT NULL,
    `PositiveRate` INT NULL,
    `TotalVaccinations` INT NULL,
    `PeopleVaccinated` INT NULL,
    `PeopleFullyVaccinated` INT NULL,
    `TotalBoosters` INT NULL,
    `NewVaccinations` INT NULL,
    `TotalBoostersPerHun` FLOAT NULL,
    `FullyVaccinatedPerHun` FLOAT NULL,
    `NewVaccinationsSmoothPerMil` FLOAT NULL,
    `Population` UInt32 NULL,
    `MedianAge` FLOAT NULL,
    `GdpPerCapita` FLOAT NULL,
    `LifeExpectancy` FLOAT NULL
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(UpdateDate)
ORDER BY (Location, UpdateDate);

-- Optimization is redundant for a new table but if covid19.updates
-- already existed then the optimization will merge the parts.
OPTIMIZE TABLE covid19.updates FINAL;

SET allow_experimental_live_view = 1;
-- This live view contains the most recent records to avoid scanning the
-- entire database. The SummingMergeTree was chosen because it allows for
-- more efficient aggregates across the records.
CREATE LIVE VIEW IF NOT EXISTS covid19.latest
WITH REFRESH 3600
AS SELECT *
FROM covid19.updates
WHERE UpdateDate = (
    SELECT max(UpdateDate)
    FROM covid19.updates
);
