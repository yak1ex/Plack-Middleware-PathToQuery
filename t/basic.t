use strict;
use warnings;

use Test::More;
use Plack::Test;
use Plack::Request;
use JSON;
use HTTP::Request::Common;

use Plack::Middleware::PathToQuery;

my $app = Plack::Middleware::PathToQuery->wrap(sub {
	my $env = shift;
	my $req = Plack::Request->new($env);
	return [ 200, ['Content-Type' => 'application/json'], [encode_json({
		keys => [$req->parameters->keys],
		parameters => $req->parameters->mixed,
	})]];
});

my @case = (
	['/', { keys => [], parameters => {} } ],
);
plan tests => @case * 2;

foreach my $case (@case) {
	test_psgi
		app => $app,
		client => sub {
			my $cb = shift;
			my $res = $cb->(GET $case->[0]);
			is $res->code, 200;
			is_deeply decode_json($res->content), $case->[1];
		};
}