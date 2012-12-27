DO $$
DECLARE 
	u1 integer;
	u2 integer;
	w integer;
BEGIN
	-- create all the users
	INSERT INTO users (name, email, hashed_password, salt, created_at)
	VALUES ('user1', 'u1@a.com', 'd6f9b72d347a4fd1084682f49e419a78ea439905a7126a6a76ba0bccf2ee0469', '4c3f2d81-982c-4561-943b-67e20d1edffa', '12/12/2012')
	RETURNING id INTO u1;
	
	INSERT INTO users (name, email, hashed_password, salt, created_at)
	VALUES ('user2', 'u2@a.com', 'ae64b1e98ab6198d77afeebab4162b4e9ec094cf4f90d22c571dacd8785a376e', 'a3d1a5f2-7339-41c4-bcc8-f20f1e5a4397', '12/12/2012')
	RETURNING id INTO u2;
	
	-- create webpages and corresponding user bookmarks
	-- create web page 1
	INSERT INTO web_pages (title, url) 
	VALUES ('CMU open lectures initiative', 'http://oli.web.cmu.edu/openlearning/index.php')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/1/2012', TRUE, 'CMU online courses', 'Pretty cool website with free courses');
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u2, w, '12/2/2012', TRUE, 'CMU online courses', 'Pretty cool website with free courses');
	
	-- create web page 2
	INSERT INTO web_pages (title, url) 
	VALUES ('StackOverflow discussion board', 'http://stackoverflow.com/questions/1625327/editorfor-and-html-properties')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/3/2012', TRUE, 'Stackoverflow - html editors', 'Test notes here.');
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u2, w, '12/4/2012', TRUE, 'Stackoverflow - html editor', 'Test notes here.');
	
	-- create web page 3
	INSERT INTO web_pages (title, url) 
	VALUES ('MIT Open Courseware Home', 'http://ocw.mit.edu/index.htm')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/5/2012', TRUE, 'MIT free courses', 'Test notes here.');
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u2, w, '12/6/2012', FALSE, 'MIT free courses', 'Test notes here.');
	
	-- create web page 4
	INSERT INTO web_pages (title, url) 
	VALUES ('Coursera Machine Learning class', 'http://www.ml-class.com/')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/7/2012', TRUE, 'Coursera Machine Learning class', 'Test notes here.');
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u2, w, '12/8/2012', FALSE, 'Coursera Machine Learning class', 'Test notes here.');
	
	-- create web page 5
	INSERT INTO web_pages (title, url) 
	VALUES ('Ruby regular expressions tester', 'http://www.rubular.com/')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/1/2012', FALSE, 'Ruby regular expressions tester', 'Test notes here.');
	
	-- create web page 6
	INSERT INTO web_pages (title, url) 
	VALUES ('Rspec - Relish', 'http://relishapp.com/rspec')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/9/2012', FALSE, 'Rspec - Relish', 'Test notes here.');
	
	-- create web page 7
	INSERT INTO web_pages (title, url) 
	VALUES ('New business ideas and trends', 'http://www.springwise.com/')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/10/2012', FALSE, 'New business ideas and trends', 'Test notes here.');

	-- create web page 8
	INSERT INTO web_pages (title, url) 
	VALUES ('MODIS Azure - Microsoft Research', 'http://research.microsoft.com/en-us/projects/azure/azuremodis.aspx')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/11/2012', FALSE, 'MODIS Azure - Microsoft Research', 'Test notes here.');
	
	-- create web page 9
	INSERT INTO web_pages (title, url) 
	VALUES ('Agile Alliance :: Home', 'http://www.agilealliance.org/')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/12/2012', FALSE, 'Agile Alliance :: Home', 'Test notes here.');
		
	-- create web page 10
	INSERT INTO web_pages (title, url) 
	VALUES ('How to start a business', 'http://www.myownbusiness.org/')
	RETURNING id INTO w;
	
	INSERT INTO bookmarks (user_id, web_page_id, added_on, is_pinned, name, notes)
	VALUES (u1, w, '12/13/2012', FALSE, 'How to start a business', 'Test notes here.');	
	
END $$;
