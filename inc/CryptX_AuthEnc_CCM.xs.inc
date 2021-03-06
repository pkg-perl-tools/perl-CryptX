MODULE = CryptX       PACKAGE = Crypt::AuthEnc::CCM

Crypt::AuthEnc::CCM
_new(char * cipher_name, SV * key, SV * nonce, SV * adata, int tag_len, int pt_len)
    CODE:
    {
        unsigned char *k=NULL;
        STRLEN k_len=0;
        unsigned char *n=NULL;
        STRLEN n_len=0;
        unsigned char *h=NULL;
        STRLEN h_len=0;
        int rv, id;

        if (tag_len < 1 || tag_len > MAXBLOCKSIZE) croak("FATAL: invalid tag_len %d", tag_len);
        if (pt_len < 0)    croak("FATAL: invalid pt_len");
        if (!SvPOK(key))   croak("FATAL: key must be string/buffer scalar");
        k = (unsigned char *) SvPVbyte(key, k_len);
        if (!SvPOK(nonce)) croak("FATAL: nonce must be string/buffer scalar");
        n = (unsigned char *) SvPVbyte(nonce, n_len);
        if (!SvPOK(adata)) croak("FATAL: adata must be string/buffer scalar");
        h = (unsigned char *) SvPVbyte(adata, h_len);

        id = find_cipher(cipher_name);
        if (id == -1) croak("FATAL: find_cipfer failed for '%s'", cipher_name);

        Newz(0, RETVAL, 1, struct ccm_struct);
        if (!RETVAL) croak("FATAL: Newz failed");

        rv = ccm_init(&RETVAL->state, id, k, (unsigned long)k_len, pt_len, tag_len, h_len);
        if (rv != CRYPT_OK) {
          Safefree(RETVAL);
          croak("FATAL: ccm_init failed: %s", error_to_string(rv));
        }
        rv = ccm_add_nonce(&RETVAL->state, n, (unsigned long)n_len);
        if (rv != CRYPT_OK) {
          Safefree(RETVAL);
          croak("FATAL: ccm_add_nonce failed: %s", error_to_string(rv));
        }
        rv = ccm_add_aad(&RETVAL->state, h, (unsigned long)h_len);
        if (rv != CRYPT_OK) {
          Safefree(RETVAL);
          croak("FATAL: ccm_add_aad failed: %s", error_to_string(rv));
        }
        RETVAL->direction = -1;
        RETVAL->tag_len = tag_len;
        RETVAL->pt_len = pt_len;
    }
    OUTPUT:
        RETVAL

void
DESTROY(Crypt::AuthEnc::CCM self)
    CODE:
        Safefree(self);

Crypt::AuthEnc::CCM
clone(Crypt::AuthEnc::CCM self)
    CODE:
        Newz(0, RETVAL, 1, struct ccm_struct);
        if (!RETVAL) croak("FATAL: Newz failed");
        Copy(&self->state, &RETVAL->state, 1, struct ccm_struct);
    OUTPUT:
        RETVAL

SV *
encrypt_add(Crypt::AuthEnc::CCM self, SV * data)
    CODE:
    {
        int rv;
        STRLEN in_data_len;
        unsigned char *in_data, *out_data;

        in_data = (unsigned char *)SvPVbyte(data, in_data_len);
        if (in_data_len == 0) {
          RETVAL = newSVpvn("", 0);
        }
        else {
          if (self->direction == -1) self->direction = CCM_ENCRYPT;
          if (self->direction != CCM_ENCRYPT) {
            croak("FATAL: encrypt_add failed: wrong direction");
          }
          if (self->pt_len < in_data_len) croak("FATAL: encrypt_add failed: pt_len mismatch");
          RETVAL = NEWSV(0, in_data_len);
          SvPOK_only(RETVAL);
          SvCUR_set(RETVAL, in_data_len);
          out_data = (unsigned char *)SvPVX(RETVAL);
          rv = ccm_process(&self->state, in_data, (unsigned long)in_data_len, out_data, self->direction);
          if (rv != CRYPT_OK) {
            SvREFCNT_dec(RETVAL);
            croak("FATAL: ccm_process failed: %s", error_to_string(rv));
          }
          self->pt_len -= in_data_len;
        }
    }
    OUTPUT:
        RETVAL

SV *
decrypt_add(Crypt::AuthEnc::CCM self, SV * data)
    CODE:
    {
        int rv, i;
        STRLEN in_data_len;
        unsigned char *in_data, *out_data;

        in_data = (unsigned char *)SvPVbyte(data, in_data_len);
        if (in_data_len == 0) {
          RETVAL = newSVpvn("", 0);
        }
        else {
          if (self->direction == -1) self->direction = CCM_DECRYPT;
          if (self->direction != CCM_DECRYPT) {
            croak("FATAL: decrypt_add failed: wrong direction");
          }
          if (self->pt_len < in_data_len) croak("FATAL: decrypt_add failed: pt_len mismatch");
          RETVAL = NEWSV(0, in_data_len);
          SvPOK_only(RETVAL);
          SvCUR_set(RETVAL, in_data_len);
          out_data = (unsigned char *)SvPVX(RETVAL);
          rv = ccm_process(&self->state, out_data, (unsigned long)in_data_len, in_data, CCM_DECRYPT);
          if (rv != CRYPT_OK) {
            SvREFCNT_dec(RETVAL);
            croak("FATAL: ccm_process failed: %s", error_to_string(rv));
          }
          self->pt_len -= in_data_len;
        }
    }
    OUTPUT:
        RETVAL

void
encrypt_done(Crypt::AuthEnc::CCM self)
    PPCODE:
    {
        int rv;
        unsigned char tag[MAXBLOCKSIZE];
        unsigned long tag_len = self->tag_len;

        if (self->direction != CCM_ENCRYPT) {
          croak("FATAL: encrypt_done failed: wrong direction");
        }
        if (self->pt_len != 0) croak("FATAL: encrypt_done failed: pt_len mismatch");
        rv = ccm_done(&self->state, tag, &tag_len);
        if (rv != CRYPT_OK) croak("FATAL: ccm_done failed: %s", error_to_string(rv));
        XPUSHs(sv_2mortal(newSVpvn((char*)tag, tag_len)));
    }

void
decrypt_done(Crypt::AuthEnc::CCM self, ...)
    PPCODE:
    {
        int rv;
        unsigned char tag[MAXBLOCKSIZE];
        unsigned long tag_len = self->tag_len;
        STRLEN expected_tag_len;
        unsigned char *expected_tag;

        if (self->direction != CCM_DECRYPT) {
          croak("FATAL: decrypt_done failed: wrong direction");
        }
        if (self->pt_len != 0) croak("FATAL: decrypt_done failed: pt_len mismatch");
        rv = ccm_done(&self->state, tag, &tag_len);
        if (rv != CRYPT_OK) croak("FATAL: ccm_done failed: %s", error_to_string(rv));
        if (items == 1) {
          XPUSHs(sv_2mortal(newSVpvn((char*)tag, tag_len)));
        }
        else {
          if (!SvPOK(ST(1))) croak("FATAL: expected_tag must be string/buffer scalar");
          expected_tag = (unsigned char *) SvPVbyte(ST(1), expected_tag_len);
          if (expected_tag_len!=tag_len) {
            XPUSHs(sv_2mortal(newSViv(0))); /* false */
          }
          else if (memNE(expected_tag, tag, tag_len)) {
            XPUSHs(sv_2mortal(newSViv(0))); /* false */
          }
          else {
            XPUSHs(sv_2mortal(newSViv(1))); /* true */
          }
        }
    }
