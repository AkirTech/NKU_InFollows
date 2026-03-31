echo Downloading Python...

wget -O python-3.13.12-embed-amd64.zip https://www.python.org/ftp/python/3.13.12/python-3.13.12-embed-amd64.zip
unzip python-3.13.12-embed-amd64.zip

echo Downloading pip...
cd python-3.13.12-embed-amd64
xcopy ../python3.13.12._pth . /Y
xcopy ../pip.ini . /Y

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

@REM You can also use: py -m ensurepip --upgrade

echo Building we-mp-rss...
git clone https://gh.llkk.cc/https://github.com/rachelos/we-mp-rss.git
@REM For local users.
@REM Original: git clone https://github.com/rachelos/we-mp-rss.git

cd ../we-mp-rss/ && ../python-3.13.12-embed-amd64/python.exe -m pip install -r we-mp-rss/requirements.txt

echo Building playwright...
../python-3.13.12-embed-amd64/python.exe -m playwright install
