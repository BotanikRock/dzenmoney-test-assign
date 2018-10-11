-- Можно было и усложнить изначальную схему: добавить например валюты, 
-- но я не стал, так как в контексте задачи избыточно и лишь приводит к увеличению выполнения задания

CREATE TABLE costs (
    id SERIAL PRIMARY KEY,
    date DATE,
    value INTEGER,
    category_id INTEGER
);

CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    title TEXT
);