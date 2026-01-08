erDiagram

    USERS ||--o{ CANVASES : creates
    USERS ||--o{ LOOPS : creates
    USERS ||--o{ SESSIONS : has
    USERS ||--o{ GALLERIES : owns
    USERS ||--o{ OAUTH_ACCOUNTS : links
    USERS ||--o{ FRIENDSHIPS : participates
    USERS ||--o{ CANVAS_LIKES : likes
    USERS ||--o{ CANVAS_COMMENTS : comments
    USERS ||--o{ CHAT_MESSAGES : sends
    USERS ||--o{ NOTIFICATIONS : receives
    USERS ||--o{ LOOP_PARTICIPANTS : joins
    USERS ||--o{ FRAMES : creates

    LOOPS ||--o{ LOOP_PARTICIPANTS : has
    LOOPS ||--o{ FRAMES : contains
    LOOPS ||--o{ CHAT_MESSAGES : has
    LOOPS }o--|| CANVASES : uses

    CANVASES ||--o{ CANVAS_TAGS : tagged
    TAGS ||--o{ CANVAS_TAGS : linked
    CANVASES ||--o{ CANVAS_LIKES : liked_by
    CANVASES ||--o{ CANVAS_COMMENTS : commented

    FRIENDSHIPS }o--|| USERS : user_a
    FRIENDSHIPS }o--|| USERS : user_b

    USERS {
        uuid id
        string username
        string email
    }

    CANVASES {
        uuid id
        string title
        string type
    }

    LOOPS {
        uuid id
        string name
        boolean is_multiplayer
    }

    FRAMES {
        uuid id
        int order
    }

    TAGS {
        uuid id
        string label
    }
