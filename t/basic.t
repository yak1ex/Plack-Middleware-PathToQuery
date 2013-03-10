use strict;
use warnings;

use Test::More tests => 2;
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

test_psgi
	app => $app,
	client => sub {
		my $cb = shift;
		my $res = $cb->(GET '/');
		is $res->code, 200;
		is_deeply decode_json($res->content), { keys => [], parameters => {} };
	};
