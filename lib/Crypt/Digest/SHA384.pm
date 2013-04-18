package Crypt::Digest::SHA384;

### BEWARE - GENERATED FILE, DO NOT EDIT MANUALLY!

use strict;
use warnings;

use Exporter 'import';
our %EXPORT_TAGS = ( all => [qw( sha384 sha384_hex sha384_base64 sha384_file sha384_file_hex sha384_file_base64 )] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

use CryptX;
use base 'Crypt::Digest';

sub hashsize { Crypt::Digest::hashsize(__PACKAGE__) }

sub sha384             { __PACKAGE__->new->add(@_)->digest }
sub sha384_hex         { __PACKAGE__->new->add(@_)->hexdigest }
sub sha384_base64      { __PACKAGE__->new->add(@_)->b64digest }

sub sha384_file        { __PACKAGE__->new->addfile(@_)->digest }
sub sha384_file_hex    { __PACKAGE__->new->addfile(@_)->hexdigest }
sub sha384_file_base64 { __PACKAGE__->new->addfile(@_)->b64digest }

1;

=pod

=head1 NAME

Crypt::Digest::SHA384 - Hash function SHA-384 [size: 384 bits]

=head1 SYNOPSIS

   ### Functional interface:
   use Crypt::Digest::SHA384 qw( sha384 sha384_hex sha384_base64 sha384_file sha384_file_hex sha384_file_base64 );

   # calculate digest from string/buffer
   $sha384_raw = sha384('data string');
   $sha384_hex = sha384_hex('data string');
   $sha384_b64 = sha384_base64('data string');
   # calculate digest from file
   $sha384_raw = sha384_file('filename.dat');
   $sha384_hex = sha384_file_hex('filename.dat');
   $sha384_b64 = sha384_file_base64('filename.dat');
   # calculate digest from filehandle
   $sha384_raw = sha384_file(*FILEHANDLE);
   $sha384_hex = sha384_file_hex(*FILEHANDLE);
   $sha384_b64 = sha384_file_base64(*FILEHANDLE);

   ### OO interface:
   use Crypt::Digest::SHA384;

   $d = Crypt::Digest::SHA384->new;
   $d->add('any data');
   $d->addfile('filename.dat');
   $d->addfile(*FILEHANDLE);
   $result_raw = $d->digest;    # raw bytes
   $result_hex = $d->hexdigest; # hexadecimal form
   $result_b64 = $d->b64digest; # Base64 form

=head1 DESCRIPTION

Provides an interface to the SHA384 digest algorithm.

=head1 EXPORT

Nothing is exported by default.

You can export selected functions:

  use Crypt::Digest::SHA384 qw(sha384 sha384_hex sha384_base64 sha384_file sha384_file_hex sha384_file_base64);

Or all of them at once:

  use Crypt::Digest::SHA384 ':all';

=head1 FUNCTIONS

=head2 sha384

Logically joins all arguments into a single string, and returns its SHA384 digest encoded as a binary string.

 $sha384_raw = sha384('data string');
 #or
 $sha384_raw = sha384('any data', 'more data', 'even more data');

=head2 sha384_hex

Logically joins all arguments into a single string, and returns its SHA384 digest encoded as a hexadecimal string.

 $sha384_hex = sha384_hex('data string');
 #or
 $sha384_hex = sha384('any data', 'more data', 'even more data');

=head2 sha384_base64

Logically joins all arguments into a single string, and returns its SHA384 digest encoded as a Base64 string, B<with> trailing '=' padding.

 $sha384_base64 = sha384_base64('data string');
 #or
 $sha384_base64 = sha384('any data', 'more data', 'even more data');

=head2 sha384_file

Reads file (defined by filename or filehandle) content, and returns its SHA384 digest encoded as a binary string.

 $sha384_raw = sha384_file('filename.dat');
 #or
 $sha384_raw = sha384_file(*FILEHANDLE);

=head2 sha384_file_hex

Reads file (defined by filename or filehandle) content, and returns its SHA384 digest encoded as a hexadecimal string.

 $sha384_hex = sha384_file_hex('filename.dat');
 #or
 $sha384_hex = sha384_file_hex(*FILEHANDLE);

B<BEWARE:> You have to make sure that the filehandle is in binary mode before you pass it as argument to the addfile() method.

=head2 sha384_file_base64

Reads file (defined by filename or filehandle) content, and returns its SHA384 digest encoded as a Base64 string, B<with> trailing '=' padding.

 $sha384_base64 = sha384_file_base64('filename.dat');
 #or
 $sha384_base64 = sha384_file_base64(*FILEHANDLE);

=head1 METHODS

The OO interface provides the same set of functions as L<Crypt::Digest>.

=head2 new

 $d = Crypt::Digest::SHA384->new();

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
 Crypt::Digest::SHA384->hashsize();
 #or
 Crypt::Digest::SHA384::hashsize();

=head2 digest

 $result_raw = $d->digest();

=head2 hexdigest

 $result_hex = $d->hexdigest();

=head2 b64digest

 $result_base64 = $d->b64digest();

=head1 SEE ALSO

=over 4

=item L<CryptX|CryptX>, L<Crypt::Digest|Crypt::Digest>

=item L<http://en.wikipedia.org/wiki/SHA-2|http://en.wikipedia.org/wiki/SHA-2>

=back

=cut

__END__