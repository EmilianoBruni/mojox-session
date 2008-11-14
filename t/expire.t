use Test::More tests => 4;

use lib 't/lib';

use NewDB;

use_ok('MojoX::Session');
use_ok('MojoX::Session::Store::DBI');
use_ok('MojoX::Session::Transport::Cookie');

use Mojo::Transaction;
use Mojo::Cookie::Request;

my $dbh = NewDB->dbh;
my $tx = Mojo::Transaction->new();

my $session = MojoX::Session->new(
    store     => MojoX::Session::Store::DBI->new(dbh       => $dbh),
    transport => MojoX::Session::Transport::Cookie->new(tx => $tx)
);

my $sid = $session->create();
$session->flush();

$session->expire();
$session->flush();

my $cookie = Mojo::Cookie::Request->new(name => 'sid', value => $sid);
$tx->req->cookies($cookie);

ok(not defined $session->load());