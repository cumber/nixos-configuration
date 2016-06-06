{ buildPythonPackage, fetchurl }:
  buildPythonPackage rec {
    name = "powerline-gitstatus-1.2.1";

    src = fetchurl {
      url = "https://pypi.python.org/packages/d2/ca/f690fa0bf745c7700433f63cbca36931046b7a659bc1e72666e2c0799646/powerline-gitstatus-1.2.1.tar.gz";
      sha256 = "0844gcy823fynj29q31mz6b4gcrgsxwkkbz9zxn9l2qhv9hld1kb";
    };
  }
