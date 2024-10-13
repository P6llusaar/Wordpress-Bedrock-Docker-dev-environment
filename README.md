## Wordpress Bedrock Docker dev environment

A simple but powerfull Docker environment for bedrock devlopment based on the official Wordpress Docker image.

**NB! The instructions and some of the scripts are still untested, I'll start development on a new wordpress site soon, so I should be able to test it all out very very soon. If you have any questions before that however, feel free to open an issue.**


### What benefits does it have over the official wordpress image? 
* First and foremost it's preconfigured to work with Bedrock builds of Wordpress
* Pretty much everything that needs to be preconfigured is alreaady done
* The permission issues caused by mismatched user and group IDs have been solved (requires some easy manual configuration to get it to work)
* Some simple scripts/Wordpress plugins to make the development easier and more convinient
* Preinstalled and preconfigured xdebug extension to enable debugging php code more easily.
* Preconfigured vscode terminal profiles to easily enter the Docker container

### You mentioned tools that make development easier, what are they?
I'm glad you asked :) . 
* A wordpress plugin that enables you to log in to any account without entering it's password, just enter the username/e-mail and log in.
* A script to load uploads and the database dumps created by "Wp Migrate Lite" plugin
* Built in livereload server to reload scripts/css in the browser tab when you moddify the code so you don't need to manually refresh the page every time you make a little change
* A script that generates new translation files when you moddify php code (needs to be configured before you can use it and is therefore disabled by default)
* A script to compile .po files into .mo and .json files when the translation is changed

### Installation
1. Pull the project [I hope I won't forget to add the command]
1. [Generate a new bedrock project](https://roots.io/bedrock/docs/installation/) at the root folder or copy over your existing project. NB! The bedrock folder has to be called bedrock!
1. Make a copy of .env.example and call it just .env . **Keep in mind that the same .env file is used to configure both Docker and Bedrock.**
1. If you're on windows, you can probably skip this and the next step. If you're on linux (probaly same for mac but not sure) run following commands in terminal to figure out what your user and group id-s are:
    * user id: `id -u` 
    * group id: `id -g`
1. In .env file replace the exiting user and group id-s with the ones you just retrieved
1. If you already have another webserver on port 80 you need to change the port 80 into something else (if you have set up apache or nginx on your computer, then that's probably the case). Port 8080 is a good choice, if that is already taken 8081, 8082, ...
1. Run `docker-compose up -d`

#### (Optional) If you want to automatically generate .po translation files: 
1. Move updatePoFiles.sh from tools_disabled to tools.
1. Comment in one of the commands at the very end and point it towards the theme/plugin you want to modify

#### (Optional) Configuring liveReload:
If you want to make liveReload watch for changes in other folders as well, the required info for it is in tools/livereload.sh. 

To change the default port change the left side of this port pair `- 35729:35729` in docker-compose.yaml

### Some words about development
First off, if you need to run any wp-cli commands, you should do it within the container. The enviroment has built in composer so it might be easier to just run it's commands within the container as well. Use the docker VSCode terminal presets the environment comes with or run `exec -u www-data -it bedrock-dev /bin/bash` in terminal to enter the container.

If you want to modify or add any of the scripts or mu-plugins the project comes with, feel free to do so. **Don't touch "load-original-mu-plugins.php" or mu-plugins of bedrock will stop working**. Changes to mu-plugins will take place immediately. You need to restart the the environment using the following command at the root of the project `docker-compose restart` (no need to rebuild). If you feel like that tool could also be helpful to others, feel free to open a pull request.

### What if I don't want to use some of these scripts?
No problem, just move that script/plugin from tools/mu-plugins to tools_disabled/mu-plugins_disabled. **NB! Make sure you don't move the "load-original-mu-plugins.php" plugin or your own/bedrocks mu-pluggins won't load anymore!**

### Can I use it for my production site?
Please don't, it's really not meant for that.

### Why not just use Trellis?
You very much could and to be honest alot of it's features make me a bit jelaous. I personally had alot of trouble to get Vagrant to work properly and therefore decided that docker is probably a bit more foolproof. After all what I need is a dev environment that I can spin up in a couple of minutes on any computer I happen to sit down in front. 

There's also the fact Trellis runs your dev environment in a virtual machine, which adds more overhead. As long as you have a half decent system tho, it really shouldn't matter all that much.

### Known issues
* The container creates an empty folder at following path bedrock/web/app/original-mu-plugins. There's no easy workaround that allows loading development mu-plugins and mu-plugins of Bedrock itself. Git doesn't track empty folders so it should be fine as long as you don't add anything in that folder.
