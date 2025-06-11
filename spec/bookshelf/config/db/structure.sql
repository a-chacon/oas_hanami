CREATE TABLE `schema_migrations`(`filename` varchar(255) NOT NULL PRIMARY KEY);
CREATE TABLE `books`(
  `id` integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  `title` text NOT NULL,
  `author` text NOT NULL
);
INSERT INTO schema_migrations (filename) VALUES
('20250611145407_create_books.rb');
