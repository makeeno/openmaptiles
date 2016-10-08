CREATE OR REPLACE VIEW urban_z4 AS (
    SELECT geom, scalerank
    FROM ne_50m_urban_areas
    WHERE scalerank <= 2
);

CREATE OR REPLACE VIEW urban_z5 AS (
    SELECT geom, scalerank
    FROM ne_50m_urban_areas
);

CREATE OR REPLACE VIEW urban_z6 AS (
    SELECT geom, scalerank
    FROM ne_10m_urban_areas
);

CREATE OR REPLACE FUNCTION layer_urban(bbox geometry, zoom_level int)
RETURNS TABLE(geom geometry, scalerank int) AS $$
    WITH zoom_levels AS (
        SELECT * FROM urban_z4
        WHERE zoom_level = 4
        UNION ALL
        SELECT * FROM urban_z5
        WHERE zoom_level = 5
        UNION ALL
        SELECT * FROM urban_z6
        WHERE zoom_level >= 6 AND scalerank-1 <= zoom_level
    )
    SELECT geom, scalerank FROM zoom_levels
    WHERE geom && bbox;
$$ LANGUAGE SQL IMMUTABLE;