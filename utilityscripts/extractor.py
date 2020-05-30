from builtins import print
from urllib.parse import urlparse
import re
import socket
import sys

if __name__ == '__main__':
    port: str
    hostIp: str

    urlString = re.search("(?P<url>https?://[^\s]+)", sys.argv[1]).group("url")
    urlString = urlString.replace("\";", "")
    out = urlparse(urlString)
    hostIp = socket.gethostbyname(out.hostname)
    port = str(out.port)

    print("allow out to " + hostIp + " proto tcp port " + port)
