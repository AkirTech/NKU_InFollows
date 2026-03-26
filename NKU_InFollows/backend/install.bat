echo Downloading Python...

wget -O python-3.12.6-embed-amd64.zip https://www.python.org/ftp/python/3.12.6/python-3.12.6-embed-amd64.zip
unzip python-3.12.6-embed-amd64.zip

echo Downloading pip...
cd python-3.12.6-embed-amd64
xcopy ../python312._pth . /Y
xcopy ../pip.ini . /Y

echo Building we-mp-rss...
git clone https://gh.llkk.cc/https://github.com/rachelos/we-mp-rss.git
@REM Original: git clone https://github.com/rachelos/we-mp-rss.git

python3 -m pip install -r we-mp-rss/requirements.txt