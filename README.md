## Initial Setup

(You can skip to [this](https://github.com/BiggestLab/Elixir_Rocks_Game#running-the-game) step if you already have OTP >=26, Elixir >=1.15, and PostgreSQL configured.)

1. Install ASDF: https://asdf-vm.com/guide/getting-started.html

2. Delete your current Erlang installation:
  * If you installed it with apt, do "sudo apt purge erlang*"
  * If you installed with kerl, open ~/.bashrc and comment out the line "source /opt/erlang/25.3.2.2/activate"

3. Install erlang in asdf with these command:
   ```
      asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
      asdf install erlang latest
   ```
If using fish:
Add these lines to config.fish:

``` export JAVAC="/usr/bin/javac"
export WX_CONFIG="/usr/local/bin/wx-config"
export KERL_CONFIGURE_OPTIONS="--with-javac=$JAVAC --with-wx-config=$WX_CONFIG"
```

4. Activate the latest installed Erlang version:
```
asdf global erlang latest
```

5. Install elixir in asdf with these commands: 
```
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir latest
asdf global elixir latest
```

6. Install PostreSQL in your system:
```
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service
```

7. Create a user with a new database in PortgreSQL:
```
sudo -i -u postgres
psql
```
Create a new user:
```
createuser --interactive 
```

or you can run this command in the terminal
```
sudo -u postgres createuser --interactive
```
Out should look like this:
Output
Enter name of role to add: myusername
Shall the new role be a superuser? (y/n) y

Create new database
```
sudo -u postgres createdb mydb
```
Access the new database with the new user
```
sudo -u myusername psql mydb
```
Then update the user/role
```
ALTER USER myusername WITH PASSWORD 'password';
```
Replace myusername, password and mydb with the names and password you want.


## Running the Game

1. Clone the repo:
```
git clone git@github.com:BiggestLab/Elixir_Rocks_Game.git
```
```
cd Elixir_Rocks_Game/
```
2. Now run:

```
mix deps.get
```
3. Edit the dev.exs file in the project "config" folder. Change these lines to contain your data from PostgreSQL you setup previously:
```
username: "...",
password: "...",
database: "...",
```
4. Once that is done you can run this command to start the server: 

```
 mix phx.server
```

(Optional)
5. You can install inotify-tools for live code updates:

```
apt-get install inotify-tools
```
6. While running the phoenix server, open this in browser:
```
localhost:4000
```
