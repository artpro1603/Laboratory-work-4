CREATE TABLE "User" (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY,
    role CHAR(1) NOT NULL,

    CONSTRAINT user_pk PRIMARY KEY (user_id),
    CONSTRAINT user_role_check
        CHECK (role ~ '^[XO]$')
);

CREATE TABLE "Game" (
    game_id BIGINT GENERATED ALWAYS AS IDENTITY,
    state VARCHAR(20) NOT NULL,
    current_player CHAR(1) NOT NULL,
    result VARCHAR(20) NOT NULL,

    CONSTRAINT game_pk PRIMARY KEY (game_id),
    CONSTRAINT game_state_check
        CHECK (state IN ('Триває', 'Завершена')),
    CONSTRAINT game_current_player_check
        CHECK (current_player IN ('X', 'O')),
    CONSTRAINT game_result_check
        CHECK (result IN (
            'ПеремогаX',
            'ПеремогаO',
            'Нічия',
            'НеВизначено'
        ))
);

CREATE TABLE "GameUser" (
    game_user_id BIGINT GENERATED ALWAYS AS IDENTITY,
    game_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,

    CONSTRAINT game_user_pk PRIMARY KEY (game_user_id),
    CONSTRAINT game_user_game_fk
        FOREIGN KEY (game_id) REFERENCES "Game" (game_id),
    CONSTRAINT game_user_user_fk
        FOREIGN KEY (user_id) REFERENCES "User" (user_id),
    CONSTRAINT game_user_unique UNIQUE (game_id, user_id)
);

CREATE TABLE "Board" (
    board_id BIGINT GENERATED ALWAYS AS IDENTITY,
    game_id BIGINT NOT NULL,

    CONSTRAINT board_pk PRIMARY KEY (board_id),
    CONSTRAINT board_game_fk
        FOREIGN KEY (game_id) REFERENCES "Game" (game_id),
    CONSTRAINT board_game_unique UNIQUE (game_id)
);

CREATE TABLE "Cell" (
    cell_id BIGINT GENERATED ALWAYS AS IDENTITY,
    board_id BIGINT NOT NULL,
    row_number SMALLINT NOT NULL,
    column_number SMALLINT NOT NULL,

    CONSTRAINT cell_pk PRIMARY KEY (cell_id),
    CONSTRAINT cell_board_fk
        FOREIGN KEY (board_id) REFERENCES "Board" (board_id),
    CONSTRAINT cell_row_check
        CHECK (row_number BETWEEN 1 AND 3),
    CONSTRAINT cell_column_check
        CHECK (column_number BETWEEN 1 AND 3),
    CONSTRAINT cell_position_unique
        UNIQUE (board_id, row_number, column_number)
);

CREATE TABLE "ARMarker" (
    marker_id INTEGER NOT NULL,

    CONSTRAINT ar_marker_pk PRIMARY KEY (marker_id),
    CONSTRAINT ar_marker_id_check CHECK (marker_id BETWEEN 0 AND 49)
);

CREATE TABLE "Piece" (
    piece_id BIGINT GENERATED ALWAYS AS IDENTITY,
    type CHAR(1) NOT NULL,
    marker_id BIGINT NOT NULL,

    CONSTRAINT piece_pk PRIMARY KEY (piece_id),
    CONSTRAINT piece_marker_fk
        FOREIGN KEY (marker_id) REFERENCES "ARMarker" (marker_id),
    CONSTRAINT piece_type_check
        CHECK (type ~ '^[XO]$')
);

CREATE TABLE "Move" (
    move_id BIGINT GENERATED ALWAYS AS IDENTITY,
    game_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    piece_id BIGINT NOT NULL,
    cell_id BIGINT NOT NULL,
    validity BOOLEAN NOT NULL,

    CONSTRAINT move_pk PRIMARY KEY (move_id),
    CONSTRAINT move_game_fk
        FOREIGN KEY (game_id) REFERENCES "Game" (game_id),
    CONSTRAINT move_user_fk
        FOREIGN KEY (user_id) REFERENCES "User" (user_id),
    CONSTRAINT move_piece_fk
        FOREIGN KEY (piece_id) REFERENCES "Piece" (piece_id),
    CONSTRAINT move_cell_fk
        FOREIGN KEY (cell_id) REFERENCES "Cell" (cell_id),
    CONSTRAINT move_cell_unique
        UNIQUE (game_id, cell_id)
);
