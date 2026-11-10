-- Resonance: initial database schema (SQLite)
-- Covers: users, tracks, listening sessions, ratings, favourites, recommendation history.

PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    discord_id        TEXT    NOT NULL UNIQUE,            -- Discord snowflake, stored as text
    pseudonym_id      TEXT    NOT NULL UNIQUE,            -- used in CSV export instead of discord_id
    participant_group TEXT    NOT NULL DEFAULT 'participant'
                      CHECK (participant_group IN ('participant', 'team')),  -- team results reported separately
    created_at        TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE tracks (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    title            TEXT    NOT NULL,
    artist           TEXT,
    genre            TEXT,                                -- e.g. country, rock, jazz, pop
    tags             TEXT,                                -- space-separated tags, input for TF-IDF
    file_path        TEXT    NOT NULL UNIQUE,             -- path to local MP3
    duration_seconds INTEGER CHECK (duration_seconds IS NULL OR duration_seconds > 0),
    created_at       TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE listening_sessions (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id          INTEGER NOT NULL REFERENCES users(id)  ON DELETE CASCADE,
    track_id         INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
    started_at       TEXT    NOT NULL DEFAULT (datetime('now')),
    finished_at      TEXT,
    listened_seconds INTEGER NOT NULL DEFAULT 0 CHECK (listened_seconds >= 0),  -- excludes paused time
    status           TEXT    NOT NULL DEFAULT 'playing'
                     CHECK (status IN ('playing', 'finished', 'skipped'))
);
CREATE INDEX idx_sessions_user  ON listening_sessions(user_id);
CREATE INDEX idx_sessions_track ON listening_sessions(track_id);

CREATE TABLE ratings (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER NOT NULL REFERENCES users(id)  ON DELETE CASCADE,
    track_id   INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
    score      INTEGER NOT NULL CHECK (score BETWEEN 1 AND 5),
    created_at TEXT    NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT    NOT NULL DEFAULT (datetime('now')),
    UNIQUE (user_id, track_id)                            -- enables UPSERT, prevents duplicates
);

CREATE TABLE favourites (
    user_id  INTEGER NOT NULL REFERENCES users(id)  ON DELETE CASCADE,
    track_id INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
    added_at TEXT    NOT NULL DEFAULT (datetime('now')),
    PRIMARY KEY (user_id, track_id)
);

CREATE TABLE recommendation_lists (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id       INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    algorithm     TEXT    NOT NULL CHECK (algorithm IN ('baseline', 'tfidf')),
    experiment_id TEXT,                                   -- seed / experiment identifier
    created_at    TEXT    NOT NULL DEFAULT (datetime('now'))
);
CREATE INDEX idx_reclists_user ON recommendation_lists(user_id);

CREATE TABLE recommendation_items (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    list_id  INTEGER NOT NULL REFERENCES recommendation_lists(id) ON DELETE CASCADE,
    track_id INTEGER NOT NULL REFERENCES tracks(id)               ON DELETE CASCADE,
    rank     INTEGER NOT NULL CHECK (rank >= 1),          -- list position (1..3)
    UNIQUE (list_id, rank),
    UNIQUE (list_id, track_id)                            -- no duplicate tracks in one list
);

-- P@3 export: recommendation item joined with the user's rating (NULL rating = missing data)
CREATE VIEW v_experiment_export AS
SELECT u.pseudonym_id,
       u.participant_group,
       l.algorithm,
       l.experiment_id,
       l.id          AS list_id,
       i.track_id,
       i.rank        AS position,
       r.score       AS rating,
       l.created_at  AS event_timestamp
FROM recommendation_items i
JOIN recommendation_lists l ON l.id = i.list_id
JOIN users u                ON u.id = l.user_id
LEFT JOIN ratings r         ON r.user_id = l.user_id AND r.track_id = i.track_id;