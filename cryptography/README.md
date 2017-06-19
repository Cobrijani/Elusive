This folder contains all configurations for security aspects


- instance.yml configuration for generating certificates for elasticsearch cluster

- [Guide for generating certificates for elasticsearch cluster](https://www.elastic.co/guide/en/x-pack/current/ssl-tls.html)

- [Certificate creation](https://github.com/jmmcatee/cracklord/wiki/Creating-Certificate-Authentication-From-Scratch-OpenSSL)

- [Non-interactive certificate generation](https://raymii.org/s/snippets/OpenSSL_generate_CSR_non-interactivemd.html)

- [Rules for keystores and truststores](https://stackoverflow.com/questions/23547418/what-must-be-contained-in-the-keystores-truststores-for-mutual-authentication)

- [Creating keystores and truststores](https://blogs.oracle.com/blogbypuneeth/steps-to-create-a-self-signed-certificate-using-openssl)

- script __generate-certs.sh__ contains code that generates all certificates needed for this system using open ssl

