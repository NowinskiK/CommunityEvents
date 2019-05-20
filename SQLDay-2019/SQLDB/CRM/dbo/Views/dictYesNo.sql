--CREATE VIEW dbo.dictYesNo
--AS
--SELECT number AS [Id], [name] AS [caption] 
--FROM master.dbo.spt_values 
--WHERE [type] = 'B'


/*
The spt_values table is not mentioned in the the SQL Server documentation but it goes back to the Sybase days and there is some extremely minimal documentation in the Sybase online docs that can be summed up in this comment:

In other words, read the code and work it out for yourself.

If you poke around the system stored procedures and examine the table data itself, it's fairly clear that the table is used to translate codes into readable strings (among other things). Or as the Sybase documentation linked above puts it, "to convert internal system values [...] into human-readable format"

The table is also sometimes used in code snippets in MSDN blogs - but never in formal documentation - usually as a convenient source of a list of numbers. But as discussed elsewhere, creating your own source of numbers is a safer and more reliable solution than using an undocumented system table. There is even a Connect request to provide a 'proper', documented number table in SQL Server itself.

Anyway, the table is entirely undocumented so there is no significant value in knowing anything about it, at least from a practical standpoint: the next servicepack or upgrade might change it completely. Intellectual curiosity is something else, of course :-)
*/