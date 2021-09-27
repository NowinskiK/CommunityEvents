
CREATE EXTERNAL FILE FORMAT KnTaxiFileFormat 
WITH 
(   
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (   
        FIELD_TERMINATOR = ',',
        USE_TYPE_DEFAULT = FALSE,
        First_Row = 2
    )
);
GO
