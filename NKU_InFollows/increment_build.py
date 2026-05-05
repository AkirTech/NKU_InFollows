import json
import os

os.chdir(os.path.dirname(__file__))
with open('manifest.json', 'r') as f:
    package = json.load(f)
    version = package['Version']
    build = int(version.split("build")[1])
    build += 1
    version = version.split("build")[0] + "build" + str(build)
    package['Version'] = version
with open('manifest.json', 'w') as f:
        json.dump(package, f, indent=2)
       
