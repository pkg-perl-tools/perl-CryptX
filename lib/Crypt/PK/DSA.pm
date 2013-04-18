package Crypt::PK::DSA;

use strict;
use warnings;

use Exporter 'import';
our %EXPORT_TAGS = ( all => [qw( dsa_encrypt dsa_decrypt dsa_sign dsa_verify )] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

use CryptX;
use Crypt::Digest;
use Carp;
use MIME::Base64 qw(encode_base64 decode_base64);

sub new { 
  my ($class, $f) = @_;
  my $self = _new();
  $self->import_key($f) if $f;
  return  $self;
}

sub export_key_pem {
  my ($self, $type) = @_;
  my $key = $self->export_key_der($type||'');
  return undef unless $key;
  
  return "-----BEGIN DSA PRIVATE KEY-----\n" .
         encode_base64($key) .
         "-----END DSA PRIVATE KEY-----\n " if $type eq 'private';
  
  return "-----BEGIN PUBLIC KEY-----\n" .
         encode_base64($key) .
         "-----END PUBLIC KEY-----\n " if $type eq 'public';
}

sub import_key {
  my ($self, $data) = @_;
  croak "FATAL: undefined key" unless $data;
  $data = _slurp_file($data) if -f $data;
  if ($data =~ /-----BEGIN (DSA PRIVATE|DSA PUBLIC|PRIVATE|PUBLIC) KEY-----(.*?)-----END/sg) {
    $data = decode_base64($2);
  }
  croak "FATAL: invalid key format" unless $data;
  $self->_import($data);
  return $self;
}

sub encrypt {
  my ($self, $data, $hash_name) = @_;
  $hash_name = Crypt::Digest::_trans_digest_name($hash_name||'SHA1');  
  return $self->_encrypt($data, $hash_name);
}

sub decrypt {
  my ($self, $data) = @_; 
  return $self->_decrypt($data);
}

sub sign {
  my ($self, $data) = @_;  
  return $self->_sign($data);
}

sub verify {
  my ($self, $sig, $data) = @_;  
  return $self->_verify($sig, $data);
}

### FUNCTIONS

sub dsa_encrypt {
  my $key = shift;
  $key = __PACKAGE__->new($key) unless ref $key;
  carp "FATAL: invalid 'key' param" unless ref($key) eq __PACKAGE__;
  return $key->encrypt(@_);
}

sub dsa_decrypt {
  my $key = shift;
  $key = __PACKAGE__->new($key) unless ref $key;
  carp "FATAL: invalid 'key' param" unless ref($key) eq __PACKAGE__;  
  return $key->decrypt(@_);
}

sub dsa_sign {
  my $key = shift;
  $key = __PACKAGE__->new($key) unless ref $key;
  carp "FATAL: invalid 'key' param" unless ref($key) eq __PACKAGE__;  
  return $key->sign(@_);
}

sub dsa_verify {
  my $key = shift;
  $key = __PACKAGE__->new($key) unless ref $key;
  carp "FATAL: invalid 'key' param" unless ref($key) eq __PACKAGE__;
  return $key->verify(@_);
}

sub _slurp_file {
  my $f = shift;
  local $/ = undef;
  open FILE, "<", $f or croak "FATAL: couldn't open file: $!";
  binmode FILE;
  my $string = <FILE>;
  close FILE;
  return $string;
}

1;

=pod

=head1 NAME

Crypt::PK::DSA - Public key cryptography based on DSA

=head1 SYNOPSIS

 ### OO interface
 
 #Encryption: Alice
 my $pub = Crypt::PK::DSA->new('Bob_pub_dsa1.der'); 
 my $ct = $pub->encrypt("secret message");
 #
 #Encryption: Bob (received ciphertext $ct)
 my $priv = Crypt::PK::DSA->new('Bob_priv_dsa1.der');
 my $pt = $priv->decrypt($ct);
  
 #Signature: Alice
 my $priv = Crypt::PK::DSA->new('Alice_priv_dsa1.der');
 my $sig = $priv->sign($message);
 #
 #Signature: Bob (received $message + $sig)
 my $pub = Crypt::PK::DSA->new('Alice_pub_dsa1.der');
 $pub->verify($sig, $message) or die "ERROR";
 
 #Shared secret
 my $priv = Crypt::PK::DSA->new('Alice_priv_dsa1.der');
 my $pub = Crypt::PK::DSA->new('Bob_pub_dsa1.der'); 
 my $shared_secret = $priv->shared_secret($pub);

 #Key generation
 my $pk = Crypt::PK::DSA->new();
 $pk->generate_key(30, 256);
 my $private_der = $pk->export_key_der('private');
 my $public_der = $pk->export_key_der('public');
 my $private_pem = $pk->export_key_pem('private');
 my $public_pem = $pk->export_key_pem('public');

 ### Functional interface
 
 #Encryption: Alice
 my $ct = dsa_encrypt('Bob_pub_dsa1.der', "secret message");
 #Encryption: Bob (received ciphertext $ct)
 my $pt = dsa_decrypt('Bob_priv_dsa1.der', $ct);
  
 #Signature: Alice
 my $sig = dsa_sign('Alice_priv_dsa1.der', $message);
 #Signature: Bob (received $message + $sig)
 dsa_verify('Alice_pub_dsa1.der', $sig, $message) or die "ERROR";
 
 #Shared secret
 my $shared_secret = dsa_shared_secret('Alice_priv_dsa1.der', 'Bob_pub_dsa1.der');

=head1 FUNCTIONS

=head2 dsa_encrypt

=head2 dsa_decrypt

=head2 dsa_sign

=head2 dsa_verify

=head2 dsa_shared_secret

=head1 METHODS

=head2 new

=head2 generate_key

 $pk->generate_key($group_size, $modulus_size);
 # $group_size  ... 15 < $group_size < 1024
 # $modulus_size .. ($modulus_size - $group_size) < 512
 
 # Bits of Security  $group_size  $modulus_size
 # 80                20           128
 # 120               30           256
 # 140               35           384
 # 160               40           512

=head2 import_key

=head2 export_key_der

=head2 export_key_pem

=head2 encrypt

=head2 decrypt

=head2 sign

=head2 verify

=head2 shared_secret

=head2 is_private

=head2 size
