;;;; yay!

(define ssl-files
  (map symbol->string
       '(s2_meth.c
	 s2_srvr.c
	 s2_clnt.c
	 s2_lib.c
	 s2_enc.c
	 s2_pkt.c
	 s3_meth.c
	 s3_srvr.c
	 s3_clnt.c
	 s3_lib.c
	 s3_enc.c
	 s3_pkt.c
	 s3_both.c
	 s23_meth.c
	 s23_srvr.c
	 s23_clnt.c
	 s23_lib.c
	 s23_pkt.c
	 t1_meth.c
	 t1_srvr.c
	 t1_clnt.c
	 t1_lib.c
	 t1_enc.c
	 t1_reneg.c
	 ssl_lib.c
	 ssl_err2.c
	 ssl_cert.c
	 ssl_sess.c
	 ssl_ciph.c
	 ssl_stat.c
	 ssl_rsa.c
	 ssl_asn1.c
	 ssl_txt.c
	 ssl_algs.c
	 bio_ssl.c
	 ssl_err.c
	 kssl.c)))

(for-each
 (lambda (f)
   (let ((fo (pathname-replace-extension f "o")))
     (make/proc
      (list
       (list fo (list f)
	     (lambda ()
	       (run (,TARGET_CC ,TARGET_CFLAGS -fPIC -DOPENSSL_BN_ASM_MONT -DAES_ASM -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM
				-DNO_WINDOWS_BRAINDEATH -DOPENSSL_THREADS -D_REENTRANT -DL_ENDIAN
				-DOPENSSL_NO_CAMELLIA -DOPENSSL_NO_CAPIENG -DOPENSSL_NO_CAST -DOPENSSL_NO_CMS
				-DOPENSSL_NO_GMP
				-DOPENSSL_NO_IDEA -DOPENSSL_NO_JPAKE -DOPENSSL_NO_MD2 -DOPENSSL_NO_MDC2 -DOPENSSL_NO_RC5
				-DOPENSSL_NO_SHA0 -DOPENSSL_NO_RFC3779 -DOPENSSL_NO_SEED -DOPENSSL_NO_STORE
				-DOPENSSL_NO_WHIRLPOOL -DOPENSSL_NO_HW -DOPENSSL_NO_ENGINE -DZLIB
				-I.. -I. -I../crypto -I../include
				-c ,f -o ,fo))))))))
 ssl-files)

(run (ar cru ../libssl.a
	 ,@(map (cut pathname-replace-extension <> "o") ssl-files)))