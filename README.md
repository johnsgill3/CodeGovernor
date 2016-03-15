# Setup Guide
1. Clone the repository down to local machine:
  ```sh
  git clone https://github.com/CodeGovernor/CodeGovernor.git
  ```

1. Change into the CodeGovernor directory
  ```sh
  cd CodeGovernor
  ```

1. Make sure that ruby and bundler are installed
  ```sh
  $ ruby -v
  ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-darwin15]
  $ bundle -v
  Bundler version 1.11.2
  ```

1. Install all the gems needed to run application. This will read the Gemfile and get all the correct gems.
  ```sh
  bundle install
  ```

1. Make sure that postgresql is installed and running.
  ```sh
  $ postgres -V
  postgres (PostgreSQL) 9.5.1
  $ ps -ef | grep [p]ostgres:
    501  1320  1314   0 Thu11AM ??         0:00.07 postgres: checkpointer process       
    501  1321  1314   0 Thu11AM ??         0:01.17 postgres: writer process       
    501  1322  1314   0 Thu11AM ??         0:01.16 postgres: wal writer process       
    501  1323  1314   0 Thu11AM ??         0:02.39 postgres: autovacuum launcher process       
    501  1324  1314   0 Thu11AM ??         0:07.13 postgres: stats collector process
  ```
If not installed read the following [Guide](https://www.codefellows.org/blog/three-battle-tested-ways-to-install-postgresql#macosx)

1. Create the Database and Schema for running CodeGovernor.
  ```sh
  $ rake db:setup
  ```

1. Make sure that your GitHub Client ID and Client Secret Application Keys are present in the environment.
  ```sh
  $ env | grep GH_
  GH_CLIENT_SECRET=<your_application_client_secret>
  GH_CLIENT_ID=<your_application_client_id>
  ```
If not present read the following about creating one - [Registering your app](https://developer.github.com/guides/basics-of-authentication/#registering-your-app).  
Make sure that in the callback field to specify `http://localhost:3000/auth/github/callback`

1. Start CodeGovernor
  ```sh
  rails server -e development
  ```

1. Open http://localhost:3000 in your WebBrowser and should be presented with the index page.

## Errors
#### nokogiri zlib issue
If during the bundle install of nokogiri fails due the following error (which you find in the mkmf.log)
```
ld: warning: ignoring file /usr/local/lib/libz.dylib, file was built for i386 which is not the architecture being linked (x86_64): /usr/local/lib/libz.dylib
```
The simplest way to work around it is as follows:

1. Install zlib from homebrew
  ```sh
  $ brew install zlib
  ```
Mark down the build variables provided for `LDFLAGS` and `CPPFLAGS`. They should be something like:  
  ```sh
  LDFLAGS:    -L/usr/local/opt/zlib/lib
  CPPFLAGS:   -I/usr/local/opt/zlib/lib
  ```

2. Install nokogiri by itself specifying the path to zlib.
  ```sh
  $ brew install nokogiri -- --with-zlib-lib=/usr/local/opt/zlib/lib --with-zlib-include=/usr/local/opt/zlib/lib
  ```

3. After nokogiri installs successfully redo bundle install. Should successfully complete.
  ```sh
  $ bundle install
  ```
