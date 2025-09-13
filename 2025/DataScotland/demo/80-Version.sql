select @@SERVERNAME as 'Server Name',  @@VERSION as 'SQL Version',
       db_name() as 'Database Name',
       user_name() as 'User Name',
       suser_sname() as 'Login Name';


