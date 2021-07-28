docker exec git-server_git-server_1 git init /repos/$1 --bare
docker exec git-server_git-server_1 chmod -R 777 /repos/$1
