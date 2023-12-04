function blkStruct = slblocks
% This function specifies that the library 'slx_LJM'
% should appear in the Library Browser with the 
% name 'LabJack LJM'

    Browser.Library = 'slx_LJM';
    % 'mylib' is the name of the library

    Browser.Name = 'LabJack LJM';
    % 'My Library' is the library name that appears
    % in the Library Browser

    blkStruct.Browser = Browser;