# NAME

Plack::Middleware::PathToQuery - Prepend converted PATH\_INFO to QUERY\_STRING

# VERSION

version v0.0.1

# SYNOPSIS

    use Plack::Bulder;
    use Plack::Middleware::PathTuQuery;
    

    my $app = sub { ... };
    builder {
      enable 'PathToQuery', 'debug' => 1;
      $app;
    };

# DESCRIPTION

Plack::Midleware::PathToQuery is a Plack middleware to prepend converted PATH\_INFO to QUERY\_STRING.
The conversion rule is as follows:

- Initial '/' character is stripped if exists.
- '/' is converted to '&'.
- The first '-' for each path component is converted to '='.
- If '-' does not appear in a path component, '=' is appended.

Thus,

    /key1-value1/key2/key3-value3-value4

is converted to

    key1=value&key2=&key3=value3-value4

The converted string is prepended to QUERY\_STRING.
If QUERY\_STRING is not empty, '&' is inserted between them.
After the process of this middleware, PATH\_INFO becomes empty.

If `debug => 1` is specifed as argument, PATH\_INFO/QUERY\_STRING before/after the conversion are shown.

# AUTHOR

Yasutaka ATARASHI <yakex@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yasutaka ATARASHI.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
