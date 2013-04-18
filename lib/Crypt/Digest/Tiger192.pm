package Crypt::Digest::Tiger192;

### BEWARE - GENERATED FILE, DO NOT EDIT MANUALLY!

use strict;
use warnings;

use Exporter 'import';
our %EXPORT_TAGS = ( all => [qw( tiger192 tiger192_hex tiger192_base64 tiger192_file tiger192_file_hex tiger192_file_base64 )] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

use CryptX;
use base 'Crypt::Digest';

sub hashsize { Crypt::Digest::hashsize(__PACKAGE__) }

sub tiger192             { __PACKAGE__->new->add(@_)->digest }
sub tiger192_hex         { __PACKAGE__->new->add(@_)->hexdigest }
sub tiger192_base64      { __PACKAGE__->new->add(@_)->b64digest }

sub tiger192_file        { __PACKAGE__->new->addfile(@_)->digest }
sub tiger192_file_hex    { __PACKAGE__->new->addfile(@_)->hexdigest }
sub tiger192_file_base64 { __PACKAGE__->new->addfile(@_)->b64digest }

1;

=pod

=head1 NAME

Crypt::Digest::Tiger192 - Hash function Tiger-192 [size: 192 bits]

=head1 SYNOPSIS

   ### Functional interface:
   use Crypt::Digest::Tiger192 qw( tiger192 tiger192_hex tiger192_base64 tiger192_file tiger192_file_hex tiger192_file_base64 );

   # calculate digest from string/buffer
   $tiger192_raw = tiger192('data string');
   $tiger192_hex = tiger192_hex('data string');
   $tiger192_b64 = tiger192_base64('data string');
   # calculate digest from file
   $tiger192_raw = tiger192_file('filename.dat');
   $tiger192_hex = tiger192_file_hex('filename.dat');
   $tiger192_b64 = tiger192_file_base64('filename.dat');
   # calculate digest from filehandle
   $tiger192_raw = tiger192_file(*FILEHANDLE);
   $tiger192_hex = tiger192_file_hex(*FILEHANDLE);
   $tiger192_b64 = tiger192_file_base64(*FILEHANDLE);

   ### OO interface:
   use Crypt::Digest::Tiger192;

   $d = Crypt::Digest::Tiger192->new;
   $d->add('any data');
   $d->addfile('filename.dat');
   $d->addfile(*FILEHANDLE);
   $result_raw = $d->digest;    # raw bytes
   $result_hex = $d->hexdigest; # hexadecimal form
   $result_b64 = $d->b64digest; # Base64 form

=head1 DESCRIPTION

Provides an interface to the Tiger192 digest algorithm.

=head1 EXPORT

Nothing is exported by default.

You can export selected functions:

  use Crypt::Digest::Tiger192 qw(tiger192 tiger192_hex tiger192_base64 tiger192_file tiger192_file_hex tiger192_file_base64);

Or all of them at once:

  use Crypt::Digest::Tiger192 ':all';

=head1 FUNCTIONS

=head2 tiger192

Logically joins all arguments into a single string, and returns its Tiger192 digest encoded as a binary string.

 $tiger192_raw = tiger192('data string');
 #or
 $tiger192_raw = tiger192('any data', 'more data', 'even more data');

=head2 tiger192_hex

Logically joins all arguments into a single string, and returns its Tiger192 digest encoded as a hexadecimal string.

 $tiger192_hex = tiger192_hex('data string');
 #or
 $tiger192_hex = tiger192('any data', 'more data', 'even more data');

=head2 tiger192_base64

Logically joins all arguments into a single string, and returns its Tiger192 digest encoded as a Base64 string, B<with> trailing '=' padding.

 $tiger192_base64 = tiger192_base64('data string');
 #or
 $tiger192_base64 = tiger192('any data', 'more data', 'even more data');

=head2 tiger192_file

Reads file (defined by filename or filehandle) content, and returns its Tiger192 digest encoded as a binary string.

 $tiger192_raw = tiger192_file('filename.dat');
 #or
 $tiger192_raw = tiger192_file(*FILEHANDLE);

=head2 tiger192_file_hex

Reads file (defined by filename or filehandle) content, and returns its Tiger192 digest encoded as a hexadecimal string.

 $tiger192_hex = tiger192_file_hex('filename.dat');
 #or
 $tiger192_hex = tiger192_file_hex(*FILEHANDLE);

B<BEWARE:> You have to make sure that the filehandle is in binary mode before you pass it as argument to the addfile() method.

=head2 tiger192_file_base64

Reads file (defined by filename or filehandle) content, and returns its Tiger192 digest encoded as a Base64 string, B<with> trailing '=' padding.

 $tiger192_base64 = tiger192_file_base64('filename.dat');
 #or
 $tiger192_base64 = tiger192_file_base64(*FILEHANDLE);

=head1 METHODS

The OO interface provides the same set of functions as L<Crypt::Digest>.

=head2 new

 $d = Crypt::Digest::Tiger192->new();

=head2 clone

 $d->clone();

=head2 reset

 $d->reset();

=head2 add

 $d->add('any data');
 #or
 $d->add('any data', 'more data', 'even more data');

=head2 addfile

 $d->addfile('filename.dat');
 #or
 $d->addfile(*FILEHANDLE);

=head2 add_bits

 $d->addfile('filename.dat');
 #or
 $d->addfile(*FILEHANDLE);

=head2 hashsize

 $d->hashsize;
 #or
 Crypt::Digest::Tiger192->hashsize();
 #or
 Crypt::Digest::Tiger192::hashsize();

=head2 digest

 $result_raw = $d->digest();

=head2 hexdigest

 $result_hex = $d->hexdigest();

=head2 b64digest

 $result_base64 = $d->b64digest();

=head1 SEE ALSO

=over 4

=item L<CryptX|CryptX>, L<Crypt::Digest|Crypt::Digest>

=item L<http://en.wikipedia.org/wiki/Tiger_(cryptography)|http://en.wikipedia.org/wiki/Tiger_(cryptography)>

=back

=cut

__END__