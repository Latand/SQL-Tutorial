CREATE TABLE telegram_users
(
    telegram_id bigint primary key,
    full_name   varchar(200) not null,
    username    varchar(200),
    created_at  timestamp default now(),
    referrer_id bigint
        constraint "fk__users_referrer_id"
            references users
            on delete set null
);



