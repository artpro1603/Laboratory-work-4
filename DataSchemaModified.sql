CREATE TABLE app_user (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY,
    player_symbol CHAR(1) NOT NULL,

    CONSTRAINT app_user_pk PRIMARY KEY (user_id),
    CONSTRAINT app_user_role_check
    CHECK (player_symbol IN ('X', 'O'))
);

CREATE TABLE game (
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

CREATE TABLE game_user (
    game_user_id BIGINT GENERATED ALWAYS AS IDENTITY,
    game_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,

    CONSTRAINT game_user_pk PRIMARY KEY (game_user_id),
    CONSTRAINT game_user_game_fk
    FOREIGN KEY (game_id) REFERENCES game (game_id),
    CONSTRAINT game_user_user_fk
    FOREIGN KEY (user_id) REFERENCES app_user (user_id),
    CONSTRAINT game_user_unique UNIQUE (game_id, user_id)
);

CREATE TABLE board (
    board_id BIGINT GENERATED ALWAYS AS IDENTITY,
    game_id BIGINT NOT NULL,

    CONSTRAINT board_pk PRIMARY KEY (board_id),
    CONSTRAINT board_game_fk
    FOREIGN KEY (game_id) REFERENCES game (game_id),
    CONSTRAINT board_game_unique UNIQUE (game_id)
);

CREATE TABLE cell (
    cell_id BIGINT GENERATED ALWAYS AS IDENTITY,
    board_id BIGINT NOT NULL,
    row_number SMALLINT NOT NULL,
    column_number SMALLINT NOT NULL,

    CONSTRAINT cell_pk PRIMARY KEY (cell_id),
    CONSTRAINT cell_board_fk
    FOREIGN KEY (board_id) REFERENCES board (board_id),
    CONSTRAINT cell_row_check
    CHECK (row_number BETWEEN 1 AND 3),
    CONSTRAINT cell_column_check
    CHECK (column_number BETWEEN 1 AND 3),
    CONSTRAINT cell_position_unique
    UNIQUE (board_id, row_number, column_number)
);

CREATE TABLE ar_marker (
    marker_id BIGINT GENERATED ALWAYS AS IDENTITY,
    designation VARCHAR(30) NOT NULL,

    CONSTRAINT ar_marker_pk PRIMARY KEY (marker_id),
    CONSTRAINT ar_marker_designation_unique UNIQUE (designation),
    CONSTRAINT ar_marker_designation_check
    CHECK (designation ~ '^[A-Za-z0-9_-]{1,30}$')
);

CREATE TABLE piece (
    piece_id BIGINT GENERATED ALWAYS AS IDENTITY,
    piece_type CHAR(1) NOT NULL,
    marker_id BIGINT NOT NULL,

    CONSTRAINT piece_pk PRIMARY KEY (piece_id),
    CONSTRAINT piece_marker_fk
    FOREIGN KEY (marker_id) REFERENCES ar_marker (marker_id),
    CONSTRAINT piece_type_check
    CHECK (piece_type IN ('X', 'O'))
);

CREATE TABLE game_move (
    move_id BIGINT GENERATED ALWAYS AS IDENTITY,
    game_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    piece_id BIGINT NOT NULL,
    cell_id BIGINT NOT NULL,
    validity BOOLEAN NOT NULL,

    CONSTRAINT game_move_pk PRIMARY KEY (move_id),
    CONSTRAINT game_move_game_fk
    FOREIGN KEY (game_id) REFERENCES game (game_id),
    CONSTRAINT game_move_user_fk
    FOREIGN KEY (user_id) REFERENCES app_user (user_id),
    CONSTRAINT game_move_piece_fk
    FOREIGN KEY (piece_id) REFERENCES piece (piece_id),
    CONSTRAINT game_move_cell_fk
    FOREIGN KEY (cell_id) REFERENCES cell (cell_id),
    CONSTRAINT game_move_cell_unique UNIQUE (game_id, cell_id)
);
