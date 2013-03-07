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

=head1 DESCRIPTION

=cut
