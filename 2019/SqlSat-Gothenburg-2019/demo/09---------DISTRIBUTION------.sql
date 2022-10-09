CREATE EXTERNAL FILE FORMAT KnTextFileFormat 
WITH 
(   
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (   
        FIELD_TERMINATOR = '|',
        USE_TYPE_DEFAULT = FALSE,
        First_Row = 2
    )
);
GO

