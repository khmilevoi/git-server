docker  run --name git-server \
        -ti \
        -p 8083:80 \
        --mount type=bind,source="$(pwd)"/repos,target=/repos,bind-propagation=shared \
        --mount type=bind,source="$(pwd)"/nginx.conf,target=/etc/nginx/nginx.conf,bind-propagation=shared \
        --rm \
        git-server-image