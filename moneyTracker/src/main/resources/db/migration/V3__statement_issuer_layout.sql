-- Which issuer was detected and which parser layout read the statement,
-- so unsupported formats can be found and fixed.
ALTER TABLE statements ADD COLUMN issuer VARCHAR(50);
ALTER TABLE statements ADD COLUMN parser_layout VARCHAR(50);
