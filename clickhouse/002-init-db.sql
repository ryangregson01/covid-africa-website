CREATE DATABASE IF NOT EXISTS covid19;

CREATE TABLE IF NOT EXISTS covid19.updates
(
    `ISOCode` FixedString(3),
    `Continent` String,
    `Location` String,
    `UpdateDate` Date,
    `TotalCases` UInt32 NULL,
    `NewCases` Int32 NULL,
    `TotalDeaths` UInt32 NULL,
    `NewDeaths` Int32 NULL,
    `ReproductionRate` UInt32 NULL,
    `NewTests` Int32 NULL,
    `TotalTests` UInt32 NULL,
    `PositiveRate` UInt32 NULL,
    `TotalVaccinations` UInt32 NULL,
    `PeopleVaccinated` UInt32 NULL,
    `PeopleFullyVaccinated` UInt32 NULL,
    `TotalBoosters` UInt32 NULL,
    `NewVaccinations` Int32 NULL,
    `Population` UInt32 NULL,
    `MedianAge` UInt32 NULL,
    `GdpPerCapita` Int32 NULL,
    `LifeExpectancy` UInt32 NULL
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
