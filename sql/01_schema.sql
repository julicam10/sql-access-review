CREATE TABLE applications (
	app_id INTEGER PRIMARY KEY,
	app_name TEXT NOT NULL,
	business_area TEXT,
	criticality TEXT NOT NULL,
	app_owner TEXT
);

CREATE TABLE users(
	user_id INTEGER PRIMARY KEY,
	username TEXT NOT NULL,
	full_name TEXT NOT NULL,
	email TEXT,
	department TEXT,
	account_owner TEXT,
	status TEXT NOT NULL,
	created_date TEXT NOT NULL,
	last_review_date TEXT
);

CREATE TABLE roles(
	role_id INTEGER PRIMARY KEY,
	role_name TEXT NOT NULL,
	app_id INTEGER NOT NULL,
	is_privileged INTEGER NOT NULL,
	FOREIGN KEY (app_id) REFERENCES applications (app_id)
);

CREATE TABLE user_roles(
	user_id INTEGER NOT NULL,
	role_id INTEGER NOT NULL,
	assigned_date TEXT NOT NULL,
	approved_by TEXT,
	FOREIGN KEY (user_id) REFERENCES users (user_id),
	FOREIGN KEY (role_id) REFERENCES roles (role_id),
	PRIMARY KEY (user_id, role_id)
);

CREATE TABLE login_activity(
	login_id INTEGER PRIMARY KEY,
	user_id INTEGER NOT NULL,
	app_id INTEGER NOT NULL,
	login_date TEXT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users (user_id),
	FOREIGN KEY (app_id) REFERENCES applications (app_id)
);

CREATE TABLE sod_conflicts(
	conflict_id INTEGER PRIMARY KEY,
	role_a_id INTEGER NOT NULL,
	role_b_id INTEGER NOT NULL,
	description TEXT NOT NULL,
	risk_level TEXT NOT NULL,
	FOREIGN KEY (role_a_id) REFERENCES roles (role_id),
	FOREIGN KEY (role_b_id) REFERENCES roles (role_id)
);