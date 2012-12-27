CREATE TABLE IF NOT EXISTS users (
	id serial CONSTRAINT U_pri_key PRIMARY KEY,
	name varchar(50),
	email varchar(50),
	hashed_password varchar(1024),
	salt varchar(1024),
	created_at timestamp,
	last_activity_at timestamp
);

CREATE TABLE IF NOT EXISTS web_pages (
	id serial CONSTRAINT w_pri_key PRIMARY KEY,
	url varchar(1024),
	title varchar(1024),
	crawled_at timestamp
);

CREATE TABLE IF NOT EXISTS bookmarks (
	id serial CONSTRAINT b_pri_key PRIMARY KEY,
	name varchar(50),
	notes text,
	added_on timestamp,
	is_pinned boolean,
	user_id integer CONSTRAINT fk_bookmarks_users REFERENCES users,
	web_page_id integer CONSTRAINT fk_bookmarks_web_pages REFERENCES web_pages
);