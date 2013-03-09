package Plack::Middleware::PathToQuery;

use strict;
use warnings;

# ABSTRACT: Prepend converted PATH_INFO to QUERY_STRING
# VERSION

use parent qw(Plack::Middleware);

use URI::Escape;

sub call
{
	my ($self, $env) = @_;

	my $DEBUG = exists $self->{debug} && $self->{debug};

	$DEBUG and $env->{'psgi.errors'}->print('PATH_INFO: '.$env->{PATH_INFO}."\n");
	$DEBUG and $env->{'psgi.errors'}->print('QUERY_STRING: '.$env->{QUERY_STRING}."\n");

	my @pairs;
	if($env->{PATH_INFO} ne '') {
		my $path = $env->{PATH_INFO};
		$path =~ s@^/@@;
		my @components = split '/', $path;
		for my $component (@components) {
			if($component =~ s/^([^-]+)-//) {
				push @pairs, uri_escape($1).'='.uri_escape($component);
			} else {
				push @pairs, uri_escape($component);
			}
		}
		push @pairs, $env->{QUERY_STRING} if $env->{QUERY_STRING} ne '';
		$env->{QUERY_STRING} = join '&', @pairs;
		$env->{PATH_INFO} = '';
	}

	$DEBUG and $env->{'psgi.errors'}->print('PATH_INFO: '.$env->{PATH_INFO}."\n");
	$DEBUG and $env->{'psgi.errors'}->print('QUERY_STRING: '.$env->{QUERY_STRING}."\n");

	return $self->app->($env);
}

1;
__END__

=head1 SYNOPSIS

  use Plack::Bulder;
  use Plack::Middleware::PathTuQuery;
  
  my $app = sub { ... };
  builder {
    enable 'PathToQuery', 'debug' => 1;
    $app;
  };

=head1 DESCRIPTION

Plack::Midleware::PathToQuery is a Plack middleware to prepend converted PATH_INFO to QUERY_STRING.
The conversion rule is as follows:

=for :list
* Initial '/' character is stripped if exists.
* '/' is converted to '&'.
* The first '-' for each path component is converted to '='.

Thus,

  /key1-value1/key2/key3-value3-value4

is converted to

  key1=value&key2&key3=value3-value4

The converted string is prepended to QUERY_STRING.
If QUERY_STRING is not empty, '&' is inserted between them.
After the process of this middleware, PATH_INFO becomes empty.

If C<debug =E<gt> 1> is specifed as argument, PATH_INFO/QUERY_STRING before/after the conversion are shown.

=cut
