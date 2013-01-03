# NAME

    utime

# DESCRIPTION

utime is a simple utility for outputting times in seconds since the Unix epoch.
Times are specified as either straight numbers, or additions/subtractions on
numbers.  Supported special times are: 'now', 'yesterday' and 'tomorrow':
the latter are 24 hour offsets on 'now'.

# EXAMPLES

## Reading Expressions from Standard Input

    % echo 3 + 4 | ./utime
    7

## Reading Expressions from Command Line Arguments

    % ./utime 3 + 4
    7

## Relative Times (output dependent upon execution time)

    % ./utime now + 2 days - 4 hours
    % ./utime now + 1 hour - 1 minute

## -r: translating UNIX Timestamps to Human Readable Output

    % ./utime -r 1285532072
    Sun Sep 26 21:14:32 2010

# LICENSE

GPLv3 (http://opensource.org/licenses/GPL-3.0)

# AUTHOR

Danny Woods (dannywoodz@yahoo.co.uk)